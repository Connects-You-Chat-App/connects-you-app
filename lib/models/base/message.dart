class MessageType {
  static const String TEXT = 'TEXT';
  static const String IMAGE = 'IMAGE';
  static const String VIDEO = 'VIDEO';
  static const String DOC = 'DOC';
  static const String PPT = 'PPT';
  static const String PDF = 'PDF';
  static const String TXT = 'TXT';
  static const String XLS = 'XLS';
  static const String AUDIO = 'AUDIO';
  static const String OTHER = 'OTHER';
  static const String LOCATION = 'LOCATION';
  static const String CONTACT = 'CONTACT';
  static const String STICKER = 'STICKER';
  static const String GIF = 'GIF';
  static const String ANNOUNCEMENT = 'ANNOUNCEMENT';
}

class MessageStatus {
  static const String PENDING = 'PENDING';
  static const String SENT = 'SENT';
  static const String DELIVERED = 'DELIVERED';
  static const String READ = 'READ';
}

class MessageUser {
  MessageUser({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
  });

  factory MessageUser.fromJson(final Map<String, dynamic> json) {
    return MessageUser(
      id: json['id'] as String,
      name: json['name'] as String,
      email: json['email'] as String,
      photoUrl: json['photoUrl'] as String?,
    );
  }

  final String id;
  final String name;
  final String email;
  final String? photoUrl;
}

class Message {
  Message({
    required this.id,
    required this.roomId,
    required this.senderUser,
    required this.message,
    required this.type,
    required this.isDeleted,
    this.createdAt,
    this.updatedAt,
    this.belongsToMessage,
    this.status = MessageStatus.SENT,
    this.forwardedFromRoomId,
    this.editedAt,
  });

  factory Message.fromJson(final Map<String, dynamic> json) {
    return Message(
      id: json['id'] as String,
      roomId: json['roomId'] as String,
      senderUser:
          MessageUser.fromJson(json['senderUser'] as Map<String, dynamic>),
      message: json['message'] as String,
      type: json['type'] as String,
      belongsToMessage: json['belongsToMessage'] != null
          ? Message.fromJson(json['belongsToMessage'] as Map<String, dynamic>)
          : null,
      isDeleted: json['isDeleted'] as bool,
      forwardedFromRoomId: json['forwardedFromRoomId'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
      editedAt: json['editedAt'] != null
          ? DateTime.parse(json['editedAt'] as String)
          : null,
    );
  }

  final String id;
  final String roomId;
  final MessageUser senderUser;
  final String message;
  final String type;
  final Message? belongsToMessage;
  bool isDeleted;
  String status;
  final String? forwardedFromRoomId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? editedAt;
}