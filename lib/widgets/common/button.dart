import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class AppButton extends StatelessWidget {

  const AppButton({
    super.key,
    this.text,
    this.onPressed,
    this.icon,
    this.width,
    this.height,
    this.fontSize,
    this.radius,
    this.shouldApplyThemeBackground = false,
    this.isLoading = false,
    this.showBorder = true,
    this.backgroundColor,
  });
  final String? text;
  final void Function()? onPressed;
  final Widget? icon;
  final double? width;
  final double? height;
  final double? fontSize;
  final double? radius;
  final bool shouldApplyThemeBackground;
  final bool isLoading;
  final bool showBorder;
  final Color? backgroundColor;

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: width ?? double.infinity,
      height: height ?? 50.0,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius ?? 10.0),
        color: backgroundColor ??
            (shouldApplyThemeBackground ? theme.colorScheme.background : null),
        gradient: shouldApplyThemeBackground
            ? null
            : const LinearGradient(
                colors: AppTheme.gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
        border: shouldApplyThemeBackground && showBorder
            ? Border.all(
                color: theme.primaryColor,
                width: 2.0,
              )
            : null,
        boxShadow: showBorder
            ? <BoxShadow>[
                BoxShadow(
                  color: theme.shadowColor,
                  blurRadius: 10.0,
                  offset: const Offset(0.0, 2.5),
                ),
              ]
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: <Widget>[
          ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(radius ?? 10.0),
              ),
              elevation: 0.0,
            ),
            child: Row(
              children: <Widget>[
                if (icon != null) icon! else const SizedBox(),
                if (icon != null) text != null
                        ? const SizedBox(width: 10.0)
                        : const SizedBox() else const SizedBox(),
                if (!isLoading && text != null)
                  Expanded(
                    child: Text(
                      text!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: shouldApplyThemeBackground
                            ? theme.primaryColor
                            : Colors.white,
                        fontSize: fontSize ?? 16.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          if (isLoading)
            Center(
              child: CupertinoActivityIndicator(
                radius: 15.0,
                color: shouldApplyThemeBackground
                    ? theme.primaryColor
                    : Colors.white,
              ),
            )
        ],
      ),
    );
  }
}