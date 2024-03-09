import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../bindings/root_binding.dart';
import '../../theme/app_theme.dart';
import 'home/home_screen.dart';
import 'room/room_screen.dart';
import 'splash/splash_screen.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(final BuildContext context) {
    return GetMaterialApp(
      title: 'Connects You',
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
      initialBinding: const RootBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appThemeLight,
      darkTheme: AppTheme.appThemeDark,
      getPages: <GetPage>[
        GetPage(
          name: SplashScreen.routeName,
          page: () => const SplashScreen(),
        ),
        GetPage(
          name: HomeScreen.routeName,
          page: () => HomeScreen(),
        ),
        GetPage(
          name: RoomScreen.routeName,
          page: () => RoomScreen(),
        ),
      ],
    );
  }
}