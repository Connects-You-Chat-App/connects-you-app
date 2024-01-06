import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/controllers/inbox_controller.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/common/rooms_with_room_users.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/models/requests/create_duet_room_request.dart';
import 'package:connects_you/models/requests/create_group_room_request.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';
import 'package:connects_you/utils/generate_shared_key.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

class UsersController extends GetxController {
  final RxList<User> _users = <User>[].obs;
  final RxList<User> _searchedUsers = <User>[].obs;
  final RxMap<String, User> _selectedUsers = <String, User>{}.obs;

  final RxBool _isCreatingRoom = false.obs;

  final RxBool _showSearchBox = false.obs;

  late final TextEditingController searchController;

  List<User> get users =>
      searchController.text.isEmpty ? _users : _searchedUsers;

  Map<String, User> get selectedUsers => _selectedUsers;

  bool get isCreatingRoom => _isCreatingRoom.value;

  bool get showSearchBox => _showSearchBox.value;

  set showSearchBox(bool value) => _showSearchBox.value = value;

  @override
  void onInit() {
    searchController = TextEditingController();
    searchController.addListener(() {
      final query = searchController.text;
      if (query.isNotEmpty) {
        final searchedUsers = _users
            .where((user) =>
                user.name.contains(query) || user.email.contains(query))
            .toList();
        _searchedUsers.value = searchedUsers;
      } else {
        _searchedUsers.clear();
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }

  Future _afterRoomCreated(Response<RoomWithRoomUsers?> response) async {
    if (response.response != null) {
      clearSelectedUsers();
      if (response.response!.isNewlyCreatedRoom) {
        await Get.find<InboxController>().addRoom(response.response!);
      }
      Get.toNamed('/room/${response.response!.id}');
    }

    _isCreatingRoom.value = false;
  }

  RoomWithRoomUsers? findDuetRoomFromState(int index) {
    return null;
    // return Get.find<InboxController>().rooms.firstWhereOrNull((element) {
    //   if (element.type == RoomType.DUET) {
    //     final roomUser = element.roomUsers.firstWhereOrNull(
    //       (element) => element.id == _users[index].id,
    //     );
    //     if (roomUser != null) {
    //       return true;
    //     }
    //   }
    //   return false;
    // });
  }

  Future createDuetIfNotExists(int index) async {
    final room = findDuetRoomFromState(index);
    if (room != null) {
      Get.toNamed('/room/${room.id}');
      return;
    }

    _isCreatingRoom.value = true;
    try {
      final sharedKey =
          await generateEncryptedSharedKey(_users[index].publicKey);

      final createdRoomResponse =
          await ServerApi.roomService.createDuetRoom(CreateDuetRoomRequest(
        userId: _users[index].id,
        encryptedSharedKey: sharedKey.encryptedKey,
      ));
      await Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).put(
        _users[index].id,
        SharedKeyHiveObject(
          key: sharedKey.key,
          forUserId: _users[index].id,
        ),
      );
      await _afterRoomCreated(createdRoomResponse);
    } catch (e) {
      print("Error while creating room: $e");
    } finally {
      _isCreatingRoom.value = false;
    }
  }

  void onSelected(int index, [bool preSelectedMode = false]) async {
    if (preSelectedMode || _selectedUsers.isNotEmpty) {
      final user = _users[index];
      final isExists = _selectedUsers.containsKey(user.id);
      if (isExists) {
        _selectedUsers.remove(user.id);
      } else {
        _selectedUsers[user.id] = user;
      }
    } else {
      await createDuetIfNotExists(index);
    }
  }

  Future createGroup() async {
    _isCreatingRoom.value = true;
    try {
      final users = _selectedUsers.values.toList();
      final roomSecretKey = (randomUUID() + randomUUID()).replaceAll('-', '');
      final userWiseSharedKeys = await getSharedKeyWithOtherUsers(users);
      final commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
      final userKey = await commonBox.get("USER_KEY");
      final res = await compute((_) async {
        final selfEncryptedRoomSecretKey = await AesGcmEncryption(
          secretKey: userKey,
        ).encryptString(roomSecretKey);

        final otherUserEncryptedSharedKeys =
            await Future.wait(userWiseSharedKeys.map((element) async {
          final encryptedRoomSecretKey =
              await AesGcmEncryption(secretKey: element.sharedKey)
                  .encryptString(
            roomSecretKey,
          );
          return OtherUserEncryptedSharedKey(
            userId: element.userId,
            encryptedRoomSecretKey: encryptedRoomSecretKey,
          );
        }));
        return {
          "selfEncryptedRoomSecretKey": selfEncryptedRoomSecretKey,
          "otherUserEncryptedSharedKeys": otherUserEncryptedSharedKeys,
        };
      }, null);

      final createdRoomResponse = await ServerApi.roomService.createGroupRoom(
        CreateGroupRoomRequest(
          otherUsersEncryptedRoomSecretKeys: res["otherUserEncryptedSharedKeys"]
              as List<OtherUserEncryptedSharedKey>,
          selfEncryptedRoomSecretKey:
              res["selfEncryptedRoomSecretKey"] as String,
        ),
      );
      final roomId = createdRoomResponse.response!.id;
      await Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).put(
        roomId,
        SharedKeyHiveObject(
          key: userWiseSharedKeys.first.sharedKey,
          forRoomId: roomId,
        ),
      );
      await _afterRoomCreated(createdRoomResponse);
    } catch (e) {
      print("Error while creating room: $e");
    } finally {
      _isCreatingRoom.value = false;
    }
  }

  void onTap(int index) {
    onSelected(index);
  }

  void onLongPress(int index) {
    onSelected(index, true);
  }

  void clearSelectedUsers() {
    _selectedUsers.clear();
  }

  Future fetchAllUsers() async {
    final users = await ServerApi.usersService.getUsers();
    if (users.response.isNotEmpty) {
      _users.value = users.response;
    }
  }
}

/**
 * after creating or while creating room
 * if DUET {
 *  create a sharedKey between users encrypt them using user's personal key.
 *  and store it inside user_shared_key table.
 * } else if GROUP {
 *  create a random sharedKey
 *  create shared keys with other users if not already exists, and store them in user_shared_key table.
 *  encrypt the random sharedKey with each user's shared key
 *  send these encrypted shared key to server and store them as notification
 *
 *  when user opens the notification, and click on join, then decrypt the shared key using user's shared key
 *  and join the user with the room.
 * }062280606166e0b415c193f91ab6839eef44469d620f03ed647d9aaf397a6253
 */