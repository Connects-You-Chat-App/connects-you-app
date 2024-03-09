import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../controllers/root_controller.dart';
import '../controllers/settings_controller.dart';
import '../controllers/socket_controller.dart';
import '../controllers/users_controller.dart';

class RootBinding implements Bindings {
  const RootBinding();

  @override
  void dependencies() {
    Get
      ..put(RootController(), permanent: true)
      ..put(AuthController(), permanent: true)
      ..put(SocketController(), permanent: true)
      ..put(SettingController(), permanent: true)
      ..put(UsersController(), permanent: true);
  }
}