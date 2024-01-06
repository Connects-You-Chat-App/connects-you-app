import 'package:connects_you/constants/status_codes.dart';
import 'package:connects_you/extensions/map.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/responses/main.dart';
import 'package:connects_you/service/server.dart';

class UserService {
  const UserService._();

  static UserService? _instance;

  factory UserService() {
    return _instance ??= const UserService._();
  }

  Future<Response<List<User>>> getUsers() async {
    final response = await ServerApi().get(
      endpoint: Endpoints.ALL_USERS,
    );
    final body = response.decodedBody as Map<String, dynamic>;
    if (response.statusCode == StatusCodes.SUCCESS) {
      return Response<List<User>>(
        code: response.statusCode,
        message: body.get('message', ''),
        response: body
            .get("users", [])
            .map<User>((key) => User.fromJson(key))
            .toList(),
      );
    }
    return Response<List<User>>(
      code: response.statusCode,
      message: body.get('message', ''),
      response: [],
    );
  }
}