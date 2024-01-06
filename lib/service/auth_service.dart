import 'dart:convert';

import 'package:connects_you/constants/status_codes.dart';
import 'package:connects_you/extensions/map.dart';
import 'package:connects_you/models/requests/authentication_request.dart';
import 'package:connects_you/models/requests/save_user_keys_request.dart';
import 'package:connects_you/models/responses/authentication_response.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';

class AuthService {
  const AuthService._();

  static AuthService? _cachedInstance;

  factory AuthService() {
    return _cachedInstance ??= const AuthService._();
  }

  Future<Response<AuthenticationResponse>?> authenticate(
      AuthenticationRequest authRequest) async {
    final authResponse = await ServerApi().post(
      endpoint: Endpoints.AUTHENTICATE,
      body: json.encode(authRequest.toJson()),
    );
    if (authResponse.statusCode == StatusCodes.SUCCESS) {
      final body = authResponse.decodedBody as Map<String, dynamic>;
      if (body.containsKey('user') &&
          body.containsKey('method') &&
          body.containsKey('token')) {
        return Response(
          code: authResponse.statusCode,
          message: body.get('message', ''),
          response: AuthenticationResponse.fromJson(body),
        );
      }
    }
    return null;
  }

  Future<Response<bool>> saveUserKeys(
      SaveUserKeysRequest saveUserKeysRequest) async {
    final authResponse = await ServerApi().post(
      endpoint: Endpoints.SAVE_KEYS,
      body: json.encode(saveUserKeysRequest.toJson()),
    );
    final body = authResponse.decodedBody as Map<String, dynamic>;
    if (authResponse.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: authResponse.statusCode,
        message: body.get('message', ''),
        response: true,
      );
    }
    return Response<bool>(
      code: authResponse.statusCode,
      message: body.get('message', ''),
      response: false,
    );
  }

  Future<Response<bool>?> signOut() async {
    final signOutResponse =
        await ServerApi().patch(endpoint: Endpoints.SIGN_OUT);
    final body = signOutResponse.decodedBody as Map<String, dynamic>;
    if ([StatusCodes.SUCCESS, StatusCodes.NO_UPDATE]
        .contains(signOutResponse.statusCode)) {
      return Response(
        code: signOutResponse.statusCode,
        message: body.get('message', ''),
        response: true,
      );
    }
    return Response(
      code: signOutResponse.statusCode,
      message: body.get('message', ''),
      response: false,
    );
  }

  Future<Response<String>?> refreshToken() async {
    final refreshTokenResponse =
        await ServerApi().patch(endpoint: Endpoints.REFRESH_TOKEN);
    if (refreshTokenResponse.statusCode == StatusCodes.SUCCESS) {
      final body = refreshTokenResponse.decodedBody as Map<String, dynamic>;
      if (body.containsKey('token')) {
        return Response(
          code: refreshTokenResponse.statusCode,
          message: body.get('message', ''),
          response: body.get('token'),
        );
      }
    }
    return null;
  }
}