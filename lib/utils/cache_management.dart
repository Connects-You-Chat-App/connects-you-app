import 'dart:developer';

import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../controllers/auth_controller.dart';
import '../enums/room.dart';
import '../models/base/message.dart';
import '../models/base/user.dart';
import '../models/common/current_user.dart';
import '../models/objects/message_hive_object.dart';
import '../models/objects/room_with_room_users_hive_object.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/objects/user_hive_object.dart';
import '../service/server.dart';
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
    await _fetchRoomsAndMessages();
  }

  Future<void> _fetchRoomsAndMessages() async {
    final Box<RoomWithRoomUsersHiveObject> roomBox =
        Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    final Box<List<MessageHiveObject>> messageBox =
        Hive.box<List<MessageHiveObject>>(HiveBoxKeys.MESSAGES);
    final Box<SharedKeyHiveObject> sharedKeyBox =
        Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);

    final List<RoomWithRoomUsersHiveObject> rooms = roomBox.values.toList();
    final List<dynamic> messages = messageBox.values
        .expand((final List<dynamic> element) => element)
        .toList();
    final List<SharedKeyHiveObject> sharedKeys = sharedKeyBox.values.toList();

    inspect({
      'rooms': rooms,
      'messages': messages,
      'sharedKeys': sharedKeys,
    });

    final AuthController authController = Get.find<AuthController>();
    final CurrentUser user = authController.authenticatedUser!;

    final DateTime latestUpdatedAt =
        calculateLatestUpdatedAt(rooms, messages as List<MessageHiveObject>);

    final Map<String, dynamic> updatedData =
        await fetchUpdatedData(latestUpdatedAt);

    final List<dynamic> latestRooms = updatedData['rooms'] as List<dynamic>;
    final List<dynamic> latestMessages =
        updatedData['messages'] as List<dynamic>;
    final List<dynamic> latestSharedKeys =
        updatedData['sharedKeys'] as List<dynamic>;

    final List<SharedKeyHiveObject> mergedSharedKeys =
        await mergeSharedKeys(sharedKeys, latestSharedKeys, user.userKey!);
    final List<RoomWithRoomUsersHiveObject> mergedRooms =
        mergeRooms(rooms, latestRooms);
    final List<MessageHiveObject> mergedMessages = await mergeMessages(
      messages,
      latestMessages,
      mergedSharedKeys,
      user,
    );

    await storeRefreshedData(roomBox, messageBox, sharedKeyBox, mergedRooms,
        mergedMessages, mergedSharedKeys);
    inspect({
      'mergedRooms': mergedRooms,
      'mergedMessages': mergedMessages,
      'mergedSharedKeys': mergedSharedKeys,
    });
  }

  DateTime calculateLatestUpdatedAt(
    final List<RoomWithRoomUsersHiveObject> rooms,
    final List<MessageHiveObject> messages,
  ) {
    DateTime latestUpdatedAt = DateTime.fromMicrosecondsSinceEpoch(0);
    for (final RoomWithRoomUsersHiveObject room in rooms) {
      if (room.updatedAt.isAfter(latestUpdatedAt)) {
        latestUpdatedAt = room.updatedAt;
      }
    }
    for (final MessageHiveObject message in messages) {
      if (message.updatedAt.isAfter(latestUpdatedAt)) {
        latestUpdatedAt = message.updatedAt;
      }
    }
    return latestUpdatedAt;
  }

  Future<Map<String, dynamic>> fetchUpdatedData(
    final DateTime latestUpdatedAt,
  ) async {
    return (await ServerApi.commonService.getUpdatedDataAfter(latestUpdatedAt))
        .response;
  }

  List<RoomWithRoomUsersHiveObject> mergeRooms(
    final List<RoomWithRoomUsersHiveObject> rooms,
    final List<dynamic> latestRooms,
  ) {
    final Map<String, RoomWithRoomUsersHiveObject> existingRoomsMap =
        <String, RoomWithRoomUsersHiveObject>{};
    for (final RoomWithRoomUsersHiveObject room in rooms) {
      existingRoomsMap[room.id] = room;
    }

    inspect({
      'existingRoomsMap': existingRoomsMap,
      'latestRooms': latestRooms,
    });

    return rooms +
        latestRooms.map((final dynamic latestRoom) {
          final Map<String, dynamic> latestRoomMap =
              latestRoom as Map<String, dynamic>;
          final RoomWithRoomUsersHiveObject? existingRoom =
              existingRoomsMap[latestRoom['id'] as String];
          final List<UserHiveObject> latestRoomUsers =
              (latestRoom['roomUsers'] as List<dynamic>)
                  .map(
                    (final dynamic e) => UserHiveObject.fromUser(
                      User.fromJson(
                        e as Map<String, dynamic>,
                      ),
                    ),
                  )
                  .toList();
          if (existingRoom == null) {
            return RoomWithRoomUsersHiveObject(
              id: latestRoomMap['id'] as String,
              name: latestRoomMap['name'] as String,
              type: latestRoomMap['type'] as String,
              createdAt: DateTime.parse(latestRoom['createdAt'] as String),
              updatedAt: DateTime.parse(latestRoom['updatedAt'] as String),
              roomUsers: latestRoomUsers,
              description: latestRoomMap['description'] as String?,
              logoUrl: latestRoomMap['logoUrl'] as String?,
            );
          } else {
            return existingRoom.copyWith(
              name: latestRoomMap['name'] as String,
              updatedAt: DateTime.parse(latestRoom['updatedAt'] as String),
              roomUsers: latestRoomUsers,
            );
          }
        }).toList();
  }

  Future<List<MessageHiveObject>> mergeMessages(
    final List<MessageHiveObject> messages,
    final List<dynamic> latestMessages,
    final List<SharedKeyHiveObject> sharedKeys,
    final CurrentUser user,
  ) async {
    final Map<String, MessageHiveObject> existingMessagesMap =
        <String, MessageHiveObject>{};
    for (final MessageHiveObject message in messages) {
      existingMessagesMap[message.id] = message;
    }
    final Map<String, SharedKeyHiveObject> existingSharedKeyMap =
        <String, SharedKeyHiveObject>{};
    for (final SharedKeyHiveObject sharedKey in sharedKeys) {
      if (sharedKey.forUserId != null) {
        existingSharedKeyMap[sharedKey.forUserId!] = sharedKey;
      }
      if (sharedKey.forRoomId != null) {
        existingSharedKeyMap[sharedKey.forRoomId!] = sharedKey;
      }
    }

    /**
     * find all the users of duet rooms whom shared keys are not present in the sharedKeys
     * generate shared keys for those users
     * update the sharedKeys by adding the new shared keys
     *
     * decrypt all the messages which are edited or new
     */

    final Map<String, User> missingSharedKeyUsers = <String, User>{};

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

        final SharedKeyHiveObject? existingSharedKey =
            existingSharedKeyMap[otherUser['id'] as String];
        if (existingSharedKey == null &&
            !missingSharedKeyUsers.containsKey(otherUser['id'] as String)) {
          missingSharedKeyUsers[otherUser['id'] as String] =
              User.fromJson(otherUser);
        }
      }
    }

    final List<UserWiseSharedKeyResponse> missingSharedKeys =
        await getSharedKeyWithOtherUsers(missingSharedKeyUsers.values.toList(),
            force: true);

    for (final UserWiseSharedKeyResponse missingSharedKey
        in missingSharedKeys) {
      final SharedKeyHiveObject sharedKey = SharedKeyHiveObject(
        sharedKey: missingSharedKey.sharedKey,
        forUserId: missingSharedKey.userId,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      existingSharedKeyMap[missingSharedKey.userId] = sharedKey;
      sharedKeys.add(sharedKey);
    }

    return messages +
        (await Future.wait(
            latestMessages.map((final dynamic latestMessage) async {
          final Map<String, dynamic> latestMessageMap =
              latestMessage as Map<String, dynamic>;
          final MessageHiveObject? existingMessage =
              existingMessagesMap[latestMessage['id'] as String];
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
                secretKey:
                    existingSharedKeyMap[otherUser['id'] as String]!.sharedKey,
              ).decryptString(latestMessageMap['message'] as String);
            } else {
              message = await AesGcmEncryption(
                secretKey:
                    existingSharedKeyMap[room['id'] as String]!.sharedKey,
              ).decryptString(latestMessageMap['message'] as String);
            }
          }
          // TODO: handle message.status when possible
          MessageHiveObject? messageToReturn;
          if (existingMessage == null) {
            messageToReturn = MessageHiveObject(
              id: latestMessageMap['id'] as String,
              roomId: room['id'] as String,
              senderUser: MessageUserHiveObject.fromMessageUser(
                MessageUser.fromJson(
                  latestMessage['senderUser'] as Map<String, dynamic>,
                ),
              ),
              message: message,
              createdAt: DateTime.parse(latestMessage['createdAt'] as String),
              updatedAt: DateTime.parse(latestMessage['updatedAt'] as String),
              isDeleted: latestMessageMap['isDeleted'] as bool,
              type: latestMessageMap['type'] as String,
              belongsToMessage: latestMessageMap['belongsToMessageId'] == null
                  ? null
                  : existingMessagesMap[
                      latestMessageMap['belongsToMessageId'] as String],
              forwardedFromRoomId:
                  latestMessageMap['forwardedFromRoomId'] as String?,
              editedAt: latestMessageMap['editedAt'] == null
                  ? null
                  : DateTime.parse(latestMessage['editedAt'] as String),
              // status:
            );
          } else {
            messageToReturn = existingMessage.copyWith(
              message: message,
              belongsToMessage: latestMessageMap['belongsToMessageId'] == null
                  ? null
                  : existingMessagesMap[
                      latestMessageMap['belongsToMessageId'] as String],
              forwardedFromRoomId:
                  latestMessageMap['forwardedFromRoomId'] as String?,
              // status: ,
              editedAt: latestMessageMap['editedAt'] == null
                  ? null
                  : DateTime.parse(latestMessage['editedAt'] as String),
              updatedAt: DateTime.parse(latestMessage['updatedAt'] as String),
              isDeleted: latestMessageMap['isDeleted'] as bool,
            );
          }
          existingMessagesMap[messageToReturn.id] = messageToReturn;
          return messageToReturn;
        })));
  }

  Future<List<SharedKeyHiveObject>> mergeSharedKeys(
    final List<SharedKeyHiveObject> sharedKeys,
    final List<dynamic> latestSharedKeys,
    final String userKey,
  ) async {
    final List<SharedKeyHiveObject> mergedSharedKeys = <SharedKeyHiveObject>[];
    final Map<String, SharedKeyHiveObject> existingSharedKeysMap =
        <String, SharedKeyHiveObject>{};
    for (final SharedKeyHiveObject sharedKey in sharedKeys) {
      existingSharedKeysMap[
          (sharedKey.forUserId ?? sharedKey.forRoomId) ?? ''] = sharedKey;
    }

    return Future.wait(
        latestSharedKeys.map((final dynamic latestSharedKey) async {
      final Map<String, dynamic> latestSharedKeyMap =
          latestSharedKey as Map<String, dynamic>;
      final SharedKeyHiveObject? existingSharedKey = existingSharedKeysMap[
              latestSharedKey['forUserId'] as String? ?? ''] ??
          existingSharedKeysMap[latestSharedKey['forRoomId'] as String? ?? ''];

      final String decryptedSharedKey = await AesGcmEncryption(
        secretKey: userKey,
      ).decryptString(latestSharedKeyMap['key'] as String);
      if (existingSharedKey == null) {
        return SharedKeyHiveObject(
          sharedKey: decryptedSharedKey,
          createdAt: DateTime.parse(latestSharedKey['createdAt'] as String),
          updatedAt: DateTime.parse(latestSharedKey['updatedAt'] as String),
          forUserId: latestSharedKeyMap['forUserId'] as String?,
          forRoomId: latestSharedKeyMap['forRoomId'] as String?,
        );
      } else {
        return existingSharedKey.copyWith(
          key: decryptedSharedKey,
          updatedAt: DateTime.parse(latestSharedKey['updatedAt'] as String),
        );
      }
    }));
  }

  Future<void> storeRefreshedData(
    final Box<RoomWithRoomUsersHiveObject> roomBox,
    final Box<List<MessageHiveObject>> messageBox,
    final Box<SharedKeyHiveObject> sharedKeyBox,
    final List<RoomWithRoomUsersHiveObject> rooms,
    final List<MessageHiveObject> messages,
    final List<SharedKeyHiveObject> sharedKeys,
  ) async {
    await roomBox.clear();
    await messageBox.clear();
    await sharedKeyBox.clear();

    final Map<String, List<MessageHiveObject>> messageMap =
        <String, List<MessageHiveObject>>{};
    for (final MessageHiveObject message in messages) {
      if (messageMap.containsKey(message.roomId)) {
        messageMap[message.roomId]!.add(message);
      } else {
        messageMap[message.roomId] = <MessageHiveObject>[message];
      }
    }

    final Map<String, SharedKeyHiveObject> sharedKeyMap =
        <String, SharedKeyHiveObject>{};
    for (final SharedKeyHiveObject sharedKey in sharedKeys) {
      if (sharedKey.forUserId != null) {
        sharedKeyMap[sharedKey.forUserId!] = sharedKey;
      }
      if (sharedKey.forRoomId != null) {
        sharedKeyMap[sharedKey.forRoomId!] = sharedKey;
      }
    }

    await Future.wait([
      roomBox.addAll(rooms),
      messageBox.putAll(messageMap),
      sharedKeyBox.putAll(sharedKeyMap)
    ]);

    await Future.wait([
      roomBox.flush(),
      messageBox.flush(),
      sharedKeyBox.flush(),
    ]);
  }
}