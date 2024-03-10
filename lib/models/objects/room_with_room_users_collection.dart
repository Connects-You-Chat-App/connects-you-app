import 'package:isar/isar.dart';

import '../../enums/room.dart';
import '../base/user.dart';
import '../common/rooms_with_room_users.dart';

part 'room_with_room_users_collection.g.dart';

@Collection()
class RoomCollection {
  RoomCollection({
    required this.roomId,
    required this.type,
    required this.createdAt,
    required this.updatedAt,
    required this.roomUsers,
    this.id,
    this.name,
    this.description,
    this.logoUrl,
  });

  Id? id;

  final String roomId;
  final String type;
  final String? name;
  final String? description;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<UserCollection> roomUsers;

  static RoomCollection fromRoomWithRoomUsers(final RoomWithRoomUsers room) =>
      RoomCollection(
          roomId: room.id,
          name: room.name,
          type: room.type.name,
          description: room.description,
          logoUrl: room.logoUrl,
          createdAt: room.createdAt,
          updatedAt: room.updatedAt,
          roomUsers: room.roomUsers
              .map((final User e) => UserCollection.fromUser(e))
              .toList());

  RoomWithRoomUsers toRoomWithRoomUsers() => RoomWithRoomUsers(
        id: roomId,
        name: name,
        type: RoomType.fromString(type),
        description: description,
        logoUrl: logoUrl,
        createdAt: createdAt,
        updatedAt: updatedAt,
        roomUsers:
            roomUsers.map((final UserCollection e) => e.toUser()).toList(),
      );

  RoomCollection copyWith({
    final String? roomId,
    final String? name,
    final String? type,
    final String? description,
    final String? logoUrl,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final List<UserCollection>? roomUsers,
  }) {
    return RoomCollection(
      roomId: roomId ?? this.roomId,
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

@Embedded()
class UserCollection {
  UserCollection({
    this.userId,
    this.name,
    this.email,
    this.publicKey,
    this.description,
    this.photoUrl,
  });

  String? userId;
  String? name;
  String? email;
  String? photoUrl;
  String? publicKey;
  String? description;

  static UserCollection fromUser(final User user) => UserCollection(
        userId: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        publicKey: user.publicKey,
        description: user.description,
      );

  User toUser() => User(
        id: userId!,
        name: name!,
        email: email!,
        photoUrl: photoUrl,
        publicKey: publicKey!,
        description: description,
      );
}