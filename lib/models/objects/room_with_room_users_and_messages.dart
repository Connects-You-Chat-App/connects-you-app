import 'package:realm/realm.dart' hide User;

part 'room_with_room_users_and_messages.g.dart';

@RealmModel(ObjectType.embeddedObject)
class _MessageUserModel {
  late String id;
  late String name;
  late String email;
  late String? photoUrl;
}

@RealmModel(ObjectType.embeddedObject)
class _MessageStatusModel {
  late bool isDelivered;
  late bool isRead;
  late DateTime? deliveredAt;
  late DateTime? readAt;
  late String userId;
}

@RealmModel()
class _MessageModel {
  @PrimaryKey()
  late String id;
  @Indexed(RealmIndexType.fullText)
  late String roomId;
  late _MessageUserModel? senderUser;
  late String message;
  late String type;
  late bool isDeleted;
  late DateTime createdAt;
  late DateTime updatedAt;
  late _MessageModel? belongsToMessage;
  late String status;
  late String? forwardedFromRoomId;
  late DateTime? editedAt;
  late List<_MessageStatusModel> messageStatuses;
}

@RealmModel(ObjectType.embeddedObject)
class _UserModel {
  late String id;
  late String name;
  late String email;
  late String? photoUrl;
  late String publicKey;
  late String? description;
}

@RealmModel()
class _RoomWithRoomUsersAndMessagesModel {
  @PrimaryKey()
  late String id;
  late String name;
  late String type;
  late String? description;
  late String? logoUrl;
  late DateTime createdAt;
  late DateTime updatedAt;
  late List<_UserModel> roomUsers;
  late List<_MessageModel> messages;
  late bool isNewlyCreatedRoom;
}