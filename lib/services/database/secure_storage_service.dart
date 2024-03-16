part of 'main.dart';

class _SecureStorageModelService {
  static const String _id = '1';

  _SecureStorageModelService._() {
    _openRealm();
  }

  static _SecureStorageModelService? _secureStorageModelService;

  factory _SecureStorageModelService() => _secureStorageModelService =
      _secureStorageModelService ?? _SecureStorageModelService._();

  static late Realm _realm;

  _openRealm() {
    final Configuration _config = Configuration.local(
      [SecureStorageModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(_config);
  }

  static closeRealm() {
    if (_secureStorageModelService != null && !_realm.isClosed) {
      _realm.close();
      _secureStorageModelService = null;
    }
  }

  Map<String, String>? getValue() {
    final RealmResults<SecureStorageModel> _secureStorageModel =
        _realm.all<SecureStorageModel>();
    return _secureStorageModel.isEmpty ? null : _secureStorageModel.first.value;
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
          SecureStorageModel(_id, value: {...(getValue() ?? {}), key: value}),
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