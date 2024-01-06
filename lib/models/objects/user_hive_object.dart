import 'package:connects_you/models/base/user.dart';
import 'package:hive/hive.dart';

part 'user_hive_object.g.dart';

@HiveType(typeId: 4)
class UserHiveObject extends HiveObject {
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

  UserHiveObject({
    required this.id,
    required this.name,
    required this.email,
    this.photoUrl,
    required this.publicKey,
  });

  static UserHiveObject fromUser(User user) => UserHiveObject(
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        publicKey: user.publicKey!,
      );

  User toUser() => User(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        publicKey: publicKey,
      );
}