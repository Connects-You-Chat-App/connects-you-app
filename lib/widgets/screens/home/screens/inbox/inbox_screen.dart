import 'package:connects_you/controllers/home_controller.dart';
import 'package:connects_you/controllers/users_controller.dart';
import 'package:connects_you/widgets/common/button.dart';
import 'package:connects_you/widgets/screens/home/screens/inbox/rooms.dart';
import 'package:connects_you/widgets/screens/users/users_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

class InboxScreen extends GetView<HomeController> {
  const InboxScreen({super.key});

  static const String routeName = '/inbox';

  void onFloatingButtonPressed() {
    Get.find<UsersController>().fetchAllUsers();
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.9,
      ),
      builder: (_) => const UsersScreen(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener<UserScrollNotification>(
        onNotification: (scrollInfo) {
          if (scrollInfo.direction != ScrollDirection.idle &&
              scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            return false;
          }
          controller.toggleNavBarAndFloatingButtonVisibility(
            scrollInfo.direction,
          );
          return true;
        },
        child: const Rooms(),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Obx(
        () => AnimatedContainer(
          height: 50,
          margin: const EdgeInsets.only(bottom: 80, right: 10),
          duration: const Duration(milliseconds: 200),
          width: controller.hideNavBarAndFloatingButton ? 50 : 155,
          child: AppButton(
            radius: 15,
            icon:
                const Icon(Icons.person_add_alt_1_rounded, color: Colors.white),
            text: controller.hideNavBarAndFloatingButton ? null : 'Users',
            onPressed: onFloatingButtonPressed,
          ),
        ),
      ),
    );
  }
}