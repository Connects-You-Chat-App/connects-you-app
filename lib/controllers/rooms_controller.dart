import 'package:get/get.dart' hide Response;
import 'package:realm/realm.dart';

import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/responses/main.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/room/room_screen.dart';

class RoomsController extends GetxController {
  // final RxList<RoomWithRoomUsersAndMessagesModel> _rooms =
  //     <RoomWithRoomUsersAndMessagesModel>[].obs;
  // final RxMap<String, List<MessageModel>> _roomMessages =
  //     <String, List<MessageModel>>{}.obs;

  // List<RoomWithRoomUsersAndMessagesModel> get rooms => _rooms;
  //
  // Map<String, List<MessageModel>> get roomMessages => _roomMessages;

  Stream<RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>? roomStream;

  @override
  void onInit() {
    super.onInit();
    fetchRooms();
    roomStream =
        RealmService.roomWithRoomUsersAndMessagesModelService.getRoomStream();
  }

  Future<void> fetchRooms() async {
    final Response<List<RoomWithRoomUsersAndMessagesModel>> response =
        await ServerApi.roomService.fetchRooms();
    RealmService.roomWithRoomUsersAndMessagesModelService.resetRooms(
      response.response.toList(),
    );
  }

  Future<void> addRoom(final RoomWithRoomUsersAndMessagesModel room) async {
    RealmService.roomWithRoomUsersAndMessagesModelService.addRoom(room);
  }

  Future<void> addUserToRoom(final String roomId, final UserModel user) async {
    RealmService.roomWithRoomUsersAndMessagesModelService
        .addRoomUsersToRoom(roomId, [user]);
  }

  Future<void> addNewlyCreatedDuetRoom(
      final RoomWithRoomUsersAndMessagesModel room) async {
    final UserModel otherUser = room.roomUsers[0];
    final List<UserWiseSharedKeyResponse> sharedKeyRes =
        await getSharedKeyWithOtherUsers([otherUser], force: true);

    RealmService.roomWithRoomUsersAndMessagesModelService.addRoom(room);
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
    RealmService.roomWithRoomUsersAndMessagesModelService
        .addMessages([message]);
  }

  Future<void> updateMessageStatus(
    final String roomId,
    final String messageId,
    final String messageStatus,
  ) async {
    RealmService.roomWithRoomUsersAndMessagesModelService.updateMessageStatus(
      messageId,
      messageStatus,
    );
  }

  Future<void> updateMessageStatuses(
    final List<String> messageIds,
    final String messageStatus,
  ) async {
    final Set<String> messageIdsSet = messageIds.toSet();
    RealmService.roomWithRoomUsersAndMessagesModelService
        .updateMessagesStatus(messageIds, messageStatus);
  }
}