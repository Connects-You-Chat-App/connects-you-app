import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../models/base/message.dart';
import '../models/base/user.dart';
import '../models/common/rooms_with_room_users.dart';
import '../models/objects/message_hive_object.dart';
import '../models/objects/room_with_room_users_hive_object.dart';
import '../models/responses/main.dart';
import '../service/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';

class RoomsController extends GetxController {
  final RxList<RoomWithRoomUsers> _rooms = <RoomWithRoomUsers>[].obs;
  final RxMap<String, List<Message>> _roomMessages =
      <String, List<Message>>{}.obs;

  List<RoomWithRoomUsers> get rooms => _rooms;

  late final Box<RoomWithRoomUsersHiveObject> _roomsBox;
  late final Box<List<MessageHiveObject>> _messagesBox;

  @override
  void onInit() {
    super.onInit();
    _roomsBox = Hive.box<RoomWithRoomUsersHiveObject>(
        HiveBoxKeys.ROOMS_WITH_ROOM_USERS);
    _messagesBox = Hive.box<List<MessageHiveObject>>(HiveBoxKeys.MESSAGES);
    fetchRooms();
  }

  Future<void> fetchRooms({final bool fromServer = false}) async {
    if (fromServer) {
      final Response<List<RoomWithRoomUsers>> response =
          await ServerApi.roomService.fetchRooms();
      _rooms.value = response.response;
      await _roomsBox.clear();
      await _roomsBox.addAll(response.response.map(
          (final RoomWithRoomUsers e) =>
              RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(e)));
    } else {
      _rooms.value = _roomsBox.values
          .map((final RoomWithRoomUsersHiveObject e) => e.toRoomWithRoomUsers())
          .toList();
    }
  }

  Future<void> addRoom(final RoomWithRoomUsers room) async {
    _rooms.insert(0, room);
    if (_roomsBox.isEmpty) {
      await _roomsBox
          .add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    } else {
      await _roomsBox.putAt(
          0, RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    }
  }

  Future<void> addUserToRoom(final String roomId, final User user) async {
    final int index = _rooms
        .indexWhere((final RoomWithRoomUsers element) => element.id == roomId);
    if (index != -1) {
      _rooms[index].roomUsers.add(user);
      await _roomsBox.putAt(index,
          RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(_rooms[index]));
    }
  }

  Future<void> addNewlyCreatedDuetRoom(final RoomWithRoomUsers room) async {
    final User otherUser = room.roomUsers[0];
    final List<UserWiseSharedKeyResponse> sharedKeyRes =
        await getSharedKeyWithOtherUsers([otherUser], force: true);

    await _roomsBox
        .add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
  }

  void redirectToRoom(final int index) {
    final String roomId = _rooms[index].id;
    Get.toNamed<void>(
      '${RoomScreen.routeName}/${roomId}',
      arguments: <String, RoomWithRoomUsers>{
        'room': _rooms[index],
      },
    );
    getRoomMessages(roomId);
  }

  Future<void> addMessageToRoom(final Message message) async {
    final int index = _rooms.indexWhere(
        (final RoomWithRoomUsers element) => element.id == message.roomId);

    if (index != -1) {
      if (_roomMessages.containsKey(message.roomId)) {
        _roomMessages[message.roomId]!.add(message);
        final List<MessageHiveObject> messages =
            _messagesBox.get(message.roomId) ?? <MessageHiveObject>[];
        messages.add(MessageHiveObject.fromMessage(message));
        await _messagesBox.put(message.roomId, messages);
      } else {
        _roomMessages[message.roomId] = <Message>[message];
        await _messagesBox.put(
          message.roomId,
          <MessageHiveObject>[MessageHiveObject.fromMessage(message)],
        );
      }
    }
  }

  List<Message> getRoomMessages(final String roomId) {
    if (_roomMessages.containsKey(roomId)) {
      return _roomMessages[roomId]!;
    } else {
      final List<MessageHiveObject> messages =
          _messagesBox.get(roomId) ?? <MessageHiveObject>[];
      _roomMessages[roomId] =
          messages.map((final MessageHiveObject e) => e.toMessage()).toList();
      return _roomMessages[roomId]!;
    }
  }

  void updateMessageStatus(
    final String roomId,
    final String messageId,
    final String messageStatus,
  ) {
    final int messageIndex = _roomMessages[roomId]!
        .lastIndexWhere((final Message element) => element.id == messageId);
    if (messageIndex != -1) {
      _roomMessages[roomId]![messageIndex].status = messageStatus;
    }
  }
}