import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/locale.dart';
import '../../../constants/widget.dart';
import '../../../controllers/auth_controller.dart';
import '../../common/screen_container.dart';
import 'auth_button.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;

  late final Animation<Offset> _animation;
  late final AuthController _authController;

  late final StreamSubscription<AuthStates> _authStateSubscription;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation =
        Tween<Offset>(begin: const Offset(0, 500), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
    _authController = Get.find<AuthController>();
    _authStateSubscription =
        _authController.authStateSubscription((final AuthStates event) {
      if (event == AuthStates.completed) {
        if (!_authController.isAuthenticated) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _authStateSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return ScreenContainer(
      showSocketConnection: false,
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Container(
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: WidgetConstants.spacing_xxxl * 5,
          ),
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/images/logo.png',
                width: mediaQuery.size.width * 0.8,
                height: mediaQuery.size.width * 0.8,
              ),
              Text(
                Locale.appName,
                style: theme.textTheme.titleLarge!.copyWith(fontSize: 32),
              ),
              AnimatedBuilder(
                animation: _animationController,
                builder: (final BuildContext context, final Widget? child) =>
                    Transform.translate(
                  offset: Offset(
                    0,
                    _animation.value.dy,
                  ),
                  child: child,
                ),
                child: const AuthButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
