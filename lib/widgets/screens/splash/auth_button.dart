// import 'package:connects_you/widgets/main/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

import '../../../constants/widget.dart';
import '../../../controllers/auth_controller.dart';

class AuthButton extends GetWidget<AuthController> {
  const AuthButton({super.key});

  Future _onAuthButtonClick(final BuildContext context) async {
    try {
      return await controller.authenticate();
    } catch (error) {
      debugPrint('authenticationError $error');
    }
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: WidgetConstants.spacing_xxxl),
      child: Obx(
        () => Column(
          children: <Widget>[
            InkWell(
              highlightColor: Colors.black54,
              borderRadius: BorderRadius.circular(WidgetConstants.spacing_xxl),
              onTap: controller.authState == AuthStates.inProgress
                  ? null
                  : () => _onAuthButtonClick(context),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: WidgetConstants.spacing_sm),
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    if (controller.authState == AuthStates.inProgress)
                      CupertinoActivityIndicator(
                        color: theme.primaryColor,
                        radius: 20,
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          SvgPicture.asset(
                            'assets/svgs/google.svg',
                            height: 30,
                            width: 30,
                          ),
                          const SizedBox(
                            width: WidgetConstants.spacing_xxxl,
                          ),
                          Text(
                            'Login with Google',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.titleLarge,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: WidgetConstants.spacing_xxxl),
              child: Text(
                controller.authStateMessage ?? '',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.primaryColor.withOpacity(0.5),
                  height: 1.5,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}