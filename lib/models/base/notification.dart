import 'dart:developer';

import 'package:connects_you/models/base/user.dart';

class Notification {
  final String id;
  final String roomId;
  final User senderUser;
  final String receiverUserId;
  final String message;
  final String encryptedRoomSecretKey;
  final bool isAccepted;
  final DateTime sendAt;

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

  factory Notification.fromJson(Map<String, dynamic> json) {
    log(json.toString());
    return Notification(
      id: json['id'],
      roomId: json['roomId'],
      senderUser: User.fromJson(json['senderUser']),
      receiverUserId: json['receiverUserId'],
      message: json['message'],
      encryptedRoomSecretKey: json['encryptedRoomSecretKey'],
      sendAt: DateTime.parse(json['sendAt']),
      isAccepted: json['isAccepted'],
    );
  }
}