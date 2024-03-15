import 'package:flutter/material.dart' hide Notification;
import 'package:get/get.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;

import '../constants/message.dart';
import '../constants/socket_events.dart';
import '../constants/url.dart';
import '../models/base/notification.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import 'auth_controller.dart';
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
          RoomWithRoomUsersAndMessagesModel.fromJson(
              data as Map<String, dynamic>));
    });
    socket.on(SocketEvents.GROUP_INVITATION, (final dynamic data) {
      Get.find<NotificationsController>()
          .addNotification(Notification.fromJson(data as Map<String, dynamic>));
    });
    socket.on(SocketEvents.GROUP_JOINED, (final dynamic data) {
      Get.find<RoomsController>().addUserToRoom(
          (data as Map<String, String>)['roomId']!,
          UserModel.fromJson(
              (data as Map<String, Map<String, dynamic>>)['user']!));
    });
    socket.on(SocketEvents.ROOM_MESSAGE, (final dynamic data) async {
      final MessageModel message =
          MessageModel.fromJson(data as Map<String, dynamic>);
      print('ROOM_MESSAGE $data');
      if (Get.find<AuthController>().authenticatedUser?.id ==
          message.senderUser?.id) {
        await Get.find<RoomsController>().updateMessageStatus(
          message.roomId,
          message.id,
          MessageStatus.SENT,
        );
      } else {
        await Get.find<RoomsController>().addMessageToRoom(message);
      }
    });

    // TODO: add user list for status (like delivered to whom, and read by whom)
    socket.on(SocketEvents.ROOM_MESSAGE_DELIVERED, (final dynamic data) {
      // TODO: Implement message delivered
      print('ROOM_MESSAGE_DELIVERED $data');
      // Get.find<RoomsController>().updateMessageStatus(
      // Get.find<RoomController>().addMessageToRoom(
      //     data['roomId'], Message.fromJson(data['message']));
    });

    socket.on(SocketEvents.ROOM_MESSAGE_READ, (final dynamic data) async {
      final String userId = data['userId'] as String;
      final String roomId = data['roomId'] as String;
      final List<String> messageIds =
          (data['messageIds'] as List<dynamic>).cast<String>();
      print('ROOM_MESSAGE_READ $data');
      await Get.find<RoomsController>()
          .updateMessageStatuses(messageIds, MessageStatus.READ);
      // Get.find<RoomController>().addMessageToRoom(
      //     data['roomId'], Message.fromJson(data['message']));
    });
  }
}