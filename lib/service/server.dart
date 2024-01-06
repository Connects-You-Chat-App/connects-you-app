// ignore_for_file: constant_identifier_names

import 'package:connects_you/constants/url.dart';
import 'package:connects_you/controllers/auth_controller.dart';
import 'package:connects_you/service/auth_service.dart';
import 'package:connects_you/service/notification_service.dart';
import 'package:connects_you/service/room_service.dart';
import 'package:connects_you/service/shared_key_service.dart';
import 'package:connects_you/service/user_service.dart';
import 'package:get/get.dart';
import 'package:http_wrapper/http.dart';

class Endpoints {
  static const String prefix = '/api/v1';
  static const String _AUTH = '$prefix/auth';
  static const String SHARED_KEY = '$prefix/shared-key';
  static const String USER = '$prefix/user';
  static const String ROOM = '$prefix/room';
  static const String NOTIFICATION = '$prefix/notification';
  static const String AUTHENTICATE = '${Endpoints._AUTH}/authenticate';
  static const String SAVE_KEYS = '${Endpoints._AUTH}/keys';
  static const String GET_SHARED_KEY = '${Endpoints.SHARED_KEY}/get';
  static const String SAVE_SHARED_KEY = '${Endpoints.SHARED_KEY}/save-key';
  static const String SAVE_SHARED_KEYS = '${Endpoints.SHARED_KEY}/save-keys';
  static const String REFRESH_TOKEN = '${Endpoints._AUTH}/refresh-token';
  static const String SIGN_OUT = '${Endpoints._AUTH}/sign-out';
  static const String CREATE_DUET_ROOM = '${Endpoints.ROOM}/create-duet';
  static const String CREATE_GROUP_ROOM = '${Endpoints.ROOM}/create-group';
  static const String JOIN_GROUP = '${Endpoints.ROOM}/join-group';
  static const String FETCH_ROOMS = '${Endpoints.ROOM}/all';
  static const String ALL_USERS = '${Endpoints.USER}/all';
  static const String ALL_NOTIFICATIONS = '${Endpoints.NOTIFICATION}/all';
}

class ServerApi extends Http {
  static final _authController = Get.find<AuthController>();

  ServerApi._()
      : super(
          baseURL: URLs.baseURL,
          headers: {
            "Content-Type": "application/json",
          },
        );

  static ServerApi? _instance;

  factory ServerApi() {
    _instance ??= ServerApi._();
    if (_authController.authenticatedUser != null) {
      _instance!.headers = {
        'Authorization': _authController.authenticatedUser!.token
      };
    }
    return _instance!;
  }

  static AuthService get authService {
    return AuthService();
  }

  static SharedKeyService get sharedKeyService {
    return SharedKeyService();
  }

  static UserService get usersService {
    return UserService();
  }

  static RoomService get roomService {
    return RoomService();
  }

  static NotificationService get notificationService {
    return NotificationService();
  }
// static const Details DetailsOps = Details();
// static const Me MeOps = Me();
}