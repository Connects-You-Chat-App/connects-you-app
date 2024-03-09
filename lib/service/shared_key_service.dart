import 'dart:convert';

import 'package:http_wrapper/http.dart';

import '../constants/status_codes.dart';
import '../extensions/map.dart';
import '../models/common/shared_key.dart';
import '../models/responses/main.dart';
import 'server.dart';

class SharedKeyService {
  factory SharedKeyService() {
    return _instance ??= const SharedKeyService._();
  }

  const SharedKeyService._();

  static SharedKeyService? _instance;

  Future<Response<List<SharedKey>>> getKeys() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.SHARED_KEY,
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<SharedKey>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['keys'] as List<dynamic>)
            .map((final dynamic e) =>
                SharedKey.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return Response<List<SharedKey>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <SharedKey>[],
    );
  }

  Future<Response<bool>> saveKey(final SharedKey sharedKey) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.SAVE_SHARED_KEY,
      body: jsonEncode(<String, String?>{
        'key': sharedKey.key,
        'forUserId': sharedKey.forUserId,
        'roomId': sharedKey.forRoomId,
      }),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: true,
      );
    }
    return Response<bool>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: false,
    );
  }

  Future<Response<bool>> saveKeys(final List<SharedKey> sharedKeys) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.SAVE_SHARED_KEYS,
      body: jsonEncode(sharedKeys
          .map((final SharedKey sharedKey) => <String, String?>{
                'key': sharedKey.key,
                'forUserId': sharedKey.forUserId,
                'roomId': sharedKey.forRoomId,
              })
          .toList()),
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: true,
      );
    }
    return Response<bool>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: false,
    );
  }
}