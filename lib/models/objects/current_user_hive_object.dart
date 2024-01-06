import 'package:connects_you/models/common/current_user.dart';
import 'package:hive/hive.dart';

part 'current_user_hive_object.g.dart';

@HiveType(typeId: 0)
class CurrentUserHiveObject extends HiveObject {
  @HiveField(0)
  late String id;
  @HiveField(1)
  late String name;
  @HiveField(2)
  late String email;
  @HiveField(3)
  late String? photoUrl;
  @HiveField(4)
  late String publicKey;
  @HiveField(5)
  late String privateKey;
  @HiveField(6)
  late String token;

  CurrentUserHiveObject({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.publicKey,
    required this.privateKey,
    required this.token,
  });

  static CurrentUserHiveObject fromCurrentUser(CurrentUser user) =>
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