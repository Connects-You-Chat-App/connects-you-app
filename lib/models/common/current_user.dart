import 'package:connects_you/models/base/user.dart';

class CurrentUser extends User {
  final String? privateKey;
  final String token;

  CurrentUser({
    required super.id,
    required super.name,
    required super.email,
    required super.publicKey,
    super.photoUrl,
    this.privateKey,
    required this.token,
  });
}