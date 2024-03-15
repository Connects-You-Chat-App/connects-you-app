import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constants/message.dart';
import '../../../controllers/room_controller.dart';
import '../../common/screen_container.dart';

class RoomScreen extends StatelessWidget {
  RoomScreen({super.key}) {
    _roomController = Get.put(RoomController());
  }

  static const String routeName = '/room';

  late final RoomController _roomController;

  @override
  Widget build(final BuildContext context) {
    return ScreenContainer(
      child: Scaffold(
        appBar: AppBar(
          title: Text(_roomController.room.name),
        ),
        body: Stack(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: <Widget>[
                  // Expanded(
                  //   child: Obx(
                  //     () => ListView.builder(
                  //       itemCount: _roomController.messages.length,
                  //       itemBuilder:
                  //           (final BuildContext context, final int index) {
                  //         final Message message =
                  //             _roomController.messages[index];
                  //         return ListTile(
                  //           title: Text(message.message),
                  //           subtitle: Text(message.senderUser.name),
                  //         );
                  //       },
                  //     ),
                  //   ),
                  // ),
                  const SizedBox(height: 12),
                  TextField(
                    maxLines: 5,
                    minLines: 1,
                    autofocus: true,
                    controller: _roomController.messageController,
                    decoration: InputDecoration(
                      hintText: 'Type a message',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.send),
                        onPressed: () => _roomController.sendMessage(
                          message: _roomController.messageController.text,
                          type: MessageType.TEXT,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/**
 * create a room_controller where adding, updating of rooms functionality will be there
 * on any operation, update the hive controller and state atomically
 * (Drop existing hive controller and create a new one)
 */

/**
 * on message send
 * 1. save raw message to hive (in pending state)
 * 1.1. add message to room message map (Map<RoomId, List<Message>>)
 * 2. send message to server
 * 3. on receiving of same message ->> mark message as sent ->> update message in hive
 * 4. on receiving message as received by other user ->> mark message as delivered ->> update message in hive
 * 5. on receiving message as seen by other user ->> mark message as seen ->> update message in hive
 */

/**
 * on message receive
 * 1. decrypt the message
 * 2. save message to hive
 * 2.1. add message to room message map (Map<RoomId, List<Message>>)
 * 3. emit event that message is delivered
 * 4. if message is seen then emit event that message is seen
 */

/**
 * on app start
 * 1. fetch remaining messages from server
 * 2. decrypt the message
 * 3. save message to hive
 * 3.1. add message to room message map (Map<RoomId, List<Message>>)
 * 4. emit event that message is delivered
 * 5. if message is seen then emit event that message is seen
 */