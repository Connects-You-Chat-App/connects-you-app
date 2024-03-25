import 'package:flutter/cupertino.dart';

import '../../../constants/message.dart';
import '../../../models/objects/room_with_room_users_and_messages.dart';

class MessageBubbleConfig {
  MessageBubbleConfig({
    required this.isMine,
    required this.message,
    required this.isRead,
    required this.isDelivered,
    required this.isGroupFirst,
    required this.isGroupLast,
    required this.isDaysFirst,
  });

  bool isMine;
  bool isRead;
  bool isDelivered;
  bool isGroupFirst;
  bool isGroupLast;
  bool isDaysFirst;
  MessageModel message;

  Alignment get messageAlignment =>
      isMine ? Alignment.centerRight : Alignment.centerLeft;

  bool get isSent => message.status == MessageStatus.SENT;

  bool get isPending => message.status == MessageStatus.PENDING;
}
