// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'room_with_room_users_and_messages.dart';

// **************************************************************************
// RealmObjectGenerator
// **************************************************************************

// ignore_for_file: type=lint
class MessageUserModel extends _MessageUserModel
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  MessageUserModel(
    String id,
    String name,
    String email,
    String publicKey, {
    String? photoUrl,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'publicKey', publicKey);
    RealmObjectBase.set(this, 'photoUrl', photoUrl);
  }

  MessageUserModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;

  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;

  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;

  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String get publicKey =>
      RealmObjectBase.get<String>(this, 'publicKey') as String;

  @override
  set publicKey(String value) => RealmObjectBase.set(this, 'publicKey', value);

  @override
  String? get photoUrl =>
      RealmObjectBase.get<String>(this, 'photoUrl') as String?;

  @override
  set photoUrl(String? value) => RealmObjectBase.set(this, 'photoUrl', value);

  @override
  Stream<RealmObjectChanges<MessageUserModel>> get changes =>
      RealmObjectBase.getChanges<MessageUserModel>(this);

  @override
  MessageUserModel freeze() =>
      RealmObjectBase.freezeObject<MessageUserModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MessageUserModel._);
    return const SchemaObject(
        ObjectType.embeddedObject, MessageUserModel, 'MessageUserModel', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('publicKey', RealmPropertyType.string),
      SchemaProperty('photoUrl', RealmPropertyType.string, optional: true),
    ]);
  }

  factory MessageUserModel.fromJson(final Map<String, dynamic> json) =>
      MessageUserModel(
        json['id'] as String,
        json['name'] as String,
        json['email'] as String,
        json['publicKey'] as String,
        photoUrl: json['photoUrl'] as String?,
      );
}

class MessageStatusModel extends _MessageStatusModel
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  MessageStatusModel(
    String userId,
    bool isDelivered,
    bool isRead, {
    DateTime? deliveredAt,
    DateTime? readAt,
  }) {
    RealmObjectBase.set(this, 'userId', userId);
    RealmObjectBase.set(this, 'isDelivered', isDelivered);
    RealmObjectBase.set(this, 'isRead', isRead);
    RealmObjectBase.set(this, 'deliveredAt', deliveredAt);
    RealmObjectBase.set(this, 'readAt', readAt);
  }

  MessageStatusModel._();

  @override
  String get userId => RealmObjectBase.get<String>(this, 'userId') as String;

  @override
  set userId(String value) => RealmObjectBase.set(this, 'userId', value);

  @override
  bool get isDelivered =>
      RealmObjectBase.get<bool>(this, 'isDelivered') as bool;

  @override
  set isDelivered(bool value) =>
      RealmObjectBase.set(this, 'isDelivered', value);

  @override
  bool get isRead => RealmObjectBase.get<bool>(this, 'isRead') as bool;

  @override
  set isRead(bool value) => RealmObjectBase.set(this, 'isRead', value);

  @override
  DateTime? get deliveredAt =>
      RealmObjectBase.get<DateTime>(this, 'deliveredAt') as DateTime?;

  @override
  set deliveredAt(DateTime? value) =>
      RealmObjectBase.set(this, 'deliveredAt', value);

  @override
  DateTime? get readAt =>
      RealmObjectBase.get<DateTime>(this, 'readAt') as DateTime?;

  @override
  set readAt(DateTime? value) => RealmObjectBase.set(this, 'readAt', value);

  @override
  Stream<RealmObjectChanges<MessageStatusModel>> get changes =>
      RealmObjectBase.getChanges<MessageStatusModel>(this);

  @override
  MessageStatusModel freeze() =>
      RealmObjectBase.freezeObject<MessageStatusModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MessageStatusModel._);
    return const SchemaObject(
        ObjectType.embeddedObject, MessageStatusModel, 'MessageStatusModel', [
      SchemaProperty('userId', RealmPropertyType.string),
      SchemaProperty('isDelivered', RealmPropertyType.bool),
      SchemaProperty('isRead', RealmPropertyType.bool),
      SchemaProperty('deliveredAt', RealmPropertyType.timestamp,
          optional: true),
      SchemaProperty('readAt', RealmPropertyType.timestamp, optional: true),
    ]);
  }

  factory MessageStatusModel.fromJson(final Map<String, dynamic> json) =>
      MessageStatusModel(
        json['userId'] as String,
        json['isDelivered'] as bool,
        json['isRead'] as bool,
        deliveredAt: json['deliveredAt'] != null
            ? DateTime.parse(json['deliveredAt'] as String)
            : null,
        readAt: json['readAt'] != null
            ? DateTime.parse(json['readAt'] as String)
            : null,
      );
}

class MessageModel extends _MessageModel
    with RealmEntity, RealmObjectBase, RealmObject {
  MessageModel(
    String id,
    String roomId,
    String message,
    String type,
    bool isDeleted,
    DateTime createdAt,
    DateTime updatedAt,
    String status, {
    MessageUserModel? senderUser,
    MessageModel? belongsToMessage,
    String? forwardedFromRoomId,
    DateTime? editedAt,
    Iterable<MessageStatusModel> messageStatuses = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'roomId', roomId);
    RealmObjectBase.set(this, 'senderUser', senderUser);
    RealmObjectBase.set(this, 'message', message);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'isDeleted', isDeleted);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'belongsToMessage', belongsToMessage);
    RealmObjectBase.set(this, 'status', status);
    RealmObjectBase.set(this, 'forwardedFromRoomId', forwardedFromRoomId);
    RealmObjectBase.set(this, 'editedAt', editedAt);
    RealmObjectBase.set<RealmList<MessageStatusModel>>(this, 'messageStatuses',
        RealmList<MessageStatusModel>(messageStatuses));
  }

  MessageModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;

  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get roomId => RealmObjectBase.get<String>(this, 'roomId') as String;

  @override
  set roomId(String value) => RealmObjectBase.set(this, 'roomId', value);

  @override
  MessageUserModel? get senderUser =>
      RealmObjectBase.get<MessageUserModel>(this, 'senderUser')
          as MessageUserModel?;

  @override
  set senderUser(covariant MessageUserModel? value) =>
      RealmObjectBase.set(this, 'senderUser', value);

  @override
  String get message => RealmObjectBase.get<String>(this, 'message') as String;

  @override
  set message(String value) => RealmObjectBase.set(this, 'message', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;

  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  bool get isDeleted => RealmObjectBase.get<bool>(this, 'isDeleted') as bool;

  @override
  set isDeleted(bool value) => RealmObjectBase.set(this, 'isDeleted', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;

  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;

  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  MessageModel? get belongsToMessage =>
      RealmObjectBase.get<MessageModel>(this, 'belongsToMessage')
          as MessageModel?;

  @override
  set belongsToMessage(covariant MessageModel? value) =>
      RealmObjectBase.set(this, 'belongsToMessage', value);

  @override
  String get status => RealmObjectBase.get<String>(this, 'status') as String;

  @override
  set status(String value) => RealmObjectBase.set(this, 'status', value);

  @override
  String? get forwardedFromRoomId =>
      RealmObjectBase.get<String>(this, 'forwardedFromRoomId') as String?;

  @override
  set forwardedFromRoomId(String? value) =>
      RealmObjectBase.set(this, 'forwardedFromRoomId', value);

  @override
  DateTime? get editedAt =>
      RealmObjectBase.get<DateTime>(this, 'editedAt') as DateTime?;

  @override
  set editedAt(DateTime? value) => RealmObjectBase.set(this, 'editedAt', value);

  @override
  RealmList<MessageStatusModel> get messageStatuses =>
      RealmObjectBase.get<MessageStatusModel>(this, 'messageStatuses')
          as RealmList<MessageStatusModel>;

  @override
  set messageStatuses(covariant RealmList<MessageStatusModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  Stream<RealmObjectChanges<MessageModel>> get changes =>
      RealmObjectBase.getChanges<MessageModel>(this);

  @override
  MessageModel freeze() => RealmObjectBase.freezeObject<MessageModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(MessageModel._);
    return const SchemaObject(
        ObjectType.realmObject, MessageModel, 'MessageModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('roomId', RealmPropertyType.string,
          indexType: RealmIndexType.fullText),
      SchemaProperty('senderUser', RealmPropertyType.object,
          optional: true, linkTarget: 'MessageUserModel'),
      SchemaProperty('message', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('isDeleted', RealmPropertyType.bool),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
      SchemaProperty('belongsToMessage', RealmPropertyType.object,
          optional: true, linkTarget: 'MessageModel'),
      SchemaProperty('status', RealmPropertyType.string),
      SchemaProperty('forwardedFromRoomId', RealmPropertyType.string,
          optional: true),
      SchemaProperty('editedAt', RealmPropertyType.timestamp, optional: true),
      SchemaProperty('messageStatuses', RealmPropertyType.object,
          linkTarget: 'MessageStatusModel',
          collectionType: RealmCollectionType.list),
    ]);
  }

  factory MessageModel.fromJson(final Map<String, dynamic> json) =>
      MessageModel(
        json['id'] as String,
        json['roomId'] as String,
        json['message'] as String,
        json['type'] as String,
        json['isDeleted'] as bool,
        DateTime.parse(json['createdAt'] as String),
        DateTime.parse(json['updatedAt'] as String),
        "",
        messageStatuses: json['messageStatuses'] != null
            ? (json['messageStatuses'] as List<dynamic>)
                .map((final dynamic e) =>
                    MessageStatusModel.fromJson(e as Map<String, dynamic>))
                .toList()
            : [],
        senderUser: MessageUserModel.fromJson(
            json['senderUser'] as Map<String, dynamic>),
        belongsToMessage: json['belongsToMessage'] != null
            ? MessageModel.fromJson(
                json['belongsToMessage'] as Map<String, dynamic>)
            : null,
        forwardedFromRoomId: json['forwardedFromRoomId'] as String?,
        editedAt: json['editedAt'] != null
            ? DateTime.parse(json['editedAt'] as String)
            : null,
      );
}

class UserModel extends _UserModel
    with RealmEntity, RealmObjectBase, EmbeddedObject {
  UserModel(
    String id,
    String name,
    String email,
    String publicKey, {
    String? photoUrl,
    String? description,
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'email', email);
    RealmObjectBase.set(this, 'photoUrl', photoUrl);
    RealmObjectBase.set(this, 'publicKey', publicKey);
    RealmObjectBase.set(this, 'description', description);
  }

  UserModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;

  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;

  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get email => RealmObjectBase.get<String>(this, 'email') as String;

  @override
  set email(String value) => RealmObjectBase.set(this, 'email', value);

  @override
  String? get photoUrl =>
      RealmObjectBase.get<String>(this, 'photoUrl') as String?;

  @override
  set photoUrl(String? value) => RealmObjectBase.set(this, 'photoUrl', value);

  @override
  String get publicKey =>
      RealmObjectBase.get<String>(this, 'publicKey') as String;

  @override
  set publicKey(String value) => RealmObjectBase.set(this, 'publicKey', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;

  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  Stream<RealmObjectChanges<UserModel>> get changes =>
      RealmObjectBase.getChanges<UserModel>(this);

  @override
  UserModel freeze() => RealmObjectBase.freezeObject<UserModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(UserModel._);
    return const SchemaObject(
        ObjectType.embeddedObject, UserModel, 'UserModel', [
      SchemaProperty('id', RealmPropertyType.string),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('email', RealmPropertyType.string),
      SchemaProperty('photoUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('publicKey', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
    ]);
  }

  factory UserModel.fromJson(final Map<String, dynamic> json) => UserModel(
        json['id'] as String,
        json['name'] as String,
        json['email'] as String,
        json['publicKey'] as String,
        photoUrl: json['photoUrl'] as String?,
        description: json['description'] as String?,
      );

  factory UserModel.fromMessageUserModel(
          final MessageUserModel messageUserModel) =>
      UserModel(
        messageUserModel.id,
        messageUserModel.name,
        messageUserModel.email,
        messageUserModel.publicKey,
        photoUrl: messageUserModel.photoUrl,
      );
}

class RoomWithRoomUsersAndMessagesModel
    extends _RoomWithRoomUsersAndMessagesModel
    with RealmEntity, RealmObjectBase, RealmObject {
  RoomWithRoomUsersAndMessagesModel(
    String id,
    String name,
    String type,
    DateTime createdAt,
    DateTime updatedAt,
    bool isNewlyCreatedRoom, {
    String? description,
    String? logoUrl,
    Iterable<UserModel> roomUsers = const [],
    Iterable<MessageModel> messages = const [],
  }) {
    RealmObjectBase.set(this, 'id', id);
    RealmObjectBase.set(this, 'name', name);
    RealmObjectBase.set(this, 'type', type);
    RealmObjectBase.set(this, 'description', description);
    RealmObjectBase.set(this, 'logoUrl', logoUrl);
    RealmObjectBase.set(this, 'createdAt', createdAt);
    RealmObjectBase.set(this, 'updatedAt', updatedAt);
    RealmObjectBase.set(this, 'isNewlyCreatedRoom', isNewlyCreatedRoom);
    RealmObjectBase.set<RealmList<UserModel>>(
        this, 'roomUsers', RealmList<UserModel>(roomUsers));
    RealmObjectBase.set<RealmList<MessageModel>>(
        this, 'messages', RealmList<MessageModel>(messages));
  }

  RoomWithRoomUsersAndMessagesModel._();

  @override
  String get id => RealmObjectBase.get<String>(this, 'id') as String;

  @override
  set id(String value) => RealmObjectBase.set(this, 'id', value);

  @override
  String get name => RealmObjectBase.get<String>(this, 'name') as String;

  @override
  set name(String value) => RealmObjectBase.set(this, 'name', value);

  @override
  String get type => RealmObjectBase.get<String>(this, 'type') as String;

  @override
  set type(String value) => RealmObjectBase.set(this, 'type', value);

  @override
  String? get description =>
      RealmObjectBase.get<String>(this, 'description') as String?;

  @override
  set description(String? value) =>
      RealmObjectBase.set(this, 'description', value);

  @override
  String? get logoUrl =>
      RealmObjectBase.get<String>(this, 'logoUrl') as String?;

  @override
  set logoUrl(String? value) => RealmObjectBase.set(this, 'logoUrl', value);

  @override
  DateTime get createdAt =>
      RealmObjectBase.get<DateTime>(this, 'createdAt') as DateTime;

  @override
  set createdAt(DateTime value) =>
      RealmObjectBase.set(this, 'createdAt', value);

  @override
  DateTime get updatedAt =>
      RealmObjectBase.get<DateTime>(this, 'updatedAt') as DateTime;

  @override
  set updatedAt(DateTime value) =>
      RealmObjectBase.set(this, 'updatedAt', value);

  @override
  RealmList<UserModel> get roomUsers =>
      RealmObjectBase.get<UserModel>(this, 'roomUsers') as RealmList<UserModel>;

  @override
  set roomUsers(covariant RealmList<UserModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  RealmList<MessageModel> get messages =>
      RealmObjectBase.get<MessageModel>(this, 'messages')
          as RealmList<MessageModel>;

  @override
  set messages(covariant RealmList<MessageModel> value) =>
      throw RealmUnsupportedSetError();

  @override
  bool get isNewlyCreatedRoom =>
      RealmObjectBase.get<bool>(this, 'isNewlyCreatedRoom') as bool;

  @override
  set isNewlyCreatedRoom(bool value) =>
      RealmObjectBase.set(this, 'isNewlyCreatedRoom', value);

  @override
  Stream<RealmObjectChanges<RoomWithRoomUsersAndMessagesModel>> get changes =>
      RealmObjectBase.getChanges<RoomWithRoomUsersAndMessagesModel>(this);

  @override
  RoomWithRoomUsersAndMessagesModel freeze() =>
      RealmObjectBase.freezeObject<RoomWithRoomUsersAndMessagesModel>(this);

  static SchemaObject get schema => _schema ??= _initSchema();
  static SchemaObject? _schema;

  static SchemaObject _initSchema() {
    RealmObjectBase.registerFactory(RoomWithRoomUsersAndMessagesModel._);
    return const SchemaObject(
        ObjectType.realmObject,
        RoomWithRoomUsersAndMessagesModel,
        'RoomWithRoomUsersAndMessagesModel', [
      SchemaProperty('id', RealmPropertyType.string, primaryKey: true),
      SchemaProperty('name', RealmPropertyType.string),
      SchemaProperty('type', RealmPropertyType.string),
      SchemaProperty('description', RealmPropertyType.string, optional: true),
      SchemaProperty('logoUrl', RealmPropertyType.string, optional: true),
      SchemaProperty('createdAt', RealmPropertyType.timestamp),
      SchemaProperty('updatedAt', RealmPropertyType.timestamp),
      SchemaProperty('roomUsers', RealmPropertyType.object,
          linkTarget: 'UserModel', collectionType: RealmCollectionType.list),
      SchemaProperty('messages', RealmPropertyType.object,
          linkTarget: 'MessageModel', collectionType: RealmCollectionType.list),
      SchemaProperty('isNewlyCreatedRoom', RealmPropertyType.bool),
    ]);
  }

  factory RoomWithRoomUsersAndMessagesModel.fromJson(
          final Map<String, dynamic> json) =>
      RoomWithRoomUsersAndMessagesModel(
        json['id'] as String,
        json['name'] as String,
        json['type'] as String,
        DateTime.parse(json['updatedAt'] as String),
        DateTime.parse(json['createdAt'] as String),
        json['isNewlyCreatedRoom'] as bool? ?? false,
        description: json['description'] as String?,
        logoUrl: json['logoUrl'] as String?,
        roomUsers: (json['roomUsers'] as List<dynamic>)
            .map((final dynamic e) =>
                UserModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
}
