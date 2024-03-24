import 'package:get/get.dart' hide Response;
import 'package:realm/realm.dart';

import '../constants/message.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/responses/main.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';

class RoomsController extends GetxController {
  Stream<RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>? roomStream;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
    roomStream = RealmService.RoomWithRoomUsersModelService.getRoomStream();
  }

  Future<void> fetchRooms() async {
    final Response<List<RoomWithRoomUsersAndMessagesModel>> response =
        await ServerApi.roomService.fetchRooms();
    RealmService.RoomWithRoomUsersModelService.resetRooms(
      response.response.toList(),
    );
  }

  Future<void> addRoom(final RoomWithRoomUsersAndMessagesModel room) async {
    RealmService.RoomWithRoomUsersModelService.addRoom(room);
  }

  Future<void> addUserToRoom(final String roomId, final UserModel user) async {
    RealmService.RoomWithRoomUsersModelService.addRoomUsersToRoom(
        roomId, [user]);
  }

  Future<void> addNewlyCreatedDuetRoom(
      final RoomWithRoomUsersAndMessagesModel room) async {
    final UserModel otherUser = room.roomUsers[0];
    final List<UserWiseSharedKeyResponse> sharedKeyRes =
        await getSharedKeyWithOtherUsers([otherUser], force: true);

    RealmService.RoomWithRoomUsersModelService.addRoom(room);
  }

  void redirectToRoom(final RoomWithRoomUsersAndMessagesModel room) {
    Get.toNamed<void>(
      '${RoomScreen.routeName}/${room.id}',
      arguments: <String, RoomWithRoomUsersAndMessagesModel>{
        'room': room,
      },
    );
  }

  Future<void> addMessageToRoom(final MessageModel message) async {
    RealmService.RoomWithRoomUsersModelService.addMessages([message]);
  }

  void updateMessageStatusToSent(final String messageId) {
    RealmService.RoomWithRoomUsersModelService.updateMessageStatus(
      messageId,
      MessageStatus.SENT,
    );
  }

  void updateMessageStatusToDelivered(
    final List<String> messageIds,
    final List<String> userIds,
  ) {
    RealmService.RoomWithRoomUsersModelService.updateMessageStatusToDelivered(
        messageIds, userIds);
  }

  void updateMessageStatusToRead(
    final List<String> messageIds,
    final List<String> userIds,
  ) {
    RealmService.RoomWithRoomUsersModelService.updateMessageStatusToRead(
        messageIds, userIds);
  }
}
