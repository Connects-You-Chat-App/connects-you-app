import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../enums/room.dart';
import '../models/base/message.dart';
import '../models/base/user.dart';
import '../models/common/current_user.dart';
import '../models/common/rooms_with_room_users.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/requests/send_message_request.dart';
import '../service/server.dart';
import '../utils/generate_shared_key.dart';
import 'auth_controller.dart';
import 'rooms_controller.dart';

class RoomController extends GetxController {
  late final RoomWithRoomUsers room;

  late final TextEditingController messageController;

  late final RoomsController _roomsController;
  late final String _sharedKey;

  Future _extractSharedKey() async {
    final AuthController authController = Get.find<AuthController>();
    final CurrentUser currentUser = authController.authenticatedUser!;
    final Box<SharedKeyHiveObject> sharedKeyBox =
        Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);

    inspect(sharedKeyBox.values.toList());
    inspect(room.roomUsers);

    if (room.type == RoomType.DUET) {
      final User otherUser = room.roomUsers.firstWhere(
        (final User user) => user.id != currentUser.id,
      );
      final SharedKeyHiveObject? sharedKey = sharedKeyBox.get(otherUser.id);

      if (sharedKey == null) {
        final List<UserWiseSharedKeyResponse> sharedKeyRes =
            await getSharedKeyWithOtherUsers([otherUser], force: true);
        if (sharedKeyRes.first?.sharedKey == null) {
          return;
        }
        _sharedKey = sharedKeyRes.first.sharedKey;
      } else {
        _sharedKey = sharedKey!.sharedKey;
      }
      return;
    }
    _sharedKey = sharedKeyBox.get(room.id)!.sharedKey;
    return;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    room = Get.arguments['room'] as RoomWithRoomUsers;
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
    final Message? belongsToMessage,
  }) async {
    final AuthController authController = Get.find<AuthController>();
    final CurrentUser currentUser = authController.authenticatedUser!;
    final String encryptedMessage = await encryptMessage(message);
    final Message messageObj = Message(
      id: randomUUID(),
      roomId: room.id,
      senderUser: MessageUser(
        id: currentUser.id,
        name: currentUser.name,
        email: currentUser.email,
        photoUrl: currentUser.photoUrl,
      ),
      message: message,
      type: type,
      isDeleted: false,
      belongsToMessage: belongsToMessage,
      status: MessageStatus.PENDING,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );

    // _roomsController.addMessageToRoom(messageObj);

    await ServerApi.messageService.sendMessage(SendMessageRequest(
      messageId: messageObj.id,
      roomId: messageObj.roomId,
      message: encryptedMessage,
      type: messageObj.type,
      belongsToMessageId: messageObj.belongsToMessage?.id,
    ));
  }
}