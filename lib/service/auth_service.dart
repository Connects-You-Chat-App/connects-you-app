import 'dart:convert';

import 'package:http_wrapper/http.dart';

import '../constants/status_codes.dart';
import '../extensions/map.dart';
import '../models/requests/authentication_request.dart';
import '../models/requests/save_user_keys_request.dart';
import '../models/responses/authentication_response.dart';
import '../models/responses/main.dart';
import 'server.dart';

class AuthService {
  factory AuthService() {
    return _cachedInstance ??= const AuthService._();
  }

  const AuthService._();

  static AuthService? _cachedInstance;

  Future<Response<AuthenticationResponse>?> authenticate(
      final AuthenticationRequest authRequest) async {
    final DecodedResponse authResponse = await ServerApi().post(
      endpoint: Endpoints.AUTHENTICATE,
      body: json.encode(authRequest.toJson()),
    );
    if (authResponse.statusCode == StatusCodes.SUCCESS) {
      final Map<String, dynamic> body =
          authResponse.decodedBody as Map<String, dynamic>;
      if (body.containsKey('user') &&
          body.containsKey('method') &&
          body.containsKey('token')) {
        return Response<AuthenticationResponse>(
          code: authResponse.statusCode,
          message: body.get('message', '') as String? ?? '',
          response: AuthenticationResponse.fromJson(body),
        );
      }
    }
    return null;
  }

  Future<Response<bool>> saveUserKeys(
      final SaveUserKeysRequest saveUserKeysRequest) async {
    final DecodedResponse authResponse = await ServerApi().post(
      endpoint: Endpoints.SAVE_KEYS,
      body: json.encode(saveUserKeysRequest.toJson()),
    );
    final Map<String, dynamic> body =
        authResponse.decodedBody as Map<String, dynamic>;
    if (authResponse.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: authResponse.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: true,
      );
    }
    return Response<bool>(
      code: authResponse.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: false,
    );
  }

  Future<Response<bool>?> signOut() async {
    final DecodedResponse signOutResponse =
        await ServerApi().patch(endpoint: Endpoints.SIGN_OUT);
    final Map<String, dynamic> body =
        signOutResponse.decodedBody as Map<String, dynamic>;
    if (<int>[StatusCodes.SUCCESS, StatusCodes.NO_UPDATE]
        .contains(signOutResponse.statusCode)) {
      return Response<bool>(
        code: signOutResponse.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: true,
      );
    }
    return Response<bool>(
      code: signOutResponse.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: false,
    );
  }

  Future<Response<String>?> refreshToken() async {
    final DecodedResponse refreshTokenResponse =
        await ServerApi().patch(endpoint: Endpoints.REFRESH_TOKEN);
    if (refreshTokenResponse.statusCode == StatusCodes.SUCCESS) {
      final Map<String, dynamic> body =
          refreshTokenResponse.decodedBody as Map<String, dynamic>;
      if (body.containsKey('token')) {
        return Response<String>(
          code: refreshTokenResponse.statusCode,
          message: body.get('message', '') as String? ?? '',
          response: body.get('token') as String? ?? '',
        );
      }
    }
    return null;
  }
}