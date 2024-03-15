import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart';

import '../constants/message.dart';
import '../enums/room.dart';
import '../models/objects/current_user.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../models/requests/send_message_request.dart';
import '../services/database/shared_key_service.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import 'auth_controller.dart';
import 'rooms_controller.dart';

class RoomController extends GetxController {
  late final RoomWithRoomUsersAndMessagesModel room;

  late final TextEditingController messageController;

  late final RoomsController _roomsController;
  late final String _sharedKey;

  Future _extractSharedKey() async {
    final AuthController authController = Get.find<AuthController>();
    final CurrentUserModel currentUser = authController.authenticatedUser!;

    inspect(room.roomUsers);

    if (room.type == RoomType.DUET) {
      final UserModel otherUser = room.roomUsers.firstWhere(
        (final UserModel user) => user.id != currentUser.id,
      );
      final SharedKeyModel? sharedKey =
          SharedKeyModelService().getSharedKeyForUser(
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
      return;
    }
    _sharedKey =
        SharedKeyModelService().getSharedKeyForRoom(room.id)?.key ?? '';
    return;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    room = Get.arguments['room'] as RoomWithRoomUsersAndMessagesModel;
    messageController = TextEditingController();
    await _extractSharedKey();
    _roomsController = Get.find<RoomsController>();
  }

  @override
  void onClose() {
    messageController.dispose();
    super.onClose();
  }

  Future<String> encryptMessage(final String message) {
    return AesGcmEncryption(secretKey: _sharedKey).encryptString(message);
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
      type,
      message,
      false,
      DateTime.now().toUtc(),
      DateTime.now().toUtc(),
      MessageStatus.PENDING,
      senderUser: MessageUserModel(
        currentUser.id,
        currentUser.name,
        currentUser.email,
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
  }
}