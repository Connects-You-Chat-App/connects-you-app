import 'package:connects_you/enums/room.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/common/rooms_with_room_users.dart';
import 'package:connects_you/models/objects/user_hive_object.dart';
import 'package:hive/hive.dart';

part 'room_with_room_users_hive_object.g.dart';

@HiveType(typeId: 3)
class RoomWithRoomUsersHiveObject extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String type;
  @HiveField(3)
  late String? description;
  @HiveField(4)
  late String? logoUrl;
  @HiveField(5)
  late DateTime createdAt;
  @HiveField(6)
  late List<UserHiveObject> roomUsers;

  RoomWithRoomUsersHiveObject({
    required this.id,
    required this.name,
    required this.type,
    this.description,
    this.logoUrl,
    required this.createdAt,
    required this.roomUsers,
  });

  static RoomWithRoomUsersHiveObject fromRoomWithRoomUsers(
          RoomWithRoomUsers room) =>
      RoomWithRoomUsersHiveObject(
        id: room.id,
        name: room.name,
        type: room.type.name,
        description: room.description,
        logoUrl: room.logoUrl,
        createdAt: room.createdAt,
        roomUsers:
            room.roomUsers.map((e) => UserHiveObject.fromUser(e)).toList(),
      );

  RoomWithRoomUsers toRoomWithRoomUsers() => RoomWithRoomUsers(
        id: id,
        name: name,
        type: RoomType.fromString(type),
        description: description,
        logoUrl: logoUrl,
        createdAt: createdAt,
        roomUsers: roomUsers.map((e) => e.toUser()).toList(),
      );
}