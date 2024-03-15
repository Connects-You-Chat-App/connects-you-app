import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart' hide User;

import '../../constants/keys.dart';
import '../../models/objects/room_with_room_users_and_messages.dart';

class RoomWithRoomUsersAndMessagesModelService {
  RoomWithRoomUsersAndMessagesModelService._() {
    openRealm();
  }

  static late final RoomWithRoomUsersAndMessagesModelService
      _roomWithRoomUsersAndMessagesModelService;

  factory RoomWithRoomUsersAndMessagesModelService() =>
      _roomWithRoomUsersAndMessagesModelService =
          _roomWithRoomUsersAndMessagesModelService ??
              RoomWithRoomUsersAndMessagesModelService._();

  late Realm _realm;

  openRealm() {
    final Configuration _config = Configuration.local(
      [RoomWithRoomUsersAndMessagesModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY.codeUnits,
    );
    _realm = Realm(_config);
  }

  closeRealm() {
    if (!_realm.isClosed) {
      _realm.close();
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
    return _realm
        .all<RoomWithRoomUsersAndMessagesModel>()
        .toList(growable: true);
  }

  List<MessageModel> getAllMessages() {
    return _realm.all<MessageModel>().toList(growable: true);
  }

  List<MessageModel> getRoomMessages(final String roomId) {
    final RoomWithRoomUsersAndMessagesModel? room =
        _realm.find<RoomWithRoomUsersAndMessagesModel>(roomId);
    return room?.messages.toList(growable: true) ?? <MessageModel>[];
  }

  bool updateMessage(final MessageModel message) {
    try {
      _realm.write(() {
        final MessageModel? msg = _realm.find<MessageModel>(message.id);
        if (msg != null) {
          msg.message = message.message;
          msg.type = message.type;
          msg.belongsToMessage = message.belongsToMessage != null
              ? message.belongsToMessage
              : null;
          msg.senderUser = message.senderUser;
          msg.createdAt = message.createdAt;
          msg.updatedAt = message.updatedAt;
        }
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  List<MessageModel> getMessagesWithMessageIds(final List<String> messageIds) {
    final RealmResults<MessageModel> messages = _realm.query<MessageModel>(
      "id IN \$0",
      [messageIds],
    );
    return messages.toList(growable: true);
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