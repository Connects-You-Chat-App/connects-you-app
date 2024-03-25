import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';

import '../../constants/keys.dart';
import '../../constants/message.dart';
import '../../models/objects/current_user.dart';
import '../../models/objects/room_with_room_users_and_messages.dart';
import '../../models/objects/secure_storage.dart';
import '../../models/objects/shared_key.dart';

part 'current_user_service.dart';
part 'room_with_room_users_and_messages.dart';
part 'secure_storage_service.dart';
part 'shared_key_service.dart';

class RealmService {
  static _SharedKeyModelService get sharedKeyModelService =>
      _SharedKeyModelService();

  static _RoomWithRoomUsersAndMessagesModelService
      get RoomWithRoomUsersModelService =>
          _RoomWithRoomUsersAndMessagesModelService();

  static _SecureStorageModelService get secureStorageModelService =>
      _SecureStorageModelService();

  static _CurrentUserModelService get currentUserModelService =>
      _CurrentUserModelService();

  static void closeAllRealms() {
    _SharedKeyModelService.closeRealm();
    _RoomWithRoomUsersAndMessagesModelService.closeRealm();
    _SecureStorageModelService.closeRealm();
    _CurrentUserModelService.closeRealm();
  }

  static void deleteAllRealms() {
    closeAllRealms();
    Realm.deleteRealm(Configuration.defaultRealmPath);
  }
}
