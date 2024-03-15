import 'package:flutter/foundation.dart';
import 'package:realm/realm.dart';

import '../../constants/keys.dart';
import '../../models/objects/secure_storage.dart';

class SecureStorageModelService {
  static const String _id = '1';

  SecureStorageModelService._() {
    openRealm();
  }

  static late final SecureStorageModelService _sharedKeyModelService;

  factory SecureStorageModelService() => _sharedKeyModelService =
      _sharedKeyModelService ?? SecureStorageModelService._();

  late Realm _realm;

  openRealm() {
    final Configuration _config = Configuration.local(
      [SecureStorageModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY.codeUnits,
    );
    _realm = Realm(_config);
  }

  closeRealm() {
    if (!_realm.isClosed) {
      _realm.close();
    }
  }

  Map<String, String> getValue() {
    return _realm.all<SecureStorageModel>().first.value;
  }

  bool setValue(final Map<String, String> value) {
    try {
      _realm.write(() {
        _realm.add<SecureStorageModel>(
          SecureStorageModel(_id, value: value),
          update: true,
        );
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool addOrUpdateValue(final String key, final String value) {
    try {
      _realm.write(() {
        _realm.add<SecureStorageModel>(
          SecureStorageModel(_id, value: {...getValue(), key: value}),
          update: true,
        );
      });
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }

  bool deleteValue() {
    try {
      _realm.deleteAll();
      return true;
    } on RealmException catch (e) {
      debugPrint(e.message);
      return false;
    }
  }
}