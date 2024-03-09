import '../common/current_user.dart';

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
      user: CurrentUser(
        id: user['id'] as String,
        name: user['name'] as String,
        email: user['email'] as String,
        photoUrl: user['photoUrl'] as String?,
        description: user['description'] as String?,
        publicKey: user['publicKey'] as String,
        privateKey: user['privateKey'] as String,
        token: token,
      ),
    );
  }

  final AuthMethod method;
  final CurrentUser user;
}