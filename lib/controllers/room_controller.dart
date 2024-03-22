import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../constants/message.dart';
import '../enums/room.dart';
import '../models/objects/current_user.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../models/requests/send_message_request.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import 'auth_controller.dart';
import 'rooms_controller.dart';

class RoomController extends GetxController {
  late final RoomWithRoomUsersAndMessagesModel room;

  late final TextEditingController messageController;

  late final RoomsController _roomsController;
  String? _sharedKey;

  Stream<RealmResultsChanges<MessageModel>>? messagesStream;

  late final ScrollController scrollController;

  Future _extractSharedKey() async {
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
            await getSharedKeyWithOtherUsers([otherUser], force: true);
        if (sharedKeyRes.first?.sharedKey == null) {
          return;
        }
        _sharedKey = sharedKeyRes.first.sharedKey;
      } else {
        _sharedKey = sharedKey!.key;
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
    return RealmService.roomWithRoomUsersAndMessagesModelService
        .getRoom(roomId)!;
  }

  @override
  void onInit() {
    super.onInit();
    messageController = TextEditingController();
    _roomsController = Get.find<RoomsController>();
    room = getRoomDetails();
    messagesStream = RealmService.roomWithRoomUsersAndMessagesModelService
        .getRoomMessageStream(room.id);
    scrollController = ScrollController();
  }

  @override
  void onClose() {
    messageController.dispose();
    scrollController.dispose();
    super.onClose();
  }

  Future<String> encryptMessage(final String message) async {
    if (_sharedKey == null) {
      await _extractSharedKey();
    }
    return AesGcmEncryption(secretKey: _sharedKey!).encryptString(message);
  }

  Future sendMessage({
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
}
