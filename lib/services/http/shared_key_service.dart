import 'dart:convert';

import 'package:http_wrapper/http.dart';

import '../../constants/status_codes.dart';
import '../../extensions/map.dart';
import '../../models/objects/shared_key.dart';
import '../../models/responses/main.dart';
import 'server.dart';

class SharedKeyService {
  const SharedKeyService._();

  static SharedKeyService? _cachedInstance;

  factory SharedKeyService() => _cachedInstance ??= const SharedKeyService._();

  Future<Response<List<SharedKeyModel>>> getKeys() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.SHARED_KEY,
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<SharedKeyModel>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['keys'] as List<dynamic>)
            .map((final dynamic e) =>
                SharedKeyModel.fromJson(e as Map<String, dynamic>))
            .toList(),
      );
    }
    return Response<List<SharedKeyModel>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <SharedKeyModel>[],
    );
  }

  Future<Response<bool>> saveKey(final SharedKeyModel sharedKey) async {
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

  Future<Response<bool>> saveKeys(final List<SharedKeyModel> sharedKeys) async {
    final DecodedResponse response = await ServerApi().post(
      endpoint: Endpoints.SAVE_SHARED_KEYS,
      body: jsonEncode(sharedKeys
          .map((final SharedKeyModel sharedKey) => <String, String?>{
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