import 'package:connects_you/controllers/auth_controller.dart';
import 'package:connects_you/controllers/root_controller.dart';
import 'package:connects_you/controllers/settings_controller.dart';
import 'package:connects_you/controllers/socket_controller.dart';
import 'package:connects_you/controllers/users_controller.dart';
import 'package:get/get.dart';

class RootBinding implements Bindings {
  const RootBinding();

  @override
  void dependencies() {
    Get.put(RootController(), permanent: true);
    Get.put(AuthController(), permanent: true);
    Get.put(SocketController(), permanent: true);
    Get.put(SettingController(), permanent: true);
    Get.put(UsersController(), permanent: true);
  }
}