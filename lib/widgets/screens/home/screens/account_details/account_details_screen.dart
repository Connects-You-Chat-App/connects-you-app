import 'package:connects_you/constants/locale.dart';
import 'package:connects_you/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AccountDetailsScreen extends GetView<AuthController> {
  const AccountDetailsScreen({super.key});

  static const String routeName = '/account';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(bottom: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
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