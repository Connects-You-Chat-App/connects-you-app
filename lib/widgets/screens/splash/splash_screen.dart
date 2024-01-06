import 'dart:async';

import 'package:connects_you/constants/locale.dart';
import 'package:connects_you/constants/widget.dart';
import 'package:connects_you/controllers/auth_controller.dart';
import 'package:connects_you/widgets/common/screeen_container.dart';
import 'package:connects_you/widgets/screens/splash/auth_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/';

  const SplashScreen({super.key});

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
    _authStateSubscription = _authController.authStateSubscription((event) {
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
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return ScreenContainer(
      child: Scaffold(
        backgroundColor: theme.colorScheme.background,
        body: Container(
          height: double.infinity,
          alignment: Alignment.center,
          padding: const EdgeInsets.only(
            top: WidgetConstants.spacing_xxxl * 5,
          ),
          child: Column(
            children: [
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
                builder: (context, child) => Transform.translate(
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