import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';

import '../../constants/keys.dart';
import '../../models/objects/current_user.dart';

class CurrentUserModelService {
  CurrentUserModelService._() {
    openRealm();
  }

  static late final CurrentUserModelService _sharedKeyModelService;

  factory CurrentUserModelService() => _sharedKeyModelService =
      _sharedKeyModelService ?? CurrentUserModelService._();

  late Realm _realm;

  openRealm() {
    final Configuration _config = Configuration.local(
      [CurrentUserModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY.codeUnits,
    );
    _realm = Realm(_config);
  }

  closeRealm() {
    if (!_realm.isClosed) {
      _realm.close();
    }
  }

  CurrentUserModel getCurrentUser() {
    return _realm.all<CurrentUserModel>().first;
  }

  bool addCurrentUser(final CurrentUserModel user) {
    try {
      deleteCurrentUser();
      _realm.write(() {
        _realm.add<CurrentUserModel>(user);
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool deleteCurrentUser() {
    try {
      _realm.deleteAll();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}