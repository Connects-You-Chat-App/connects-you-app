import 'package:hive/hive.dart';

import '../base/user.dart';

part 'user_hive_object.g.dart';

@HiveType(typeId: 5)
class UserHiveObject extends HiveObject {
  UserHiveObject({
    required this.id,
    required this.name,
    required this.email,
    required this.publicKey,
    this.description,
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
  String? description;

  static UserHiveObject fromUser(final User user) => UserHiveObject(
        id: user.id,
        name: user.name,
        email: user.email,
        photoUrl: user.photoUrl,
        publicKey: user.publicKey,
        description: user.description,
      );

  User toUser() => User(
        id: id,
        name: name,
        email: email,
        photoUrl: photoUrl,
        publicKey: publicKey,
        description: description,
      );
}