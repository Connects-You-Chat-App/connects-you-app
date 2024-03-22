import 'package:flutter/material.dart' hide Drawer;
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../common/screen_container.dart';
import '../drawer/drawer.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    _homeController = Get.put(HomeController());
  }

  static const String routeName = '/home';

  late final HomeController _homeController;

  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    final ThemeData theme = Theme.of(context);
    return ScreenContainer(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Obx(
          () => ZoomDrawer(
            menuScreen: const Drawer(),
            mainScreen: IndexedStack(
              index: _homeController.currentIndex,
              children: _homeController.screens,
            ),
            clipMainScreen: false,
            mainScreenScale: 0.25,
            // moveMenuScreen: false,
            controller: _homeController.controller,
            borderRadius: 32.0,
            showShadow: true,
            angle: -0.0,
            menuScreenWidth: mediaQuery.size.width * 0.65,
            drawerShadowsBackgroundColor: Colors.blueAccent,
            slideWidth: mediaQuery.size.width * 0.65,
            androidCloseOnBackTap: true,
            mainScreenTapClose: true,
          ),
        ),
      ),
    );
  }
}
