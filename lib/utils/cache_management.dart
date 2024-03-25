import 'package:flutter/foundation.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:get/get.dart';

import '../constants/message.dart';
import '../controllers/auth_controller.dart';
import '../enums/room.dart';
import '../models/objects/current_user.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import 'generate_shared_key.dart';

/// This file contains the cache management for the application
///
/// Steps:
/// 1. Fetch rooms, messages and sharedKeys from hive
/// 2. calculate the latest updatedAt for room and messages
/// 3. Fetch the latest rooms and messages from the server
/// 4. Merge the latest rooms and messages with the local data
///  4.1 if room already exists, update the local room
///  4.2 if room not exists, add the new room and message to the local data
///  4.3 if the room is deleted, delete the room and messages from the local data
///  4.4 if the message is deleted, delete the message from the local data
///  4.5 if the message is updated, update the message in the local data
///  4.6 if the message is new, add the message to the local data
///  4.7 sort the rooms and messages by updatedAt
///  4.8 store new sharedKeys to the local data
///
/// 5. Store the updated rooms, messages and sharedKeys to the hive
/// 6. set room and messages in roomController
class CacheManagement {
  const CacheManagement();

  Future<void> initializeCache() async {
    try {
      await _fetchRoomsAndMessages();
    } catch (e) {
      debugPrintStack(
          label: e.toString(), maxFrames: 10, stackTrace: StackTrace.current);
      Get.snackbar(
        'Error',
        'Error while fetching rooms and messages',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _fetchRoomsAndMessages() async {
    final List<RoomWithRoomUsersAndMessagesModel> rooms =
        RealmService.RoomWithRoomUsersModelService.getAllRooms();
    final List<MessageModel> messages =
        RealmService.RoomWithRoomUsersModelService.getAllMessages();
    final List<SharedKeyModel> sharedKeys =
        RealmService.sharedKeyModelService.getAllSharedKeys();

    final AuthController authController = Get.find<AuthController>();
    final CurrentUserModel user = authController.authenticatedUser!;

    final DateTime latestUpdatedAt = calculateLatestUpdatedAt(rooms, messages);

    final Map<String, dynamic> updatedData =
        await fetchUpdatedData(latestUpdatedAt);

    final List<dynamic> latestRooms = updatedData['rooms'] as List<dynamic>;
    final List<dynamic> latestMessages =
        updatedData['messages'] as List<dynamic>;
    final List<dynamic> latestSharedKeys =
        updatedData['sharedKeys'] as List<dynamic>;

    final Map<String, SharedKeyModel> sharedKeyMap =
        await mergeSharedKeys(sharedKeys, latestSharedKeys, user.userKey!);
    await mergeMessages(
        messages, latestMessages, sharedKeys, user, sharedKeyMap);
    mergeRooms(rooms, latestRooms);

    await storeRefreshedData(
      rooms,
      messages,
      sharedKeys,
    );
  }

  DateTime calculateLatestUpdatedAt(
    final List<RoomWithRoomUsersAndMessagesModel> rooms,
    final List<MessageModel> messages,
  ) {
    DateTime latestUpdatedAt = DateTime.utc(2024);
    // for (final RoomWithRoomUsersAndMessagesModel room in rooms) {
    //   if (room.updatedAt.isAfter(latestUpdatedAt)) {
    //     latestUpdatedAt = room.updatedAt;
    //   }
    // }
    // for (final MessageModel message in messages) {
    //   if (message.updatedAt.isAfter(latestUpdatedAt)) {
    //     latestUpdatedAt = message.updatedAt;
    //   }
    // }
    return latestUpdatedAt;
  }

  Future<Map<String, dynamic>> fetchUpdatedData(
    final DateTime latestUpdatedAt,
  ) async {
    return (await ServerApi.commonService.getUpdatedDataAfter(latestUpdatedAt))
        .response;
  }

  void mergeRooms(
    final List<RoomWithRoomUsersAndMessagesModel> rooms,
    final List<dynamic> latestRooms,
  ) {
    final Map<String, Map<int, RoomWithRoomUsersAndMessagesModel>>
        existingRoomsMap =
        <String, Map<int, RoomWithRoomUsersAndMessagesModel>>{};
    for (int i = 0; i < rooms.length; i++) {
      final RoomWithRoomUsersAndMessagesModel room = rooms[i];
      existingRoomsMap[room.id] = {i: room};
    }

    for (final dynamic latestRoom in latestRooms) {
      final Map<String, dynamic> latestRoomMap =
          latestRoom as Map<String, dynamic>;
      final RoomWithRoomUsersAndMessagesModel? existingRoom =
          existingRoomsMap[latestRoom['id'] as String]?.values.first;
      final List<UserModel> latestRoomUsers =
          (latestRoom['roomUsers'] as List<dynamic>)
              .map((final dynamic e) =>
                  UserModel.fromJson(e as Map<String, dynamic>))
              .toList();
      final RoomWithRoomUsersAndMessagesModel roomObj =
          RoomWithRoomUsersAndMessagesModel(
        latestRoomMap['id'] as String,
        latestRoomMap['name'] as String,
        latestRoomMap['type'] as String,
        DateTime.parse(latestRoom['createdAt'] as String),
        DateTime.parse(latestRoom['updatedAt'] as String),
        false,
        roomUsers: latestRoomUsers,
        description: latestRoomMap['description'] as String?,
        logoUrl: latestRoomMap['logoUrl'] as String?,
      );
      if (existingRoom == null) {
        rooms.add(roomObj);
      } else {
        final int index =
            existingRoomsMap[latestRoom['id'] as String]!.keys.first;
        rooms[index] = roomObj;
      }
    }
  }

  Future<Map<String, List<MessageModel>>> mergeMessages(
    final List<MessageModel> messages,
    final List<dynamic> latestMessages,
    final List<SharedKeyModel> sharedKeys,
    final CurrentUserModel user,
    final Map<String, SharedKeyModel> sharedKeyMap,
  ) async {
    final Map<String, Map<int, MessageModel>> existingMessagesMap =
        <String, Map<int, MessageModel>>{};
    for (int i = 0; i < messages.length; i++) {
      final MessageModel message = messages[i];
      existingMessagesMap[message.id] = {i: message};
    }

    /**
     * find all the users of duet rooms whom shared keys are not present in the sharedKeys
     * generate shared keys for those users
     * update the sharedKeys by adding the new shared keys
     *
     * decrypt all the messages which are edited or new
     */

    final Map<String, UserModel> missingSharedKeyUsers = <String, UserModel>{};

    for (final dynamic latestMessage in latestMessages) {
      final Map<String, dynamic> latestMessageMap =
          latestMessage as Map<String, dynamic>;
      if ((latestMessageMap['room'] as Map<String, dynamic>)['type'] ==
          RoomType.DUET.name) {
        final Map<String, dynamic> otherUser;
        if ((latestMessageMap['senderUser'] as Map<String, dynamic>)['id'] ==
            user.id) {
          otherUser = latestMessageMap['otherUser'] as Map<String, dynamic>;
        } else {
          otherUser = latestMessageMap['senderUser'] as Map<String, dynamic>;
        }

        final SharedKeyModel? existingSharedKey =
            sharedKeyMap[otherUser['id'] as String];
        if (existingSharedKey == null &&
            !missingSharedKeyUsers.containsKey(otherUser['id'] as String)) {
          missingSharedKeyUsers[otherUser['id'] as String] =
              UserModel.fromJson(otherUser);
        }
      }
    }

    final List<UserWiseSharedKeyResponse> missingSharedKeys =
        await getSharedKeyWithOtherUsers(missingSharedKeyUsers.values.toList(),
            force: true);

    for (final UserWiseSharedKeyResponse missingSharedKey
        in missingSharedKeys) {
      final SharedKeyModel sharedKey = SharedKeyModel(
        missingSharedKey.sharedKey,
        DateTime.now(),
        DateTime.now(),
        forUserId: missingSharedKey.userId,
      );
      sharedKeyMap[missingSharedKey.userId] = sharedKey;
      sharedKeys.add(sharedKey);
    }
    final Map<String, List<MessageModel>> roomWiseMessages =
        <String, List<MessageModel>>{};

    await Future.wait(latestMessages.map((final dynamic latestMessage) async {
      final Map<String, dynamic> latestMessageMap =
          latestMessage as Map<String, dynamic>;
      final MessageModel? existingMessage =
          existingMessagesMap[latestMessage['id'] as String]?.values.first;
      final Map<String, dynamic> room =
          latestMessageMap['room'] as Map<String, dynamic>;
      final Map<String, dynamic> otherUser;
      if ((latestMessageMap['senderUser'] as Map<String, dynamic>)['id'] ==
          user.id) {
        otherUser = latestMessageMap['otherUser'] as Map<String, dynamic>;
      } else {
        otherUser = latestMessageMap['senderUser'] as Map<String, dynamic>;
      }
      final bool isRoomTypeDuet = room['type'] == RoomType.DUET.name;

      final String message;
      final bool isMessageNotEdited = existingMessage?.editedAt != null &&
          existingMessage!.editedAt ==
              DateTime.parse(latestMessage['editedAt'] as String);

      if (isMessageNotEdited) {
        message = existingMessage?.message ?? '';
      } else {
        if (isRoomTypeDuet) {
          message = await AesGcmEncryption(
            secretKey: sharedKeyMap[otherUser['id'] as String]!.key,
          ).decryptString(latestMessageMap['message'] as String);
        } else {
          message = await AesGcmEncryption(
            secretKey: sharedKeyMap[room['id'] as String]!.key,
          ).decryptString(latestMessageMap['message'] as String);
        }
      }
      final MessageModel messageObj = MessageModel(
        latestMessageMap['id'] as String,
        room['id'] as String,
        message,
        latestMessageMap['type'] as String,
        latestMessageMap['isDeleted'] as bool,
        DateTime.parse(latestMessage['createdAt'] as String),
        DateTime.parse(latestMessage['updatedAt'] as String),
        MessageStatus.SENT,
        messageStatuses: latestMessageMap['messageStatuses'] != null
            ? (latestMessageMap['messageStatuses'] as List<dynamic>)
                .map((final dynamic e) =>
                    MessageStatusModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : <MessageStatusModel>[],
        senderUser: MessageUserModel.fromJson(
          latestMessage['senderUser'] as Map<String, dynamic>,
        ),
        belongsToMessage: latestMessageMap['belongsToMessageId'] == null
            ? null
            : existingMessagesMap[
                    latestMessageMap['belongsToMessageId'] as String]
                ?.values
                .first,
        forwardedFromRoomId: latestMessageMap['forwardedFromRoomId'] as String?,
        editedAt: latestMessageMap['editedAt'] == null
            ? null
            : DateTime.parse(latestMessage['editedAt'] as String),
        // status:
      );
      if (existingMessage == null) {
        messages.add(messageObj);

        existingMessagesMap[latestMessage['id'] as String] = {
          messages.length - 1: messageObj
        };
        roomWiseMessages[room['id'] as String] ??= <MessageModel>[];
        roomWiseMessages[room['id'] as String]!.add(messageObj);
      } else {
        final int index =
            existingMessagesMap[latestMessage['id'] as String]!.keys.first;

        messages[index] = messageObj;
      }
    }));

    return roomWiseMessages;
  }

  Future<Map<String, SharedKeyModel>> mergeSharedKeys(
    final List<SharedKeyModel> sharedKeys,
    final List<dynamic> latestSharedKeys,
    final String userKey,
  ) async {
    final List<SharedKeyModel> mergedSharedKeys = <SharedKeyModel>[];
    final Map<String, SharedKeyModel> existingSharedKeysMap =
        <String, SharedKeyModel>{};
    for (final SharedKeyModel sharedKey in sharedKeys) {
      if (sharedKey.forUserId != null) {
        existingSharedKeysMap[sharedKey.forUserId!] = sharedKey;
      }
      if (sharedKey.forRoomId != null) {
        existingSharedKeysMap[sharedKey.forRoomId!] = sharedKey;
      }
    }

    await Future.wait(
        latestSharedKeys.map((final dynamic latestSharedKey) async {
      final Map<String, dynamic> latestSharedKeyMap =
          latestSharedKey as Map<String, dynamic>;
      final SharedKeyModel? existingSharedKey = existingSharedKeysMap[
              latestSharedKey['forUserId'] as String? ?? ''] ??
          existingSharedKeysMap[latestSharedKey['forRoomId'] as String? ?? ''];

      if (existingSharedKey == null) {
        final String decryptedSharedKey = await AesGcmEncryption(
          secretKey: userKey,
        ).decryptString(latestSharedKeyMap['key'] as String);

        sharedKeys.add(SharedKeyModel(
          decryptedSharedKey,
          DateTime.parse(latestSharedKey['createdAt'] as String),
          DateTime.parse(latestSharedKey['updatedAt'] as String),
          forUserId: latestSharedKeyMap['forUserId'] as String?,
          forRoomId: latestSharedKeyMap['forRoomId'] as String?,
        ));
      }
    }));

    return existingSharedKeysMap;
  }

  Future<void> storeRefreshedData(
    final List<RoomWithRoomUsersAndMessagesModel> rooms,
    final List<MessageModel> messages,
    final List<SharedKeyModel> sharedKeys,
  ) async {
    RealmService.RoomWithRoomUsersModelService.resetRooms(rooms);
    RealmService.RoomWithRoomUsersModelService.resetMessages(messages);
    RealmService.sharedKeyModelService.resetSharedKeys(sharedKeys);
  }
}
