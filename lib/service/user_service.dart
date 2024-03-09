import 'package:http_wrapper/http.dart';

import '../constants/status_codes.dart';
import '../extensions/map.dart';
import '../models/base/user.dart';
import '../models/responses/main.dart';
import 'server.dart';

class UserService {
  factory UserService() {
    return _instance ??= const UserService._();
  }

  const UserService._();

  static UserService? _instance;

  Future<Response<List<User>>> getUsers() async {
    final DecodedResponse response = await ServerApi().get(
      endpoint: Endpoints.ALL_USERS,
    );
    final Map<String, dynamic> body =
    response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<User>>(
        code: response.statusCode,
        message: body.get('message', '') as String? ?? '',
        response: (body['users'] as List<dynamic>)
            .map<User>((final dynamic key) =>
            User.fromJson(key as Map<String, dynamic>))
            .toList(),
      );
    }
    return Response<List<User>>(
      code: response.statusCode,
      message: body.get('message', '') as String? ?? '',
      response: <User>[],
    );
  }
}