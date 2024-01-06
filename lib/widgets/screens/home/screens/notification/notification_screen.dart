import 'package:connects_you/constants/locale.dart';
import 'package:connects_you/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class NotificationScreen extends GetView<NotificationsController> {
  const NotificationScreen({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchNotifications,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Obx(
        () => controller.notifications.isEmpty
            ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                      ),
                      const Text(Locale.appName)
                    ],
                  ),
                ),
              )
            : ListView.separated(
                itemCount: controller.notifications.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  final notification = controller.notifications[index];
                  return ListTile(
                    title: Text(notification.message),
                    subtitle: Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            controller.joinGroup(index);
                          },
                          child: const Text(Locale.join),
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }
}