part of 'main.dart';

class _CurrentUserModelService {
  factory _CurrentUserModelService() => _currentUserModelService =
      _currentUserModelService ?? _CurrentUserModelService._();

  _CurrentUserModelService._() {
    _openRealm();
  }

  static _CurrentUserModelService? _currentUserModelService;

  static late Realm _realm;

  void _openRealm() {
    final Configuration config = Configuration.local(
      <SchemaObject>[CurrentUserModel.schema],
      encryptionKey: Keys.REALM_STORAGE_KEY,
    );
    _realm = Realm(config);
  }

  static void closeRealm() {
    if (_currentUserModelService != null && !_realm.isClosed) {
      _realm.close();
      _currentUserModelService = null;
    }
  }

  CurrentUserModel? getCurrentUser() {
    final RealmResults<CurrentUserModel> currentUser =
        _realm.all<CurrentUserModel>();
    return currentUser.isEmpty ? null : currentUser.first;
  }

  bool addCurrentUser(final CurrentUserModel user) {
    try {
      // deleteCurrentUser();
      _realm.write(() {
        final CurrentUserModel? currentUser = getCurrentUser();
        if (currentUser != null) {
          _realm.delete(currentUser);
        }
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
