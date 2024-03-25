import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../controllers/socket_controller.dart';
import '../../utils/common.dart';

class ScreenContainer extends GetView<SocketController> {
  const ScreenContainer({
    required this.child,
    this.statusBarColor,
    this.navigationBarColor,
    this.statusBarBrightness,
    this.statusBarIconBrightness,
    this.navigationBarIconBrightness,
    this.showSocketConnection = true,
    super.key,
  });

  final Widget child;
  final Color? statusBarColor;
  final Color? navigationBarColor;
  final Brightness? statusBarBrightness;
  final Brightness? statusBarIconBrightness;
  final Brightness? navigationBarIconBrightness;
  final bool showSocketConnection;

  Widget _socketConnectionWidget(final ThemeData theme) {
    return Obx(
      () {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          height:
              controller.socketState.value == SocketConnectionState.connected
                  ? 0
                  : 40,
          color: <SocketConnectionState>[
            SocketConnectionState.connecting,
            SocketConnectionState.connected
          ].contains(controller.socketState.value)
              ? theme.colorScheme.primary
              : theme.colorScheme.error,
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  toCapitalCase(controller.socketState.value.name),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    decoration: TextDecoration.none,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    if (Platform.isAndroid) {
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
        value: overLayStyle,
        child: SafeArea(
          child: Column(children: <Widget>[
            if (showSocketConnection) _socketConnectionWidget(theme),
            Expanded(child: child)
          ]),
        ),
      );
    } else {
      return Column(children: <Widget>[
        if (showSocketConnection) _socketConnectionWidget(theme),
        Expanded(child: child)
      ]);
    }
  }
}
