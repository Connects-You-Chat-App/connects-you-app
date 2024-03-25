part of 'main.dart';

class _RoomWithRoomUsersAndMessagesModelService {
  factory _RoomWithRoomUsersAndMessagesModelService() =>
      _roomWithRoomUsersModelService ??
      _RoomWithRoomUsersAndMessagesModelService._();

  _RoomWithRoomUsersAndMessagesModelService._() {
    _openRealm();
  }

  static _RoomWithRoomUsersAndMessagesModelService?
      _roomWithRoomUsersModelService;

  static late Realm _realm;

  void _openRealm() {
    final Configuration config = Configuration.local(
      <SchemaObject>[
        RoomWithRoomUsersAndMessagesModel.schema,
        UserModel.schema,
        MessageModel.schema,
        MessageUserModel.schema,
        MessageStatusModel.schema
      ],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(config);
  }

  static void closeRealm() {
    if (_roomWithRoomUsersModelService != null && !_realm.isClosed) {
      _realm.close();
      _roomWithRoomUsersModelService = null;
    }
  }

  bool addRoom(final RoomWithRoomUsersAndMessagesModel room) {
    try {
      _realm.write(() {
        _realm.add<RoomWithRoomUsersAndMessagesModel>(room);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool addMessages(final List<MessageModel> messages) {
    try {
      _realm.write(() {
        _realm.addAll(messages);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool addRoomUsersToRoom(
      final String roomId, final List<UserModel> roomUsers) {
    try {
      _realm.write(() {
        final RoomWithRoomUsersAndMessagesModel? room =
            _realm.find<RoomWithRoomUsersAndMessagesModel>(roomId);
        if (room != null) {
          room.roomUsers.addAll(roomUsers);
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  List<RoomWithRoomUsersAndMessagesModel> getAllRooms() {
    return _realm.all<RoomWithRoomUsersAndMessagesModel>().toList();
  }

  List<MessageModel> getAllMessages() {
    return _realm.all<MessageModel>().toList();
  }

  RoomWithRoomUsersAndMessagesModel getRoom(final String roomId) {
    return _realm.find<RoomWithRoomUsersAndMessagesModel>(roomId)!;
  }

  List<MessageModel> getRoomMessages(final String roomId) {
    final RealmResults<MessageModel> messages =
        _realm.query<MessageModel>(r'roomId = $0', <String>[roomId]);
    return messages.toList();
  }

  bool updateMessageStatus(final String messageId, final String status) {
    try {
      final MessageModel? message = _realm.find<MessageModel>(messageId);
      _realm.write(() {
        if (message != null) {
          message.status = status;
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool updateMessageStatusToDelivered(
      final List<String> messageIds, final List<String> userIds) {
    try {
      final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        r'id IN $0',
        <List<String>>[messageIds],
      );
      _realm.write(() {
        for (final MessageModel message in messages) {
          final List<MessageStatusModel> messageStatuses =
              message.messageStatuses;
          final Set<String> userIdSet = messageStatuses
              .map((final MessageStatusModel e) => e.userId)
              .toSet();
          for (final String userId in userIds) {
            if (!userIdSet.contains(userId)) {
              messageStatuses.add(
                MessageStatusModel(
                  userId,
                  true,
                  false,
                  deliveredAt: DateTime.now(),
                ),
              );
            }
          }
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool updateMessageStatusToRead(
      final List<String> messageIds, final List<String> userIds) {
    try {
      final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        r'id IN $0',
        <List<String>>[messageIds],
      );
      _realm.write(() {
        for (final MessageModel message in messages) {
          final List<MessageStatusModel> messageStatuses =
              message.messageStatuses;
          final Map<String, MessageStatusModel> userMap =
              <String, MessageStatusModel>{
            for (final MessageStatusModel messageStatus in messageStatuses)
              messageStatus.userId: messageStatus
          };

          for (final String userId in userIds) {
            if (userMap[userId] == null) {
              messageStatuses.add(
                MessageStatusModel(
                  userId,
                  true,
                  true,
                  deliveredAt: DateTime.now(),
                  readAt: DateTime.now(),
                ),
              );
            } else {
              final MessageStatusModel messageStatus = userMap[userId]!;
              messageStatus.isRead = true;
              messageStatus.readAt = DateTime.now();
            }
          }
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  RoomWithRoomUsersAndMessagesModel? getRoomFromRoomUserId(
      final String userId) {
    final RealmResults<RoomWithRoomUsersAndMessagesModel> rooms =
        _realm.query<RoomWithRoomUsersAndMessagesModel>(
      r'roomUsers.id = $0',
      <String>[userId],
    );
    if (rooms.isNotEmpty) {
      return rooms.first;
    }
    return null;
  }

  bool resetRooms(final List<RoomWithRoomUsersAndMessagesModel> rooms) {
    try {
      _realm.write(() {
        // _realm.deleteAll<RoomWithRoomUsersAndMessagesModel>();
        _realm.addAll(rooms, update: true);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  Stream<RealmResultsChanges<MessageModel>> getRoomMessageStream(
      final String roomId) {
    final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        r'roomId = $0 SORT(createdAt DESC)', <String>[roomId]);
    return messages.changes;
  }

  Stream<RealmResultsChanges<RoomWithRoomUsersAndMessagesModel>>
      getRoomStream() {
    final RealmResults<RoomWithRoomUsersAndMessagesModel> rooms =
        _realm.all<RoomWithRoomUsersAndMessagesModel>();
    return rooms.changes;
  }

  bool resetMessages(final List<MessageModel> messages) {
    try {
      _realm.write(() {
        // _realm.deleteAll<MessageModel>();
        _realm.addAll(messages, update: true);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool markSenderMessageRead(final List<String> messagesIds) {
    try {
      final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        r'id IN $0',
        <List<String>>[messagesIds],
      );
      _realm.write(() {
        for (final MessageModel message in messages) {
          message.status = MessageStatus.READ_BY_ME;
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}
