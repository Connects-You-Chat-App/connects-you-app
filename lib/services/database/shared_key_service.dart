part of 'main.dart';

class _SharedKeyModelService {
  factory _SharedKeyModelService() => _sharedKeyModelService =
      _sharedKeyModelService ?? _SharedKeyModelService._();

  _SharedKeyModelService._() {
    _openRealm();
  }

  static _SharedKeyModelService? _sharedKeyModelService;

  static late Realm _realm;

  void _openRealm() {
    final Configuration config = Configuration.local(
      <SchemaObject>[SharedKeyModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(config);
  }

  static void closeRealm() {
    if (_sharedKeyModelService != null && !_realm.isClosed) {
      _realm.close();
      _sharedKeyModelService = null;
    }
  }

  List<SharedKeyModel> getAllSharedKeys() {
    return _realm.all<SharedKeyModel>().toList();
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

  SharedKeyModel? getSharedKeyForUser(final String userId) {
    final RealmResults<SharedKeyModel> sharedKeys =
        _realm.query<SharedKeyModel>(
      r'forUserId = $0',
      <String>[userId],
    );
    if (sharedKeys.isEmpty) {
      return null;
    }
    return sharedKeys.first;
  }

  SharedKeyModel? getSharedKeyForRoom(final String roomId) {
    final RealmResults<SharedKeyModel> sharedKeys =
        _realm.query<SharedKeyModel>(
      r'forRoomId = $0',
      <String>[roomId],
    );
    if (sharedKeys.isEmpty) {
      return null;
    }
    return sharedKeys.first;
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
