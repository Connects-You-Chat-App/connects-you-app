import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/secure_storage_keys.dart';
import '../services/database/main.dart';

class SettingController extends GetxController {
  Future<void> _initSettings() async {
    try {
      final String? value = RealmService.secureStorageModelService
          .getValue()?[SecureStorageKeys.THEME];
      if (value == null || value.isEmpty) {
        Get.changeThemeMode(ThemeMode.system);
      } else {
        Get.changeThemeMode(value == ThemeMode.dark.name
            ? ThemeMode.dark
            : value == ThemeMode.light.name
                ? ThemeMode.light
                : ThemeMode.system);
      }
    } catch (_) {
      Get.changeThemeMode(ThemeMode.system);
    }
  }

  @override
  onInit() {
    super.onInit();
    _initSettings();
  }
}