import 'dart:developer';

import 'package:get/get.dart' hide Response;

import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/responses/main.dart';
import '../services/database/room_with_room_users_and_messages.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';

class RoomsController extends GetxController {
  final RxList<RoomWithRoomUsersAndMessagesModel> _rooms =
      <RoomWithRoomUsersAndMessagesModel>[].obs;
  final RxMap<String, List<MessageModel>> _roomMessages =
      <String, List<MessageModel>>{}.obs;

  List<RoomWithRoomUsersAndMessagesModel> get rooms => _rooms;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
  }

  Future<void> fetchRooms({final bool fromServer = false}) async {
    if (fromServer) {
      final Response<List<RoomWithRoomUsersAndMessagesModel>> response =
          await ServerApi.roomService.fetchRooms();
      _rooms.value = response.response;
      RoomWithRoomUsersAndMessagesModelService().resetRooms(
        response.response.toList(growable: true),
      );
    } else {
      _rooms.value = RoomWithRoomUsersAndMessagesModelService().getAllRooms();
    }
  }

  Future<void> addRoom(final RoomWithRoomUsersAndMessagesModel room) async {
    RoomWithRoomUsersAndMessagesModelService().addRoom(room);
    _rooms.insert(0, room);
    // if (_roomsBox.isEmpty) {
    //   await _roomsBox
    //       .add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    // } else {
    //   await _roomsBox.putAt(
    //       0, RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
    // }
  }

  Future<void> addUserToRoom(final String roomId, final UserModel user) async {
    final int index = _rooms.indexWhere(
        (final RoomWithRoomUsersAndMessagesModel element) =>
            element.id == roomId);
    if (index != -1) {
      _rooms[index].roomUsers.add(user);
      RoomWithRoomUsersAndMessagesModelService()
          .addRoomUsersToRoom(roomId, [user]);
    }
  }

  Future<void> addNewlyCreatedDuetRoom(
      final RoomWithRoomUsersAndMessagesModel room) async {
    final UserModel otherUser = room.roomUsers[0];
    final List<UserWiseSharedKeyResponse> sharedKeyRes =
        await getSharedKeyWithOtherUsers([otherUser], force: true);

    RoomWithRoomUsersAndMessagesModelService().addRoom(room);
    // await _roomsBox
    //     .add(RoomWithRoomUsersHiveObject.fromRoomWithRoomUsers(room));
  }

  void redirectToRoom(final int index) {
    final String roomId = _rooms[index].id;
    Get.toNamed<void>(
      '${RoomScreen.routeName}/${roomId}',
      arguments: <String, RoomWithRoomUsersAndMessagesModel>{
        'room': _rooms[index],
      },
    );
    getRoomMessages(roomId);
  }

  Future<void> addMessageToRoom(final MessageModel message) async {
    final int index = _rooms.indexWhere(
        (final RoomWithRoomUsersAndMessagesModel element) =>
            element.id == message.roomId);

    if (index != -1) {
      if (_roomMessages.containsKey(message.roomId)) {
        _roomMessages[message.roomId]!.add(message);
      } else {
        _roomMessages[message.roomId] = <MessageModel>[message];
      }
      RoomWithRoomUsersAndMessagesModelService().addMessages([message]);
    }
  }

  List<MessageModel> getRoomMessages(final String roomId) {
    if (_roomMessages.containsKey(roomId)) {
      return _roomMessages[roomId]!;
    } else {
      // final List<dynamic> messages =
      //     _messagesBox.get(roomId) ?? <MessageHiveObject>[];
      // _roomMessages[roomId] = List<MessageHiveObject>.from(messages)
      //     .map((final MessageHiveObject e) => e.toMessage())
      //     .toList(growable: true);
      _roomMessages[roomId] =
          RoomWithRoomUsersAndMessagesModelService().getRoomMessages(roomId);
      inspect(_roomMessages[roomId]!);
      return _roomMessages[roomId]!;
    }
  }

  Future<void> updateMessageStatus(
    final String roomId,
    final String messageId,
    final String messageStatus,
  ) async {
    final int messageIndex = _roomMessages[roomId]!.lastIndexWhere(
        (final MessageModel element) => element.id == messageId);
    if (messageIndex != -1) {
      _roomMessages[roomId]![messageIndex].status = messageStatus;

      RoomWithRoomUsersAndMessagesModelService().updateMessage(
        _roomMessages[roomId]![messageIndex],
      );
    }
  }

  Future<void> updateMessageStatuses(
    final List<String> messageIds,
    final String messageStatus,
  ) async {
    final List<MessageModel> messages =
        RoomWithRoomUsersAndMessagesModelService()
            .getMessagesWithMessageIds(messageIds);
    final Set<String> messageIdsSet = messageIds.toSet();
    for (int i = 0; i < messages.length; i++) {
      if (messageIdsSet.contains(messages[i].id)) {
        messages[i].status = messageStatus;
      }
    }
    // RoomWithRoomUsersAndMessagesModelService().resetMessages(messages);
  }
}