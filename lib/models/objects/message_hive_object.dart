import 'package:hive/hive.dart';

import '../base/message.dart';

part 'message_hive_object.g.dart';

@HiveType(typeId: 1)
class MessageUserHiveObject extends HiveObject {
  MessageUserHiveObject({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String email;
  @HiveField(3)
  late String? photoUrl;

  static MessageUserHiveObject fromMessageUser(final MessageUser user) =>
      MessageUserHiveObject(
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
      );

  MessageUser toMessageUser() => MessageUser(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
      );
}

@HiveType(typeId: 2)
class MessageHiveObject extends HiveObject {
  MessageHiveObject({
    required this.id,
    required this.roomId,
    required this.senderUser,
    required this.message,
    required this.type,
    required this.isDeleted,
    required this.createdAt,
    required this.updatedAt,
    this.belongsToMessage,
    this.status = MessageStatus.SENT,
    this.forwardedFromRoomId,
    this.editedAt,
  });

  @HiveField(0)
  late String id;
  @HiveField(1)
  late String roomId;
  @HiveField(2)
  late MessageUserHiveObject senderUser;
  @HiveField(3)
  late String message;
  @HiveField(4)
  late String type;
  @HiveField(5)
  late bool isDeleted;
  @HiveField(6)
  late DateTime createdAt;
  @HiveField(7)
  late DateTime updatedAt;
  @HiveField(8)
  late MessageHiveObject? belongsToMessage;
  @HiveField(9)
  late String status;
  @HiveField(10)
  late String? forwardedFromRoomId;
  @HiveField(11)
  late DateTime? editedAt;

  static MessageHiveObject fromMessage(final Message user) => MessageHiveObject(
        id: user.id,
        roomId: user.roomId,
        senderUser: MessageUserHiveObject.fromMessageUser(user.senderUser),
        message: user.message,
        type: user.type,
        isDeleted: user.isDeleted,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt,
        belongsToMessage: user.belongsToMessage != null
            ? MessageHiveObject.fromMessage(user.belongsToMessage!)
            : null,
        status: user.status,
        forwardedFromRoomId: user.forwardedFromRoomId,
        editedAt: user.editedAt,
      );

  Message toMessage() => Message(
        id: id,
        roomId: roomId,
        senderUser: senderUser.toMessageUser(),
        message: message,
        type: type,
        isDeleted: isDeleted,
        createdAt: createdAt,
        updatedAt: updatedAt,
        belongsToMessage: belongsToMessage?.toMessage(),
        status: status,
        forwardedFromRoomId: forwardedFromRoomId,
        editedAt: editedAt,
      );

  MessageHiveObject copyWith({
    final String? id,
    final String? roomId,
    final MessageUserHiveObject? senderUser,
    final String? message,
    final String? type,
    final bool? isDeleted,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final MessageHiveObject? belongsToMessage,
    final String? status,
    final String? forwardedFromRoomId,
    final DateTime? editedAt,
  }) {
    return MessageHiveObject(
      id: id ?? this.id,
      roomId: roomId ?? this.roomId,
      senderUser: senderUser ?? this.senderUser,
      message: message ?? this.message,
      type: type ?? this.type,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      belongsToMessage: belongsToMessage ?? this.belongsToMessage,
      status: status ?? this.status,
      forwardedFromRoomId: forwardedFromRoomId ?? this.forwardedFromRoomId,
      editedAt: editedAt ?? this.editedAt,
    );
  }
}