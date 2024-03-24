part of 'main.dart';

class _SecureStorageModelService {
  factory _SecureStorageModelService() => _secureStorageModelService =
      _secureStorageModelService ?? _SecureStorageModelService._();

  _SecureStorageModelService._() {
    _openRealm();
  }

  static const String _id = '1';

  static _SecureStorageModelService? _secureStorageModelService;

  static late Realm _realm;

  void _openRealm() {
    final Configuration config = Configuration.local(
      <SchemaObject>[SecureStorageModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(config);
  }

  static void closeRealm() {
    if (_secureStorageModelService != null && !_realm.isClosed) {
      _realm.close();
      _secureStorageModelService = null;
    }
  }

  Map<String, String>? getValue() {
    final RealmResults<SecureStorageModel> secureStorageModel =
        _realm.all<SecureStorageModel>();
    return secureStorageModel.isEmpty ? null : secureStorageModel.first.value;
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
          SecureStorageModel(_id, value: <String, String>{
            ...getValue() ?? <String, String>{},
            key: value
          }),
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
