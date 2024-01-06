import 'package:connects_you/enums/room.dart';
import 'package:connects_you/models/base/user.dart';

class RoomWithRoomUsers {
  final String id;
  final String name;
  final RoomType type;
  final String? description;
  final String? logoUrl;
  final DateTime createdAt;
  final List<User> roomUsers;

  final bool isNewlyCreatedRoom;

  RoomWithRoomUsers({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.logoUrl,
    required this.createdAt,
    required this.roomUsers,
    this.isNewlyCreatedRoom = false,
  });

  factory RoomWithRoomUsers.fromJson(Map<String, dynamic> json) {
    return RoomWithRoomUsers(
      id: json['id'],
      name: json['name'],
      type: RoomType.fromString(json['type']),
      description: json['description'],
      logoUrl: json['logoUrl'],
      createdAt: DateTime.parse(json['createdAt']),
      isNewlyCreatedRoom: json['isNewlyCreatedRoom'] ?? false,
      roomUsers:
          (json['roomUsers'] as List).map((e) => User.fromJson(e)).toList(),
    );
  }
}