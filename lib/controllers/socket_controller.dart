import 'package:connects_you/constants/socket_events.dart';
import 'package:connects_you/constants/url.dart';
import 'package:connects_you/controllers/inbox_controller.dart';
import 'package:connects_you/controllers/notifications_controller.dart';
import 'package:connects_you/models/base/notification.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/common/rooms_with_room_users.dart';
import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

enum SocketConnectionState { connected, connecting, disconnected }

class SocketController extends GetxController {
  late IO.Socket socket;
  Rx<SocketConnectionState> socketState =
      Rx(SocketConnectionState.disconnected);

  initializeSocket(String token) {
    socket = IO.io(
        URLs.socketBaseURL,
        IO.OptionBuilder()
            .setExtraHeaders({
              'Authorization': token,
            })
            .enableReconnection()
            .setReconnectionAttempts(10)
            .setReconnectionDelay(2000)
            .setReconnectionDelayMax(10000)
            .setTransports(['websocket'])
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

  _addListeners(String token) {
    socket.onConnecting((_) {
      debugPrint('Connecting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onConnect((_) {
      debugPrint('Connected');
      socketState.value = SocketConnectionState.connected;
    });
    socket.onConnectTimeout((_) {
      debugPrint('ConnectTimeout');
      socketState.value = SocketConnectionState.disconnected;
    });
    socket.onConnectError((_) {
      debugPrint('ConnectError');
    });
    socket.onReconnectAttempt((_) {
      debugPrint('ReConnecting Attempting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onReconnecting((_) {
      debugPrint('ReConnecting');
      socketState.value = SocketConnectionState.connecting;
    });
    socket.onReconnect((_) {
      debugPrint('ReConnected');
      socketState.value = SocketConnectionState.connected;
    });
    socket.onReconnectError((_) {
      debugPrint('ReConnectError');
    });
    socket.onReconnectFailed((_) {
      debugPrint('ReConnectFailed');
      socketState.value = SocketConnectionState.disconnected;
    });
    socket.onDisconnect((_) async {
      debugPrint('disconnected');
      socketState.value = SocketConnectionState.disconnected;
    });

    socket.on(
        SocketEvents.USER_PRESENCE, (data) => {debugPrint(data.toString())});
    socket.on(SocketEvents.DUET_ROOM_CREATED, (data) {
      Get.find<InboxController>()
          .addNewlyCreatedDuetRoom(RoomWithRoomUsers.fromJson(data));
    });
    socket.on(SocketEvents.GROUP_INVITATION, (data) {
      Get.find<NotificationsController>()
          .addNotification(Notification.fromJson(data));
    });
    socket.on(SocketEvents.GROUP_JOINED, (data) {
      Get.find<InboxController>()
          .addUserToRoom(data['roomId'], User.fromJson(data['user']));
    });
  }
}