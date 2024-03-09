import '../../enums/room.dart';
import '../base/user.dart';

class RoomWithRoomUsers {
  RoomWithRoomUsers({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.logoUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.roomUsers,
    this.isNewlyCreatedRoom = false,
  });

  factory RoomWithRoomUsers.fromJson(final Map<String, dynamic> json) {
    return RoomWithRoomUsers(
      id: json['id'] as String,
      name: json['name'] as String,
      type: RoomType.fromString(json['type'] as String),
      description: json['description'] as String?,
      logoUrl: json['logoUrl'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      isNewlyCreatedRoom: json['isNewlyCreatedRoom'] as bool? ?? false,
      roomUsers: (json['roomUsers'] as List<dynamic>)
          .map((final dynamic e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  final String id;
  final String name;
  final RoomType type;
  final String? description;
  final String? logoUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<User> roomUsers;

  final bool isNewlyCreatedRoom;
}