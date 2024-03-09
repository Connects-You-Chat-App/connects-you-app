import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../enums/room.dart';
import '../models/base/user.dart';
import '../models/common/rooms_with_room_users.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/requests/create_duet_room_request.dart';
import '../models/requests/create_group_room_request.dart';
import '../models/responses/main.dart';
import '../service/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';
import 'room_controller.dart';

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

  set showSearchBox(final bool value) => _showSearchBox.value = value;

  @override
  void onInit() {
    searchController = TextEditingController();
    searchController.addListener(() {
      final String query = searchController.text;
      if (query.isNotEmpty) {
        final List<User> searchedUsers = _users
            .where((final User user) =>
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

  Future<void> _afterRoomCreated(
      final Response<RoomWithRoomUsers?> response) async {
    if (response.response != null) {
      clearSelectedUsers();
      if (response.response!.isNewlyCreatedRoom) {
        await Get.find<RoomController>().addRoom(response.response!);
      }
      Get.toNamed<void>('${RoomScreen.routeName}/${response.response!.id}',
          arguments: <String, RoomWithRoomUsers?>{
            'room': response.response,
          });
    }

    _isCreatingRoom.value = false;
  }

  RoomWithRoomUsers? findDuetRoomFromState(final int index) {
    return Get.find<RoomController>()
        .rooms
        .firstWhereOrNull((final RoomWithRoomUsers element) {
      if (element.type == RoomType.DUET) {
        final User? roomUser = element.roomUsers.firstWhereOrNull(
          (final User element) => element.id == _users[index].id,
        );
        if (roomUser != null) {
          return true;
        }
      }
      return false;
    });
  }

  Future<void> createDuetIfNotExists(final int index) async {
    final RoomWithRoomUsers? room = findDuetRoomFromState(index);
    if (room != null) {
      Get.toNamed<void>('${RoomScreen.routeName}/${room.id}',
          arguments: <String, RoomWithRoomUsers>{
            'room': room,
          });
      return;
    }

    _isCreatingRoom.value = true;
    try {
      final SharedKeyResponse? sharedKey =
          await generateEncryptedSharedKey(_users[index].publicKey);
      if (sharedKey == null) {
        throw Exception('Shared key is null');
      }

      final Response<RoomWithRoomUsers?> createdRoomResponse =
          await ServerApi.roomService.createDuetRoom(CreateDuetRoomRequest(
        userId: _users[index].id,
        encryptedSharedKey: sharedKey.encryptedKey,
      ));
      await Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).put(
        _users[index].id,
        SharedKeyHiveObject(
          sharedKey: sharedKey.key,
          forUserId: _users[index].id,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      await _afterRoomCreated(createdRoomResponse);
    } catch (e) {
      print('Error while creating room: $e');
    } finally {
      _isCreatingRoom.value = false;
    }
  }

  Future<void> onSelected(final int index,
      {final bool preSelectedMode = false}) async {
    if (preSelectedMode || _selectedUsers.isNotEmpty) {
      final User user = _users[index];
      final bool isExists = _selectedUsers.containsKey(user.id);
      if (isExists) {
        _selectedUsers.remove(user.id);
      } else {
        _selectedUsers[user.id] = user;
      }
    } else {
      await createDuetIfNotExists(index);
    }
  }

  Future<void> createGroup() async {
    _isCreatingRoom.value = true;
    try {
      final List<User> users = _selectedUsers.values.toList();
      final String roomSecretKey =
          (randomUUID() + randomUUID()).replaceAll('-', '');
      final List<UserWiseSharedKeyResponse> userWiseSharedKeys =
          await getSharedKeyWithOtherUsers(users);
      final LazyBox<dynamic> commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
      final String userKey = await commonBox.get('USER_KEY') as String;
      final Map<String, Object> res = await compute((final _) async {
        final String selfEncryptedRoomSecretKey = await AesGcmEncryption(
          secretKey: userKey,
        ).encryptString(roomSecretKey);

        final List<OtherUserEncryptedSharedKey> otherUserEncryptedSharedKeys =
            await Future.wait(userWiseSharedKeys
                .map((final UserWiseSharedKeyResponse element) async {
          final String encryptedRoomSecretKey =
              await AesGcmEncryption(secretKey: element.sharedKey)
                  .encryptString(
            roomSecretKey,
          );
          return OtherUserEncryptedSharedKey(
            userId: element.userId,
            encryptedRoomSecretKey: encryptedRoomSecretKey,
          );
        }));
        return <String, Object>{
          'selfEncryptedRoomSecretKey': selfEncryptedRoomSecretKey,
          'otherUserEncryptedSharedKeys': otherUserEncryptedSharedKeys,
        };
      }, null);

      final Response<RoomWithRoomUsers?> createdRoomResponse =
          await ServerApi.roomService.createGroupRoom(
        CreateGroupRoomRequest(
          otherUsersEncryptedRoomSecretKeys:
              res['otherUserEncryptedSharedKeys']!
                  as List<OtherUserEncryptedSharedKey>,
          selfEncryptedRoomSecretKey:
              res['selfEncryptedRoomSecretKey']! as String,
        ),
      );
      final String roomId = createdRoomResponse.response!.id;
      await Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).put(
        roomId,
        SharedKeyHiveObject(
          sharedKey: userWiseSharedKeys.first.sharedKey,
          forRoomId: roomId,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        ),
      );
      await _afterRoomCreated(createdRoomResponse);
    } catch (e) {
      print('Error while creating room: $e');
    } finally {
      _isCreatingRoom.value = false;
    }
  }

  void onTap(final int index) {
    onSelected(index);
  }

  void onLongPress(final int index) {
    onSelected(index, preSelectedMode: true);
  }

  void clearSelectedUsers() {
    _selectedUsers.clear();
  }

  Future<void> fetchAllUsers() async {
    final Response<List<User>> users = await ServerApi.usersService.getUsers();
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