import 'package:connects_you/constants/widget.dart';
import 'package:connects_you/controllers/auth_controller.dart';
// import 'package:connects_you/widgets/main/splash_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class AuthButton extends GetWidget<AuthController> {
  const AuthButton({super.key});

  Future _onAuthButtonClick(BuildContext context) async {
    try {
      return await controller.authenticate();
    } catch (error) {
      debugPrint('authenticationError $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: WidgetConstants.spacing_xxxl),
      child: Obx(
        () => Column(
          children: [
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
                  children: [
                    if (controller.authState == AuthStates.inProgress)
                      CupertinoActivityIndicator(
                        color: theme.primaryColor,
                        radius: 20,
                      )
                    else
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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