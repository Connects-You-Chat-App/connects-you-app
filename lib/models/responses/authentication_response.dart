import 'package:connects_you/models/common/current_user.dart';

enum AuthMethod {
  none,
  signup,
  login;
}

class AuthenticationResponse {
  final AuthMethod method;
  final CurrentUser user;

  const AuthenticationResponse({
    required this.user,
    required this.method,
  });

  factory AuthenticationResponse.fromJson(Map<String, dynamic> json) {
    final method = json['method'];
    final user = json['user'];
    final token = json['token'];
    return AuthenticationResponse(
      method: method == AuthMethod.login.name
          ? AuthMethod.login
          : method == AuthMethod.signup.name
              ? AuthMethod.signup
              : AuthMethod.none,
      user: CurrentUser(
        id: user['id'],
        name: user['name'],
        email: user['email'],
        photoUrl: user['photoUrl'],
        publicKey: user['publicKey'],
        privateKey: user['privateKey'],
        token: token,
      ),
    );
  }
}