import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart' hide Response;
import 'package:realm/realm.dart';

import '../constants/message.dart';
import '../constants/socket_events.dart';
import '../enums/room.dart';
import '../models/objects/current_user.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../models/requests/send_message_request.dart';
import '../models/responses/main.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import 'auth_controller.dart';
import 'rooms_controller.dart';
import 'socket_controller.dart';

class RoomController extends GetxController {
  late final RoomWithRoomUsersAndMessagesModel room;

  final RxSet<UserModel> _typingUsers = RxSet<UserModel>();
  Map<String, UserModel>? _roomUsersMap;

  late final TextEditingController messageController;

  late final RoomsController _roomsController;
  String? _sharedKey;

  Stream<RealmResultsChanges<MessageModel>>? messagesStream;

  Set<UserModel> get typingUsers => _typingUsers;

  late final ScrollController scrollController;

  late final SocketController _socketController;

  late final AuthController _authController;

  Future<void> _extractSharedKey() async {
    final AuthController authController = Get.find<AuthController>();
    final CurrentUserModel currentUser = authController.authenticatedUser!;

    if (room.type == RoomType.DUET.name) {
      final UserModel otherUser = room.roomUsers.firstWhere(
        (final UserModel user) => user.id != currentUser.id,
      );
      final SharedKeyModel? sharedKey =
          RealmService.sharedKeyModelService.getSharedKeyForUser(
        otherUser.id,
      );

      if (sharedKey == null) {
        final List<UserWiseSharedKeyResponse> sharedKeyRes =
            await getSharedKeyWithOtherUsers(<UserModel>[otherUser],
                force: true);
        _sharedKey = sharedKeyRes.first.sharedKey;
      } else {
        _sharedKey = sharedKey.key;
      }
    } else {
      _sharedKey =
          RealmService.sharedKeyModelService.getSharedKeyForRoom(room.id)!.key;
    }
  }

  RoomWithRoomUsersAndMessagesModel getRoomDetails() {
    final Map<String, dynamic> args = Get.arguments as Map<String, dynamic>;
    final RoomWithRoomUsersAndMessagesModel? room =
        args['room'] as RoomWithRoomUsersAndMessagesModel?;
    if (room != null) {
      return room;
    }
    final String roomId = args['roomId'] as String;
    return RealmService.RoomWithRoomUsersModelService.getRoom(roomId);
  }

  Timer? _typingTimer;

  void onTyping(final dynamic data) {
    if (data['roomId'] == room.id &&
        data['userId'] != _authController.authenticatedUser!.id) {
      _roomUsersMap ??= <String, UserModel>{
        for (final UserModel user in room.roomUsers) user.id: user,
      };
      if (_typingTimer != null && _typingTimer!.isActive) {
        _typingTimer!.cancel();
      }
      // _typingUser.value = _roomUsersMap![data['userId'] as String];
      _typingUsers.add(_roomUsersMap![data['userId'] as String]!);
      _typingTimer = Timer(
        const Duration(seconds: 2),
        () {
          _typingUsers.remove(_roomUsersMap![data['userId'] as String]);
        },
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
    _roomsController = Get.find<RoomsController>();
    room = getRoomDetails();
    messagesStream =
        RealmService.RoomWithRoomUsersModelService.getRoomMessageStream(
            room.id);
    scrollController = ScrollController();
    _authController = Get.find<AuthController>();
    _socketController = Get.find<SocketController>();
    _socketController.socket.on(SocketEvents.USER_TYPING, onTyping);
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    _socketController.socket.off(SocketEvents.USER_TYPING, onTyping);
    super.onClose();
  }

  Future<String> encryptMessage(final String message) async {
    if (_sharedKey == null) {
      await _extractSharedKey();
    }
    return AesGcmEncryption(secretKey: _sharedKey!).encryptString(message);
  }

  Future<void> sendMessage({
    required final String message,
    required final String type,
    final MessageModel? belongsToMessage,
  }) async {
    final AuthController authController = Get.find<AuthController>();
    final CurrentUserModel currentUser = authController.authenticatedUser!;
    final String encryptedMessage = await encryptMessage(message);

    final MessageModel messageObj = MessageModel(
      randomUUID(),
      room.id,
      message,
      type,
      false,
      DateTime.now().toUtc(),
      DateTime.now().toUtc(),
      MessageStatus.PENDING,
      senderUser: MessageUserModel(
        currentUser.id,
        currentUser.name,
        currentUser.email,
        currentUser.publicKey,
        photoUrl: currentUser.photoUrl,
      ),
      belongsToMessage: belongsToMessage,
    );

    _roomsController.addMessageToRoom(messageObj);
    messageController.clear();

    await ServerApi.messageService.sendMessage(SendMessageRequest(
      messageId: messageObj.id,
      roomId: messageObj.roomId,
      message: encryptedMessage,
      type: messageObj.type,
      belongsToMessageId: messageObj.belongsToMessage?.id,
    ));

    scrollController.animateTo(
      -scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> markMessagesAsRead(final List<String> messageIds) async {
    final Response<bool> res =
        await ServerApi.messageService.markMessagesAsRead(room.id, messageIds);
    if (res.response) {
      RealmService.RoomWithRoomUsersModelService.markSenderMessageRead(
        messageIds,
      );
    }
  }

  void sendUserTypingStatus() {
    _socketController.socket.emit(SocketEvents.USER_TYPING, {
      'roomId': room.id,
      'userId': _authController.authenticatedUser!.id,
    });
  }
}
