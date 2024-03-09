import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/settings_controller.dart';

class ScreenContainer extends GetView<SettingController> {

  const ScreenContainer({
    required this.child,
    this.statusBarColor,
    this.navigationBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.navigationBarIconBrightness,
    super.key,
  });
  final Widget child;
  final Color? statusBarColor;
  final Color? navigationBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
  final Brightness? navigationBarIconBrightness;

  @override
  Widget build(final BuildContext context) {
    if (Platform.isAndroid) {
      final ThemeData theme = Theme.of(context);
      final Brightness oppositeBrightness = theme.brightness == Brightness.light
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