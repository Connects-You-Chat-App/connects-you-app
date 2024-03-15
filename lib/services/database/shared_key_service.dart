import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';

import '../../constants/keys.dart';
import '../../models/objects/shared_key.dart';

class SharedKeyModelService {
  SharedKeyModelService._() {
    openRealm();
  }

  static late final SharedKeyModelService _sharedKeyModelService;

  factory SharedKeyModelService() => _sharedKeyModelService =
      _sharedKeyModelService ?? SharedKeyModelService._();

  late Realm _realm;

  openRealm() {
    final Configuration _config = Configuration.local(
      [SharedKeyModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY.codeUnits,
    );
    _realm = Realm(_config);
  }

  closeRealm() {
    if (!_realm.isClosed) {
      _realm.close();
    }
  }

  List<SharedKeyModel> getAllSharedKeys() {
    return _realm.all<SharedKeyModel>().toList(growable: true);
  }

  bool addSharedKey(final SharedKeyModel sharedKey) {
    try {
      _realm.write(() {
        _realm.add<SharedKeyModel>(sharedKey);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool addSharedKeys(final List<SharedKeyModel> sharedKeys) {
    try {
      _realm.write(() {
        _realm.addAll<SharedKeyModel>(sharedKeys);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool addRawSharedKeys(List<SharedKeyModel> sharedKeys) {
    try {
      _realm.write(() {
        _realm.addAll<SharedKeyModel>(sharedKeys);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  SharedKeyModel? getSharedKeyForUser(final String userId) {
    return _realm.all<SharedKeyModel>().firstWhere(
        (final SharedKeyModel element) => element.forUserId == userId);
  }

  SharedKeyModel? getSharedKeyForRoom(final String roomId) {
    return _realm.all<SharedKeyModel>().firstWhere(
        (final SharedKeyModel element) => element.forRoomId == roomId);
  }

  bool resetSharedKeys(final List<SharedKeyModel> sharedKeys) {
    try {
      _realm.write(() {
        // _realm.deleteAll();
        _realm.addAll<SharedKeyModel>(sharedKeys, update: true);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}