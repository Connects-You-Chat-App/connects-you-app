import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart' hide Response;

import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../models/requests/create_duet_room_request.dart';
import '../models/requests/create_group_room_request.dart';
import '../models/responses/main.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';
import 'rooms_controller.dart';

class UsersController extends GetxController {
  final RxList<UserModel> _users = <UserModel>[].obs;
  final RxList<UserModel> _searchedUsers = <UserModel>[].obs;
  final RxMap<String, UserModel> _selectedUsers = <String, UserModel>{}.obs;

  final RxBool _isCreatingRoom = false.obs;

  final RxBool _showSearchBox = false.obs;

  late final TextEditingController searchController;

  List<UserModel> get users =>
      searchController.text.isEmpty ? _users : _searchedUsers;

  Map<String, UserModel> get selectedUsers => _selectedUsers;

  bool get isCreatingRoom => _isCreatingRoom.value;

  bool get showSearchBox => _showSearchBox.value;

  set showSearchBox(final bool value) => _showSearchBox.value = value;

  @override
  void onInit() {
    searchController = TextEditingController();
    searchController.addListener(() {
      final String query = searchController.text;
      if (query.isNotEmpty) {
        final List<UserModel> searchedUsers = _users
            .where((final UserModel user) =>
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
      final Response<RoomWithRoomUsersAndMessagesModel?> response) async {
    if (response.response != null) {
      clearSelectedUsers();
      if (response.response!.isNewlyCreatedRoom) {
        await Get.find<RoomsController>().addRoom(response.response!);
      }
      Get.toNamed<void>('${RoomScreen.routeName}/${response.response!.id}',
          arguments: <String, RoomWithRoomUsersAndMessagesModel?>{
            'room': response.response,
          });
    }

    _isCreatingRoom.value = false;
  }

  RoomWithRoomUsersAndMessagesModel? findDuetRoomFromState(
          final String userId) =>
      RealmService.RoomWithRoomUsersModelService.getRoomFromRoomUserId(userId);

  Future<void> createDuetIfNotExists(final int index) async {
    final String userId = _users[index].id;
    final RoomWithRoomUsersAndMessagesModel? room =
        findDuetRoomFromState(userId);
    if (room != null) {
      Get.toNamed<void>('${RoomScreen.routeName}/${room.id}',
          arguments: <String, RoomWithRoomUsersAndMessagesModel>{'room': room});
      return;
    }

    _isCreatingRoom.value = true;
    try {
      final SharedKeyResponse? sharedKey =
          await generateEncryptedSharedKey(_users[index].publicKey);
      if (sharedKey == null) {
        throw Exception('Shared key is null');
      }

      final Response<RoomWithRoomUsersAndMessagesModel?> createdRoomResponse =
          await ServerApi.roomService.createDuetRoom(CreateDuetRoomRequest(
        userId: _users[index].id,
        encryptedSharedKey: sharedKey.encryptedKey,
      ));
      RealmService.sharedKeyModelService.addSharedKey(SharedKeyModel(
        sharedKey.key,
        DateTime.now(),
        DateTime.now(),
        forUserId: _users[index].id,
      ));
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
      final UserModel user = _users[index];
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
      final List<UserModel> users = _selectedUsers.values.toList();
      final String roomSecretKey =
          (randomUUID() + randomUUID()).replaceAll('-', '');
      final List<UserWiseSharedKeyResponse> userWiseSharedKeys =
          await getSharedKeyWithOtherUsers(users);
      final String userKey =
          RealmService.currentUserModelService.getCurrentUser()!.userKey;
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

      final Response<RoomWithRoomUsersAndMessagesModel?> createdRoomResponse =
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

      RealmService.sharedKeyModelService.addSharedKey(SharedKeyModel(
        userWiseSharedKeys.first.sharedKey,
        DateTime.now(),
        DateTime.now(),
        forUserId: userWiseSharedKeys.first.userId,
      ));
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
    final Response<List<UserModel>> users =
        await ServerApi.usersService.getUsers();
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
