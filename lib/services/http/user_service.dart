import 'package:http_wrapper/http.dart';

import '../../constants/status_codes.dart';
import '../../extensions/map.dart';
import '../../models/objects/room_with_room_users_and_messages.dart';
import '../../models/responses/main.dart';
import 'server.dart';

class UserService {
  const UserService._();

  static late final UserService _cachedInstance;

  factory UserService() => _cachedInstance ??= const UserService._();

  Future<Response<List<UserModel>>> getUsers() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.ALL_USERS,
    );
    final Map<String, dynamic> body =
        response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<UserModel>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['users'] as List<dynamic>)
            .map<UserModel>((final dynamic key) =>
                UserModel.fromJson(key as Map<String, dynamic>))
            .toList(growable: true),
      );
    }
    return Response<List<UserModel>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <UserModel>[],
    );
  }
}