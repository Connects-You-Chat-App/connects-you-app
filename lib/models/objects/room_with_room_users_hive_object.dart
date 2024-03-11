import 'package:hive/hive.dart';

import '../../enums/room.dart';
import '../base/user.dart';
import '../common/rooms_with_room_users.dart';
import 'user_hive_object.dart';

part 'room_with_room_users_hive_object.g.dart';

@HiveType(typeId: 3)
class RoomWithRoomUsersHiveObject extends HiveObject {
  RoomWithRoomUsersHiveObject({
    required this.id,
    required this.name,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.roomUsers,
    this.description,
    this.logoUrl,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String type;
  @HiveField(3)
  String? description;
  @HiveField(4)
  String? logoUrl;
  @HiveField(5)
  DateTime createdAt;
  @HiveField(6)
  DateTime updatedAt;
  @HiveField(7)
  List<UserHiveObject> roomUsers;

  static RoomWithRoomUsersHiveObject fromRoomWithRoomUsers(
          final RoomWithRoomUsers room) =>
      RoomWithRoomUsersHiveObject(
          id: room.id,
          name: room.name,
          type: room.type.name,
          description: room.description,
          logoUrl: room.logoUrl,
          createdAt: room.createdAt,
          updatedAt: room.updatedAt,
          roomUsers: room.roomUsers
              .map((final User e) => UserHiveObject.fromUser(e))
              .toList());

  RoomWithRoomUsers toRoomWithRoomUsers() => RoomWithRoomUsers(
        id: id,
        name: name,
        type: RoomType.fromString(type),
        description: description,
        logoUrl: logoUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
        roomUsers:
            roomUsers.map((final UserHiveObject e) => e.toUser()).toList(),
      );

  RoomWithRoomUsersHiveObject copyWith({
    final String? id,
    final String? name,
    final String? type,
    final String? description,
    final String? logoUrl,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<UserHiveObject>? roomUsers,
  }) {
    return RoomWithRoomUsersHiveObject(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      logoUrl: logoUrl ?? this.logoUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      roomUsers: roomUsers ?? this.roomUsers,
    );
  }
}