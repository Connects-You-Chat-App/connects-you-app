import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/users_controller.dart';
import '../../../models/base/user.dart';
import 'user_row.dart';

class UsersScreen extends GetView<UsersController> {
  const UsersScreen({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final MediaQueryData mediaQuery = MediaQuery.of(context);
    return PopScope(
      onPopInvoked: (final _) {
        controller.clearSelectedUsers();
      },
      child: Stack(
        alignment: Alignment.center,
        fit: StackFit.expand,
        children: <Widget>[
          Obx(
            () => Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: controller.selectedUsers.isNotEmpty
                    ? Text(controller.selectedUsers.length.toString())
                    : controller.showSearchBox
                        ? TextField(
                            controller: controller.searchController,
                            autofocus: true,
                            decoration: InputDecoration(
                              icon: IconButton(
                                  icon: Icon(Icons.search_rounded,
                                      color: theme.primaryColor, size: 32),
                                  onPressed: () {}),
                            ),
                          )
                        : const Text(
                            'Users',
                          ),
                actions: <Widget>[
                  if (!controller.showSearchBox && controller.selectedUsers.isEmpty) IconButton(
                          icon: Icon(
                            Icons.search_rounded,
                            color: theme.primaryColor,
                            size: 32,
                          ),
                          onPressed: () => controller.showSearchBox = true) else const SizedBox.shrink(),
                  if (controller.selectedUsers.length > 1) IconButton(
                          icon: Icon(
                            Icons.group_add_rounded,
                            color: theme.primaryColor,
                            size: 32,
                          ),
                          onPressed: controller.createGroup,
                        ) else const SizedBox.shrink(),
                  if (controller.selectedUsers.isNotEmpty ||
                          controller.showSearchBox) IconButton(
                          icon: Icon(
                            Icons.close_rounded,
                            color: theme.primaryColor,
                            size: 32,
                          ),
                          onPressed: () {
                            controller.selectedUsers.clear();
                            controller.showSearchBox = false;
                          },
                        ) else const SizedBox.shrink(),
                ],
              ),
              body: RefreshIndicator(
                onRefresh: controller.fetchAllUsers,
                triggerMode: RefreshIndicatorTriggerMode.anywhere,
                child: controller.users.isEmpty
                    ? SingleChildScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        child: Image.asset(
                          'assets/gifs/empty.gif',
                          height: mediaQuery.size.height * 0.75,
                        ),
                      )
                    : ListView.separated(
                        padding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 16),
                        itemCount: controller.users.length,
                        separatorBuilder: (final _, final __) => const SizedBox(height: 8),
                        itemBuilder: (final _, final int index) {
                          final User user = controller.users[index];
                          final bool isSelected =
                              controller.selectedUsers.containsKey(user.id);
                          return UserRow(
                            user: user,
                            onLongPress: () => controller.onLongPress(index),
                            onTap: () => controller.onTap(index),
                            isSelected: isSelected,
                          );
                        },
                      ),
              ),
            ),
          ),
          if (controller.isCreatingRoom) SizedBox(
                  height: mediaQuery.size.height,
                  width: mediaQuery.size.width,
                  child: CupertinoActivityIndicator(
                    color: Get.theme.primaryColor,
                    radius: 32,
                  ),
                ) else const SizedBox.shrink(),
        ],
      ),
    );
  }
}