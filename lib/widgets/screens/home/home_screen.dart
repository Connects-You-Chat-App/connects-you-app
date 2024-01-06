import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:connects_you/constants/widget.dart';
import 'package:connects_you/controllers/home_controller.dart';
import 'package:connects_you/theme/app_theme.dart';
import 'package:connects_you/widgets/common/screeen_container.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeScreen extends StatelessWidget {
  final _homeController = Get.put(HomeController());
  static const String routeName = '/home';

  HomeScreen({super.key});

  List<Icon> getIcons(MediaQueryData mediaQuery, int currentIndex) {
    final icons = [
      [0, Icons.chat_rounded],
      [1, Icons.notifications_active_rounded],
      [2, Icons.person_rounded]
    ];
    return icons.map((icon) {
      return Icon(icon[1] as IconData,
          color: icon[0] == currentIndex ? Colors.white : Colors.grey,
          size: mediaQuery.size.width * 0.08);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final mediaQuery = MediaQuery.of(context);
    return ScreenContainer(
      child: SafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: theme.colorScheme.background,
          body: Stack(
            children: [
              PageView.builder(
                controller: _homeController.controller,
                itemCount: _homeController.screens.length,
                onPageChanged: _homeController.onCurrentIndexChanged,
                itemBuilder: (context, index) {
                  return _homeController.screens[index];
                },
              ),
              Obx(
                () {
                  final icons =
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
                      onTap: (index) {
                        _homeController.changeIndex(index);
                      },
                      activeIcons: icons,
                      inactiveIcons: icons,
                      circleWidth: mediaQuery.size.width * 0.15,
                      height: mediaQuery.size.height * 0.075,
                      circleGradient: const LinearGradient(
                        colors: [
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