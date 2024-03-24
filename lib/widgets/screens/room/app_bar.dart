import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/room_controller.dart';
import '../../../enums/room.dart';
import '../../../models/objects/room_with_room_users_and_messages.dart';
import '../../common/typing_indicator.dart';

class RoomAppBar extends GetView<RoomController> {
  const RoomAppBar({super.key});

  String get _title {
    if (controller.typingUsers.isNotEmpty) {
      if (controller.room.type == RoomType.DUET.name) {
        return 'typing';
      } else {
        final String title = controller.typingUsers
            .map((final UserModel e) => e.name)
            .join(', ');
        return '$title are typing';
      }
    }
    return '';
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Obx(
      () => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn,
            style: theme.textTheme.titleLarge!.copyWith(
              fontSize: controller.typingUsers.isNotEmpty ? 16 : 24,
            ),
            child: Text(controller.room.name),
          ),
          if (controller.typingUsers.isNotEmpty)
            Row(
              children: <Widget>[
                Text(
                  _title,
                  style: theme.textTheme.subtitle2,
                ),
                const SizedBox(width: 8),
                JumpingDots(
                  color: theme.colorScheme.secondary,
                  radius: 3,
                  verticalOffset: 5,
                )
              ],
            ),
          // Text(
          //   '${controller.typingUser!.name} is typing...',
          //   style: theme.textTheme.subtitle2,
          // ),
        ],
      ),
    );
  }
}
