import 'package:isar/isar.dart';

import '../common/current_user.dart';

part 'current_user_collection.g.dart';

@Collection()
@Name('CurrentUser')
class CurrentUserCollection {
  CurrentUserCollection({
    required this.userId,
    required this.name,
    required this.email,
    required this.publicKey,
    required this.token,
    this.id,
    this.photoUrl,
    this.description,
    this.privateKey,
    this.userKey,
  });

  Id? id;

  final String userId;
  final String name;
  final String email;
  final String publicKey;
  final String token;
  final String? photoUrl;
  final String? description;
  final String? privateKey;
  final String? userKey;

  static CurrentUserCollection fromCurrentUser(final CurrentUser user) =>
      CurrentUserCollection(
        userId: user.id,
        name: user.name,
        email: user.email,
        publicKey: user.publicKey,
        token: user.token,
        photoUrl: user.photoUrl,
        description: user.description,
        privateKey: user.privateKey,
        userKey: user.userKey,
      );

  CurrentUser toCurrentUser() => CurrentUser(
        id: userId,
        name: name,
        email: email,
        publicKey: publicKey,
        token: token,
        photoUrl: photoUrl,
        description: description,
        privateKey: privateKey,
        userKey: userKey,
      );
}