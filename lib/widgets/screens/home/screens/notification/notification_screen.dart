import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/notifications_controller.dart';
import '../../../../../models/base/notification.dart';

class NotificationScreen extends GetView<NotificationsController> {
  const NotificationScreen({super.key});

  static const String routeName = '/notifications';

  @override
  Widget build(final BuildContext context) {
    return RefreshIndicator(
      onRefresh: controller.fetchNotifications,
      triggerMode: RefreshIndicatorTriggerMode.anywhere,
      child: Obx(
        () => controller.notifications.isEmpty
            ? SingleChildScrollView(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    children: <Widget>[
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
                separatorBuilder:
                    (final BuildContext context, final int index) =>
                        const Divider(),
                itemBuilder: (final BuildContext context, final int index) {
                  final Notification notification =
                      controller.notifications[index];
                  return ListTile(
                    title: Text(notification.message),
                    subtitle: Row(
                      children: <Widget>[
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