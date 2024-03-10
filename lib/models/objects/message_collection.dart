import 'package:isar/isar.dart';

import '../base/message.dart';

part 'message_collection.g.dart';

@Embedded()
class MessageUserCollection {
  MessageUserCollection({
    this.userId,
    this.name,
    this.email,
    this.photoUrl,
  });

  String? userId;
  String? name;
  String? email;
  String? photoUrl;

  static MessageUserCollection fromMessageUser(final MessageUser user) =>
      MessageUserCollection(
        userId: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
      );

  MessageUser toMessageUser() => MessageUser(
        id: userId!,
        name: name!,
        email: email!,
        photoUrl: photoUrl,
      );
}

@Embedded()
class EmbeddedMessage {
  EmbeddedMessage({
    this.messageId,
    this.roomId,
    this.senderUser,
    this.message,
    this.type,
    this.isDeleted,
  });

  String? messageId;
  String? roomId;
  MessageUserCollection? senderUser;
  String? message;
  String? type;
  bool? isDeleted;

  static EmbeddedMessage fromMessage(final Message message) => EmbeddedMessage(
        messageId: message.id,
        roomId: message.roomId,
        senderUser: MessageUserCollection.fromMessageUser(message.senderUser),
        message: message.message,
        type: message.type,
        isDeleted: message.isDeleted,
      );

  Message toMessage() => Message(
        id: messageId!,
        roomId: roomId!,
        senderUser: senderUser!.toMessageUser(),
        message: message!,
        type: type!,
        isDeleted: isDeleted!,
      );
}

@Collection()
class MessageCollection {
  MessageCollection({
    required this.messageId,
    required this.roomId,
    required this.senderUser,
    required this.message,
    required this.type,
    required this.isDeleted,
    this.id,
    this.createdAt,
    this.updatedAt,
    this.belongsToMessage,
    this.status = MessageStatus.SENT,
    this.forwardedFromRoomId,
    this.editedAt,
  });

  Id? id;

  final String messageId;
  final String roomId;
  final MessageUserCollection senderUser;
  final String message;
  final String type;
  final bool isDeleted;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final EmbeddedMessage? belongsToMessage;
  final String status;
  final String? forwardedFromRoomId;
  final DateTime? editedAt;

  static MessageCollection fromMessage(final Message message) =>
      MessageCollection(
        messageId: message.id,
        roomId: message.roomId,
        senderUser: MessageUserCollection.fromMessageUser(message.senderUser),
        message: message.message,
        type: message.type,
        isDeleted: message.isDeleted,
        createdAt: message.createdAt,
        updatedAt: message.updatedAt,
        belongsToMessage: message.belongsToMessage != null
            ? EmbeddedMessage.fromMessage(message.belongsToMessage!)
            : null,
        status: message.status,
        forwardedFromRoomId: message.forwardedFromRoomId,
        editedAt: message.editedAt,
      );

  Message toMessage() => Message(
        id: messageId,
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

  MessageCollection copyWith({
    final String? messageId,
    final String? roomId,
    final MessageUserCollection? senderUser,
    final String? message,
    final String? type,
    final bool? isDeleted,
    final DateTime? createdAt,
    final DateTime? updatedAt,
    final EmbeddedMessage? belongsToMessage,
    final String? status,
    final String? forwardedFromRoomId,
    final DateTime? editedAt,
  }) {
    return MessageCollection(
      messageId: messageId ?? this.messageId,
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