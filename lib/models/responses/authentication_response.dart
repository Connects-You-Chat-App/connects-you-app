import '../objects/current_user.dart';

enum AuthMethod {
  none,
  signup,
  login;
}

class AuthenticationResponse {
  const AuthenticationResponse({
    required this.user,
    required this.method,
  });

  factory AuthenticationResponse.fromJson(final Map<String, dynamic> json) {
    final String method = json['method'] as String;
    final Map<String, dynamic> user = json['user'] as Map<String, dynamic>;
    final String token = json['token'] as String;
    return AuthenticationResponse(
      method: method == AuthMethod.login.name
          ? AuthMethod.login
          : method == AuthMethod.signup.name
              ? AuthMethod.signup
              : AuthMethod.none,
      user: CurrentUserModel(
        user['id'] as String,
        user['name'] as String,
        user['email'] as String,
        user['publicKey'] as String,
        user['privateKey'] as String,
        token,
        '',
        photoUrl: user['photoUrl'] as String?,
        description: user['description'] as String?,
      ),
    );
  }

  final AuthMethod method;
  final CurrentUserModel user;
}