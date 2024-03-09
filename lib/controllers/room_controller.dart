import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../models/base/message.dart';
import '../models/base/user.dart';
import '../models/common/rooms_with_room_users.dart';
import '../models/common/shared_key.dart';
import '../models/objects/room_with_room_users_hive_object.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/responses/main.dart';
import '../service/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';

class RoomController extends GetxController {
  final RxList<RoomWithRoomUsers> _rooms = <RoomWithRoomUsers>[].obs;
  final RxMap<String, List<Message>> _roomMessages =
      <String, List<Message>>{}.obs;

  List<RoomWithRoomUsers> get rooms => _rooms;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms({final bool fromServer = false}) async {
    if (fromServer) {
      final Response<List<RoomWithRoomUsers>> response =
          await ServerApi.roomService.fetchRooms();
      _rooms.value = response.response;
      final Box<RoomWithRoomUsersHiveObject> roomsBox =
          Hive.box<RoomWithRoomUsersHiveObject>(
              HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
      await roomsBox.clear();
      await roomsBox.addAll(response.response.map((final RoomWithRoomUsers e) =>
          RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(e)));
    } else {
      final Box<RoomWithRoomUsersHiveObject> roomsBox =
          Hive.box<RoomWithRoomUsersHiveObject>(
              HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
      _rooms.value = roomsBox.values
          .map((final RoomWithRoomUsersHiveObject e) => e.toRoomWithRoomUsers())
          .toList();
    }
  }

  Future<void> addRoom(final RoomWithRoomUsers room) async {
    _rooms.insert(0, room);
    final Box<RoomWithRoomUsersHiveObject> box =
        Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    if (box.isEmpty) {
      await box.add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    } else {
      await box.putAt(
          0, RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    }
  }

  Future<void> addUserToRoom(final String roomId, final User user) async {
    final int index = _rooms
        .indexWhere((final RoomWithRoomUsers element) => element.id == roomId);
    if (index != -1) {
      _rooms[index].roomUsers.add(user);
      final Box<RoomWithRoomUsersHiveObject> box =
          Hive.box<RoomWithRoomUsersHiveObject>(
              HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
      await box.putAt(index,
          RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(_rooms[index]));
    }
  }

  Future<void> addNewlyCreatedDuetRoom(final RoomWithRoomUsers room) async {
    final User otherUser = room.roomUsers[0];
    final SharedKeyResponse? sharedKey =
        await generateEncryptedSharedKey(otherUser.publicKey);
    final Box<SharedKeyHiveObject> sharedKeyBox =
        Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
    final bool sharedKeyExists = sharedKey != null;
    await Future.wait(<Future<void>>[
      addRoom(room),
      if (sharedKeyExists)
        sharedKeyBox.put(
          otherUser.id,
          SharedKeyHiveObject(
            sharedKey: sharedKey.key,
            forUserId: otherUser.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      if (sharedKeyExists)
        ServerApi.sharedKeyService.saveKey(
          SharedKey(
            key: sharedKey.encryptedKey,
            forUserId: otherUser.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        )
    ]);

    final Box<RoomWithRoomUsersHiveObject> box =
        Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    await box.add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
  }

  void redirectToRoom(final int index) {
    Get.toNamed<void>(
      '${RoomScreen.routeName}/${_rooms[index].id}',
      arguments: <String, RoomWithRoomUsers>{
        'room': _rooms[index],
      },
    );
  }

  void addMessageToRoom(final Message message) {
    final int index = _rooms.indexWhere(
        (final RoomWithRoomUsers element) => element.id == message.roomId);
    if (index != -1) {
      if (_roomMessages.containsKey(message.roomId)) {
        _roomMessages[message.roomId]!.add(message);
      } else {
        _roomMessages[message.roomId] = <Message>[message];
      }
    }
  }

  void updateMessageStatus(
      final String roomId, final String messageId, final String messageStatus) {
    final int messageIndex = _roomMessages[roomId]!
        .lastIndexWhere((final Message element) => element.id == messageId);
    if (messageIndex != -1) {
      _roomMessages[roomId]![messageIndex].status = messageStatus;
    }
  }
}