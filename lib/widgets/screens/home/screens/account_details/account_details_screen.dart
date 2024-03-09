import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../constants/locale.dart';
import '../../../../../controllers/auth_controller.dart';

class AccountDetailsScreen extends GetView<AuthController> {
  const AccountDetailsScreen({super.key});

  static const String routeName = '/account';

  @override
  Widget build(final BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton.icon(
              onPressed: controller.signOut,
              icon: const Icon(Icons.logout),
              label: const Text(Locale.logout),
            ),
          ],
        ),
      ),
    );
  }
}