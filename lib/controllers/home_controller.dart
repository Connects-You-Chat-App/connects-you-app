import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';

import '../widgets/screens/home/screens/account_details/account_details_screen.dart';
import '../widgets/screens/home/screens/inbox/inbox_screen.dart';
import '../widgets/screens/home/screens/notification/notification_screen.dart';
import 'notifications_controller.dart';
import 'rooms_controller.dart';

class HomeController extends GetxController {
  late final List<StatelessWidget> screens;

  final RxInt _currentIndex = 0.obs;
  final Rx<bool> _hideNavBarAndFloatingButton = false.obs;

  late PageController? _controller;

  int get currentIndex => _currentIndex.value;

  PageController? get controller => _controller;

  bool get hideNavBarAndFloatingButton => _hideNavBarAndFloatingButton.value;

  @override
  void onInit() {
    screens = <StatelessWidget>[
      const InboxScreen(),
      const NotificationScreen(),
      const AccountDetailsScreen(),
    ];
    Get.put(RoomsController());
    Get.put(NotificationsController());
    _controller = PageController(initialPage: _currentIndex.value);
    super.onInit();
  }

  void onCurrentIndexChanged(final int index) {
    _currentIndex.value = index;
  }

  void changeIndex(final int index) {
    _controller?.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  void navigate(final String routeName) {
    switch (routeName) {
      case InboxScreen.routeName:
        return changeIndex(0);
      case NotificationScreen.routeName:
        return changeIndex(1);
      case AccountDetailsScreen.routeName:
        return changeIndex(2);
    }
  }

  void toggleNavBarAndFloatingButtonVisibility(
      final ScrollDirection scrollDirection) {
    switch (scrollDirection) {
      case ScrollDirection.reverse:
        if (!_hideNavBarAndFloatingButton.value) {
          _hideNavBarAndFloatingButton.value = true;
        }
        return;
      case ScrollDirection.idle:
      case ScrollDirection.forward:
        if (_hideNavBarAndFloatingButton.value) {
          _hideNavBarAndFloatingButton.value = false;
        }
    }
  }
}