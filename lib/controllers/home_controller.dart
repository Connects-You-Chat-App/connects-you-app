import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../widgets/screens/home/screens/account_details/account_details_screen.dart';
import '../widgets/screens/home/screens/inbox/inbox_screen.dart';
import '../widgets/screens/home/screens/notification/notification_screen.dart';

class HomeController extends GetxController {
  late final List<StatelessWidget> screens;

  final RxInt _currentIndex = 0.obs;
  final Rx<bool> _hideNavBarAndFloatingButton = false.obs;

  late ZoomDrawerController _controller;

  int get currentIndex => _currentIndex.value;

  ZoomDrawerController get controller => _controller;

  bool get hideNavBarAndFloatingButton => _hideNavBarAndFloatingButton.value;

  final RxBool isDrawerOpen = false.obs;

  @override
  void onInit() {
    screens = <StatelessWidget>[
      const InboxScreen(key: ValueKey<String>('inbox')),
      NotificationScreen(key: const ValueKey<String>('notification')),
      AccountDetailsScreen(key: const ValueKey<String>('account_details')),
    ];
    _controller = ZoomDrawerController();
    Future.delayed(const Duration(seconds: 1), () {
      _controller.stateNotifier?.addListener(() {
        if (_controller.isOpen!()) {
          isDrawerOpen.value = true;
        } else {
          isDrawerOpen.value = false;
        }
      });
    });

    super.onInit();
  }

  @override
  void onClose() {
    _controller.stateNotifier!.dispose();
    super.onClose();
  }

  void changeIndex(final int index) {
    if (_controller.toggle != null) {
      _controller.toggle!.call()?.then((value) => _currentIndex.value = index);
    }
  }

  void toggleDrawer() {
    if (_controller.toggle != null) {
      _controller.toggle!.call();
    }
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
