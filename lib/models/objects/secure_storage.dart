import 'package:realm/realm.dart';

part 'secure_storage.g.dart';

@RealmModel()
class _SecureStorageModel {
  @PrimaryKey()
  late String id;
  late Map<String, String> value;
}