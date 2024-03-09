import '../base/user.dart';

class CurrentUser extends User {
  CurrentUser({
    required super.id,
    required super.name,
    required super.email,
    required super.publicKey,
    required this.token,
    super.photoUrl,
    super.description,
    this.privateKey,
  });

  final String? privateKey;
  final String token;
}