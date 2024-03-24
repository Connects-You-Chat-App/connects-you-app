// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:http_wrapper/http.dart';

import '../../constants/url.dart';
import '../../controllers/auth_controller.dart';
import 'auth_service.dart';
import 'common_service.dart';
import 'message_service.dart';
import 'notification_service.dart';
import 'room_service.dart';
import 'shared_key_service.dart';
import 'user_service.dart';

class Endpoints {
  static const String prefix = '/api/v1';
  static const String _AUTH = '$prefix/auth';
  static const String SHARED_KEY = '$prefix/shared-key';
  static const String USER = '$prefix/user';
  static const String ROOM = '$prefix/room';
  static const String NOTIFICATION = '$prefix/notification';
  static const String MESSAGE = '$prefix/message';

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
  static const String SEND_MESSAGE = '${Endpoints.MESSAGE}/send';
  static const String GET_ROOM_MESSAGES = '${Endpoints.MESSAGE}/by-room-id';
  static const String MARK_ROOM_MESSAGES_READ =
      '${Endpoints.MESSAGE}/mark-as-read';
  static const String UPDATED_DATA = '$prefix/updated-data';
}

class ServerApi extends Http {
  ServerApi._()
      : super(
          baseURL: URLs.baseURL,
          headers: <String, String>{
            'Content-Type': 'application/json',
          },
        );

  static ServerApi? _instance;

  factory ServerApi() {
    _instance ??= ServerApi._();
    if (_authController.authenticatedUser != null) {
      _instance!.headers = <String, String>{
        'Authorization': _authController.authenticatedUser!.token
      };
    }
    return _instance!;
  }

  static final AuthController _authController = Get.find<AuthController>();

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

  static MessageService get messageService {
    return MessageService();
  }

  static CommonService get commonService {
    return CommonService();
  }
// static const Details DetailsOps = Details();
// static const Me MeOps = Me();
}
