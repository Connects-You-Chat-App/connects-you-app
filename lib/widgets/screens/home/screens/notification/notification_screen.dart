import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/home_controller.dart';
import '../../../../../controllers/notifications_controller.dart';
import '../../../../../models/base/notification.dart';

class NotificationScreen extends GetView<HomeController> {
  NotificationScreen({super.key}) {
    _controller = Get.put(NotificationsController());
  }

  late final NotificationsController _controller;

  static const String routeName = '/notifications';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => controller.toggleDrawer(),
        ),
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        onRefresh: _controller.fetchNotifications,
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        child: Obx(
          () => _controller.notifications.isEmpty
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
                  itemCount: _controller.notifications.length,
                  separatorBuilder:
                      (final BuildContext context, final int index) =>
                          const Divider(),
                  itemBuilder: (final BuildContext context, final int index) {
                    final Notification notification =
                        _controller.notifications[index];
                    return ListTile(
                      title: Text(notification.message),
                      subtitle: Row(
                        children: <Widget>[
                          TextButton(
                            onPressed: () {
                              _controller.joinGroup(index);
                            },
                            child: const Text(Locale.join),
                          ),
                        ],
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
