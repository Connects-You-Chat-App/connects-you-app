import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/message.dart';
import '../../../controllers/room_controller.dart';

class InputBox extends GetView<RoomController> {
  const InputBox({super.key});

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.only(top: 12, left: 24, right: 24, bottom: 12),
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      child: TextField(
        maxLines: 5,
        minLines: 1,
        style: TextStyle(
          // color: Colors.white,
          backgroundColor: theme.colorScheme.background,
        ),
        controller: controller.messageController,
        decoration: InputDecoration(
            fillColor: theme.colorScheme.background,
            hintText: 'Type a message...',
            border: InputBorder.none,
            alignLabelWithHint: true,
            suffixIcon: IconButton(
              alignment: Alignment.center,
              icon: const Icon(Icons.send),
              onPressed: () => controller.sendMessage(
                message: controller.messageController.text,
                type: MessageType.TEXT,
              ),
            )),
      ),
      // IconButton(
      //   icon: const Icon(Icons.send),
      //   onPressed: () => controller.sendMessage(
      //     message: controller.messageController.text,
      //     type: MessageType.TEXT,
      //   ),
      // ),
    );
  }
}
