import 'package:hive/hive.dart';

import '../common/current_user.dart';

part 'current_user_hive_object.g.dart';

@HiveType(typeId: 0)
class CurrentUserHiveObject extends HiveObject {
  CurrentUserHiveObject({
    required this.id,
    required this.name,
    required this.email,
    required this.publicKey,
    required this.privateKey,
    required this.token,
    this.photoUrl,
  });

  @HiveField(0)
  String id;
  @HiveField(1)
  String name;
  @HiveField(2)
  String email;
  @HiveField(3)
  String? photoUrl;
  @HiveField(4)
  String publicKey;
  @HiveField(5)
  String privateKey;
  @HiveField(6)
  String token;

  static CurrentUserHiveObject fromCurrentUser(final CurrentUser user) =>
      CurrentUserHiveObject(
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        publicKey: user.publicKey,
        privateKey: user.privateKey!,
        token: user.token,
      );

  CurrentUser toCurrentUser() => CurrentUser(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        publicKey: publicKey,
        privateKey: privateKey,
        token: token,
      );
}