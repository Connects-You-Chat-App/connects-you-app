import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:realm/realm.dart';

import '../../../constants/message.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/room_controller.dart';
import '../../../models/objects/room_with_room_users_and_messages.dart';
import '../../common/screen_container.dart';
import 'app_bar.dart';
import 'chat_bubble.dart';
import 'input_box.dart';
import 'message_bubble_config.dart';

class RoomScreen extends GetView<AuthController> {
  RoomScreen({super.key}) {
    _roomController = Get.put(RoomController());
  }

  static const String routeName = '/room';

  late final RoomController _roomController;
  final Set<String> _roomUserIds = <String>{};

  void _filterUnreadMessages(final List<MessageBubbleConfig> messages) {
    if (messages.isEmpty) {
      return;
    }

    final List<String> unreadMessages = [];
    for (final MessageBubbleConfig element in messages) {
      if (!element.isMine) {
        if (element.message.status != MessageStatus.READ_BY_ME) {
          unreadMessages.add(element.message.id);
        } else {
          break;
        }
      }
    }

    if (unreadMessages.isNotEmpty) {
      _roomController.markMessagesAsRead(unreadMessages);
    }
  }

  MessageBubbleConfig getMessageConfig(
      final List<MessageModel> messages, final int index) {
    final MessageModel message = messages[index];
    final bool isMine =
        controller.authenticatedUser?.id == message.senderUser?.id;

    final bool isDelivered = message.messageStatuses.length ==
        _roomController.room.roomUsers.length - 1;

    if (_roomUserIds.isEmpty) {
      _roomUserIds.addAll(
        _roomController.room.roomUsers.map((final UserModel user) => user.id),
      );
    }

    final bool isRead = isDelivered &&
        message.messageStatuses.every(
          (final MessageStatusModel status) =>
              status.isRead && _roomUserIds.contains(status.userId),
        );

    final bool isGroupLast = index == 0 ||
        messages[index - 1].senderUser?.id != message.senderUser?.id;
    final bool isGroupFirst = index == messages.length - 1 ||
        messages[index + 1].senderUser?.id != message.senderUser?.id;

    final bool isDaysFirst = index == messages.length - 1 ||
        messages[index + 1].createdAt.day != message.createdAt.day;

    return MessageBubbleConfig(
      isMine: isMine,
      message: message,
      isDelivered: isDelivered,
      isRead: isRead,
      isGroupFirst: isGroupFirst,
      isGroupLast: isGroupLast,
      isDaysFirst: isDaysFirst,
    );
  }

  @override
  Widget build(final BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ScreenContainer(
      child: Scaffold(
        appBar: AppBar(title: const RoomAppBar()),
        backgroundColor: theme.colorScheme.background,
        body: Column(
          children: <Widget>[
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: ColoredBox(
                  color: theme.colorScheme.secondaryContainer,
                  child: StreamBuilder<RealmResultsChanges<MessageModel>>(
                    stream: _roomController.messagesStream,
                    builder: (
                      final BuildContext context,
                      final AsyncSnapshot<RealmResultsChanges<MessageModel>>
                          snapshot,
                    ) {
                      if (snapshot.hasData) {
                        final List<MessageModel> messages =
                            snapshot.data!.results.toList();

                        int i = 0;
                        final List<MessageBubbleConfig> messageConfigs =
                            messages
                                .map(
                                  (final MessageModel message) =>
                                      getMessageConfig(messages, i++),
                                )
                                .toList();
                        _filterUnreadMessages(messageConfigs);

                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          reverse: true,
                          itemCount: messages.length,
                          controller: _roomController.scrollController,
                          keyboardDismissBehavior:
                              ScrollViewKeyboardDismissBehavior.onDrag,
                          itemBuilder: (
                            final BuildContext context,
                            final int index,
                          ) {
                            return ChatBubble(
                                messageConfig: messageConfigs[index]);
                          },
                        );
                      }
                      return const SizedBox();
                    },
                  ),
                ),
              ),
            ),
            ColoredBox(
              color: theme.colorScheme.secondaryContainer,
              child: InputBox(),
            )
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
