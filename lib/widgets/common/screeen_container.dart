import 'dart:io';

import 'package:connects_you/controllers/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class ScreenContainer extends GetView<SettingController> {
  final Widget child;
  final Color? statusBarColor;
  final Color? navigationBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
  final Brightness? navigationBarIconBrightness;

  const ScreenContainer({
    required this.child,
    this.statusBarColor,
    this.navigationBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.navigationBarIconBrightness,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    if (Platform.isAndroid) {
      final theme = Theme.of(context);
      final oppositeBrightness = theme.brightness == Brightness.light
          ? Brightness.dark
          : Brightness.light;
      final SystemUiOverlayStyle overLayStyle = SystemUiOverlayStyle(
        statusBarColor: statusBarColor ?? theme.colorScheme.background,
        systemNavigationBarColor:
            navigationBarColor ?? theme.colorScheme.background,
        statusBarBrightness: oppositeBrightness,
        statusBarIconBrightness: oppositeBrightness,
        systemNavigationBarIconBrightness: oppositeBrightness,
        systemNavigationBarDividerColor:
            navigationBarColor ?? theme.colorScheme.background,
      );

      return AnnotatedRegion<SystemUiOverlayStyle>(
          value: overLayStyle, child: child);
    } else {
      return child;
    }
  }
}