import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/auth_controller.dart';
import '../../../../../controllers/home_controller.dart';

class AccountDetailsScreen extends GetView<HomeController> {
  AccountDetailsScreen({super.key}) {
    _authController = Get.find<AuthController>();
  }

  late final AuthController _authController;
  static const String routeName = '/account';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => controller.toggleDrawer(),
        ),
        title: Text(_authController.authenticatedUser?.name ?? ''),
      ),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton.icon(
              onPressed: _authController.signOut,
              icon: const Icon(Icons.logout),
              label: const Text(Locale.logout),
            ),
          ],
        ),
      ),
    );
  }
}
