import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../../../../../controllers/home_controller.dart';
import '../../../../../controllers/users_controller.dart';
import '../../../../common/button.dart';
import '../../../users/users_screen.dart';
import 'rooms.dart';

class InboxScreen extends GetView<HomeController> {
  const InboxScreen({super.key});

  static const String routeName = '/inbox';

  void onFloatingButtonPressed() {
    Get.find<UsersController>().fetchAllUsers();
    showModalBottomSheet<void>(
      context: Get.context!,
      isScrollControlled: true,
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.9,
      ),
      builder: (final _) => const UsersScreen(),
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => controller.toggleDrawer(),
        ),
        title: const Text('Inbox'),
      ),
      body: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(30),
            bottomRight: Radius.circular(30),
          ),
          color: theme.colorScheme.secondaryContainer,
        ),
        child: NotificationListener<UserScrollNotification>(
          onNotification: (final UserScrollNotification scrollInfo) {
            if (scrollInfo.direction != ScrollDirection.idle &&
                scrollInfo.metrics.pixels ==
                    scrollInfo.metrics.maxScrollExtent) {
              return false;
            }
            controller.toggleNavBarAndFloatingButtonVisibility(
              scrollInfo.direction,
            );
            return true;
          },
          child: Rooms(),
        ),
      ),
      floatingActionButtonAnimator: FloatingActionButtonAnimator.scaling,
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: Obx(
          () => AnimatedContainer(
            height: 50,
            duration: const Duration(milliseconds: 200),
            width: controller.hideNavBarAndFloatingButton ? 50 : 155,
            child: AppButton(
              radius: 15,
              icon: const Icon(Icons.person_add_alt_1_rounded,
                  color: Colors.white),
              text: controller.hideNavBarAndFloatingButton ? null : 'Users',
              onPressed: onFloatingButtonPressed,
            ),
          ),
        ),
      ),
    );
  }
}
