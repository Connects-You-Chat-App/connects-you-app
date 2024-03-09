import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../constants/hive_secure_storage_keys.dart';
import '../utils/secure_storage.dart';

class SettingController extends GetxController {
  Future<void> _initSettings() async {
    try {
      final value = await SecureStorage.read(key: HiveSecureStorageKeys.THEME);
      if (value == null || value as String == '') {
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