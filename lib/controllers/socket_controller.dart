import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/socket_events.dart';
import '../constants/url.dart';
import '../models/base/message.dart';
import '../models/base/notification.dart';
import '../models/base/user.dart';
import '../models/common/rooms_with_room_users.dart';
import 'notifications_controller.dart';
import 'rooms_controller.dart';

enum SocketConnectionState { connected, connecting, disconnected }

class SocketController extends GetxController {
  late IO.Socket socket;
  Rx<SocketConnectionState> socketState =
      SocketConnectionState.disconnected.obs;

  void initializeSocket(final String token) {
    socket = IO.io(
        URLs.socketBaseURL,
        IO.OptionBuilder()
            .setExtraHeaders(<String, String>{
              'Authorization': token,
            })
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .setReconnectionDelayMax(10000)
            .setTransports(<String>['websocket'])
            .disableAutoConnect()
            .build());
    _addListeners(token);
    socket.connect();
  }

  @override
  void onClose() {
    socket.clearListeners();
    socket.destroy();
    super.onClose();
  }

  void _addListeners(final String token) {
    socket.onConnecting((final _) {
      debugPrint('Connecting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onConnect((final _) {
      debugPrint('Connected');
      socketState.value = SocketConnectionState.connected;
    });
    socket.onConnectTimeout((final _) {
      debugPrint('ConnectTimeout');
      socketState.value = SocketConnectionState.disconnected;
    });
    socket.onConnectError((final _) {
      debugPrint('ConnectError');
    });
    socket.onReconnectAttempt((final _) {
      debugPrint('ReConnecting Attempting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onReconnecting((final _) {
      debugPrint('ReConnecting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onReconnect((final _) {
      debugPrint('ReConnected');
      socketState.value = SocketConnectionState.connected;
    });
    socket.onReconnectError((final _) {
      debugPrint('ReConnectError');
    });
    socket.onReconnectFailed((final _) {
      debugPrint('ReConnectFailed');
      socketState.value = SocketConnectionState.disconnected;
    });
    socket.onDisconnect((final _) async {
      debugPrint('disconnected');
      socketState.value = SocketConnectionState.disconnected;
    });

    socket.on(SocketEvents.USER_PRESENCE,
        (final dynamic data) => <void>{debugPrint(data.toString())});
    socket.on(SocketEvents.DUET_ROOM_CREATED, (final dynamic data) {
      Get.find<RoomsController>().addNewlyCreatedDuetRoom(
          RoomWithRoomUsers.fromJson(data as Map<String, dynamic>));
    });
    socket.on(SocketEvents.GROUP_INVITATION, (final dynamic data) {
      Get.find<NotificationsController>()
          .addNotification(Notification.fromJson(data as Map<String, dynamic>));
    });
    socket.on(SocketEvents.GROUP_JOINED, (final dynamic data) {
      Get.find<RoomsController>().addUserToRoom(
          (data as Map<String, String>)['roomId']!,
          User.fromJson((data as Map<String, Map<String, dynamic>>)['user']!));
    });
    socket.on(SocketEvents.ROOM_MESSAGE, (final dynamic data) {
      final Message message = Message.fromJson(data as Map<String, dynamic>);
      print('ROOM_MESSAGE $data');
      /**
       * if message sent by me then update the status of message to sent
       * else add message to room and emit that message is delivered (as this is a message from other user and received by me)
       */
      // Get.find<RoomController>().addMessageToRoom(
      //     data['roomId'], Message.fromJson(data['message']),);
      // Get.find<InboxController>()
      //     .addUserToRoom(data['roomId'], User.fromJson(data['user']));
    });
  }
}