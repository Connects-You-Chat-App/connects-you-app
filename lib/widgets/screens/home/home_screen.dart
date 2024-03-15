import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/widget.dart';
import '../../../controllers/home_controller.dart';
import '../../../theme/app_theme.dart';
import '../../common/screen_container.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key}) {
    _homeController = Get.put(HomeController());
  }

  static const String routeName = '/home';

  late final HomeController _homeController;

  List<Icon> getIcons(final MediaQueryData mediaQuery, final int currentIndex) {
    final List<List<Object>> icons = <List<Object>>[
      <Object>[0, Icons.chat_rounded],
      <Object>[1, Icons.notifications_active_rounded],
      <Object>[2, Icons.person_rounded]
    ];
    return icons.map((final List<Object> icon) {
      return Icon(icon[1] as IconData,
          color: icon[0] == currentIndex ? Colors.white : Colors.grey,
          size: mediaQuery.size.width * 0.08);
    }).toList(growable: true);
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return ScreenContainer(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.colorScheme.background,
          body: Stack(
            children: <Widget>[
              PageView.builder(
                controller: _homeController.controller,
                itemCount: _homeController.screens.length,
                onPageChanged: _homeController.onCurrentIndexChanged,
                itemBuilder: (final BuildContext context, final int index) {
                  return _homeController.screens[index];
                },
              ),
              Obx(
                () {
                  final List<Icon> icons =
                      getIcons(mediaQuery, _homeController.currentIndex);
                  return AnimatedPositioned(
                    duration: const Duration(milliseconds: 200),
                    bottom:
                        _homeController.hideNavBarAndFloatingButton ? -100 : 0,
                    right: 0,
                    left: 0,
                    child: CircleNavBar(
                      activeIndex: _homeController.currentIndex,
                      color: theme.cardColor,
                      onTap: (final int index) {
                        _homeController.changeIndex(index);
                      },
                      activeIcons: icons,
                      inactiveIcons: icons,
                      circleWidth: mediaQuery.size.width * 0.15,
                      height: mediaQuery.size.height * 0.075,
                      circleGradient: const LinearGradient(
                        colors: <Color>[
                          Color.fromRGBO(0, 100, 255, 2),
                          Color.fromRGBO(0, 100, 255, 2),
                        ],
                      ),
                      gradient:
                          const LinearGradient(colors: AppTheme.gradientColors),
                      shadowColor: theme.shadowColor,
                      padding: const EdgeInsets.all(WidgetConstants.spacing_xs),
                      elevation: 5,
                      cornerRadius: const BorderRadius.only(
                        topLeft: Radius.circular(WidgetConstants.spacing_xl),
                        topRight: Radius.circular(WidgetConstants.spacing_xl),
                        bottomRight:
                            Radius.circular(WidgetConstants.spacing_xxxl),
                        bottomLeft:
                            Radius.circular(WidgetConstants.spacing_xxxl),
                      ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}