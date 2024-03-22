import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/home_controller.dart';
import '../../common/screen_container.dart';

final List<List<Object>> icons = <List<Object>>[
  <Object>[0, Icons.chat_rounded],
  <Object>[1, Icons.notifications_active_rounded],
  <Object>[2, Icons.person_rounded]
];

class Drawer extends GetView<HomeController> {
  const Drawer({super.key});

  Icon getIcon(final MediaQueryData mediaQuery, final int index,
      final int currentIndex) {
    return Icon(
      icons[index][1] as IconData,
      color: icons[index][0] == currentIndex
          ? Get.theme.primaryColor
          : Colors.grey,
      size: mediaQuery.size.width * 0.08,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return ScreenContainer(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: mediaQuery.size.height * 0.4,
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(5),
                child: Image.asset(
                  'assets/images/logo.png',
                  scale: 10,
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: <Widget>[
                Flexible(
                  child: Obx(
                    () => ListView(
                      physics: const BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: <Widget>[
                        DrawerCard(
                          child: ListTile(
                            leading:
                                getIcon(mediaQuery, 0, controller.currentIndex),
                            title: const Text('Inbox'),
                            onTap: () {
                              controller.changeIndex(0);
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading:
                                getIcon(mediaQuery, 1, controller.currentIndex),
                            title: const Text(
                              'Notifications',
                            ),
                            onTap: () {
                              controller.changeIndex(1);
                            },
                          ),
                        ),
                        DrawerCard(
                          child: ListTile(
                            leading:
                                getIcon(mediaQuery, 2, controller.currentIndex),
                            title: const Text(
                              'Account',
                            ),
                            onTap: () {
                              controller.changeIndex(2);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerCard extends StatelessWidget {
  const DrawerCard({required this.child, super.key});

  final Widget? child;

  @override
  Widget build(final BuildContext context) {
    return child ?? const SizedBox();
  }
}
