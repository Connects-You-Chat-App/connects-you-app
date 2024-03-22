part of 'main.dart';

class _RoomWithRoomUsersAndMessagesModelService {
  _RoomWithRoomUsersAndMessagesModelService._() {
    _openRealm();
  }

  static _RoomWithRoomUsersAndMessagesModelService?
      _roomWithRoomUsersAndMessagesModelService;

  factory _RoomWithRoomUsersAndMessagesModelService() =>
      _roomWithRoomUsersAndMessagesModelService =
          _roomWithRoomUsersAndMessagesModelService ??
              _RoomWithRoomUsersAndMessagesModelService._();

  static late Realm _realm;

  _openRealm() {
    final Configuration _config = Configuration.local(
      [
        RoomWithRoomUsersAndMessagesModel.schema,
        UserModel.schema,
        MessageModel.schema,
        MessageUserModel.schema,
        MessageStatusModel.schema
      ],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(_config);
  }

  static closeRealm() {
    if (_roomWithRoomUsersAndMessagesModelService != null && !_realm.isClosed) {
      _realm.close();
      _roomWithRoomUsersAndMessagesModelService = null;
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
        _realm.query<MessageModel>('roomId = \$0', [roomId]);
    return messages.toList();
  }

  bool updateMessageStatus(String messageId, String status) {
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
      List<String> messageIds, List<String> userIds) {
    try {
      final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        "id IN \$0",
        [messageIds],
      );
      _realm.write(() {
        for (final MessageModel message in messages) {
          final List<MessageStatusModel> messageStatuses =
              message.messageStatuses;
          final Set<String> userIdSet =
              messageStatuses.map((e) => e.userId).toSet();
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
      List<String> messageIds, List<String> userIds) {
    try {
      final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
        "id IN \$0",
        [messageIds],
      );
      _realm.write(() {
        for (final MessageModel message in messages) {
          final List<MessageStatusModel> messageStatuses =
              message.messageStatuses;
          final Map<String, MessageStatusModel> userMap = {
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
      "roomUsers.id = \$0",
      [userId],
    );
    if (rooms.isNotEmpty) {
      return rooms.first;
    }
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
    final RealmResults<MessageModel> messages = _realm
        .query<MessageModel>('roomId = \$0 SORT(updatedAt DESC)', [roomId]);
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
}