import 'dart:developer';

import '../objects/room_with_room_users_and_messages.dart';

class Notification {
  Notification({
    required this.id,
    required this.roomId,
    required this.senderUser,
    required this.receiverUserId,
    required this.message,
    required this.encryptedRoomSecretKey,
    required this.isAccepted,
    required this.sendAt,
  });

  factory Notification.fromJson(final Map<String, dynamic> json) {
    log(json.toString());
    return Notification(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      senderUser:
          UserModel.fromJson(json['senderUser'] as Map<String, dynamic>),
      receiverUserId: json['receiverUserId'] as String,
      message: json['message'] as String,
      encryptedRoomSecretKey: json['encryptedRoomSecretKey'] as String,
      sendAt: DateTime.parse(json['sendAt'] as String),
      isAccepted: json['isAccepted'] as bool,
    );
  }

  final String id;
  final String roomId;
  final UserModel senderUser;
  final String receiverUserId;
  final String message;
  final String encryptedRoomSecretKey;
  final bool isAccepted;
  final DateTime sendAt;
}
