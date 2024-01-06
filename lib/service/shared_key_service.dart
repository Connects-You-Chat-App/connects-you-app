import 'dart:convert';

import 'package:connects_you/constants/status_codes.dart';
import 'package:connects_you/extensions/map.dart';
import 'package:connects_you/models/common/shared_key.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';

class SharedKeyService {
  const SharedKeyService._();

  static SharedKeyService? _instance;

  factory SharedKeyService() {
    return _instance ??= const SharedKeyService._();
  }

  Future<Response<List<SharedKey>>> getKeys() async {
    final response = await ServerApi().get(
      endpoint: Endpoints.SHARED_KEY,
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<SharedKey>>(
        code: response.statusCode,
        message: body.get('message', ''),
        response: body
            .get("keys", [])
            .map<SharedKey>((key) => SharedKey.fromJson(key))
            .toList(),
      );
    }
    return Response<List<SharedKey>>(
      code: response.statusCode,
      message: body.get('message', ''),
      response: [],
    );
  }

  Future<Response<bool>> saveKey(SharedKey sharedKey) async {
    final response = await ServerApi().post(
      endpoint: Endpoints.SAVE_SHARED_KEY,
      body: jsonEncode({
        'key': sharedKey.key,
        'forUserId': sharedKey.forUserId,
        'roomId': sharedKey.forRoomId,
      }),
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: response.statusCode,
        message: body.get('message', ''),
        response: true,
      );
    }
    return Response<bool>(
      code: response.statusCode,
      message: body.get('message', ''),
      response: false,
    );
  }

  Future<Response<bool>> saveKeys(List<SharedKey> sharedKeys) async {
    final response = await ServerApi().post(
      endpoint: Endpoints.SAVE_SHARED_KEYS,
      body: jsonEncode(sharedKeys
          .map((sharedKey) => ({
                'key': sharedKey.key,
                'forUserId': sharedKey.forUserId,
                'roomId': sharedKey.forRoomId,
              }))
          .toList()),
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<bool>(
        code: response.statusCode,
        message: body.get('message', ''),
        response: true,
      );
    }
    return Response<bool>(
      code: response.statusCode,
      message: body.get('message', ''),
      response: false,
    );
  }
}