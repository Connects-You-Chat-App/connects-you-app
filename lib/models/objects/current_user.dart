import 'package:realm/realm.dart';

part 'current_user.g.dart';

@RealmModel()
class _CurrentUserModel {
  @PrimaryKey()
  late String id;
  late String name;
  late String email;
  late String? description;
  late String? photoUrl;
  late String publicKey;
  late String privateKey;
  late String token;
  late String userKey;
}