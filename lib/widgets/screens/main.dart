import 'package:connects_you/bindings/root_binding.dart';
import 'package:connects_you/theme/app_theme.dart';
import 'package:connects_you/widgets/screens/home/home_screen.dart';
import 'package:connects_you/widgets/screens/room/room_screen.dart';
import 'package:connects_you/widgets/screens/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Root extends StatelessWidget {
  const Root({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Connects You',
      defaultTransition: Transition.cupertino,
      transitionDuration: const Duration(milliseconds: 500),
      initialBinding: const RootBinding(),
      debugShowCheckedModeBanner: false,
      theme: AppTheme.appThemeLight,
      darkTheme: AppTheme.appThemeDark,
      getPages: [
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
          page: () => const RoomScreen(),
        ),
      ],
    );
  }
}