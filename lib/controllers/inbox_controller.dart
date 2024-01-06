import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/common/rooms_with_room_users.dart';
import 'package:connects_you/models/common/shared_key.dart';
import 'package:connects_you/models/objects/room_with_room_users_hive_object.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/service/server.dart';
import 'package:connects_you/utils/generate_shared_key.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class InboxController extends GetxController {
  final RxList<RoomWithRoomUsers> _rooms = <RoomWithRoomUsers>[].obs;

  List<RoomWithRoomUsers> get rooms => _rooms;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future fetchRooms([bool fromServer = false]) async {
    // if (fromServer) {
    final response = await ServerApi.roomService.fetchRooms();
    _rooms.value = response.response;
    final roomsBox = Hive.box<RoomWithRoomUsersHiveObject>(
        HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    await roomsBox.clear();
    await roomsBox.addAll(response.response
        .map((e) => RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(e)));
    // } else {
    //   final roomsBox = Hive.box<RoomWithRoomUsersHiveObject>(
    //       HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    //   _rooms.value =
    //       roomsBox.values.map((e) => e.toRoomWithRoomUsers()).toList();
    // }
  }

  Future addRoom(RoomWithRoomUsers room) async {
    _rooms.insert(0, room);
    final box = Hive.box<RoomWithRoomUsersHiveObject>(
        HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    if (box.isEmpty) {
      await box.add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    } else {
      await box.putAt(
          0, RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    }
  }

  void addUserToRoom(String roomId, User user) {
    final index = _rooms.indexWhere((element) => element.id == roomId);
    if (index != -1) {
      _rooms[index].roomUsers.add(user);
    }
  }

  Future addNewlyCreatedDuetRoom(RoomWithRoomUsers room) async {
    final otherUser = room.roomUsers[0];
    final sharedKey = await generateEncryptedSharedKey(otherUser.publicKey);
    final sharedKeyBox =
        Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
    await Future.wait([
      addRoom(room),
      sharedKeyBox.put(
        otherUser.id,
        SharedKeyHiveObject(
          key: sharedKey.key,
          forUserId: otherUser.id,
        ),
      ),
      ServerApi.sharedKeyService.saveKey(
        SharedKey(
          key: sharedKey.encryptedKey,
          forUserId: otherUser.id,
        ),
      )
    ]);
  }
}