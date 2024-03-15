import 'dart:developer';

import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:get/get.dart' hide Response;

import '../models/base/notification.dart';
import '../models/requests/join_group_request.dart';
import '../models/responses/main.dart';
import '../services/database/current_user_service.dart';
import '../services/database/shared_key_service.dart';
import '../services/http/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/home/screens/inbox/inbox_screen.dart';
import 'home_controller.dart';
import 'rooms_controller.dart';

class NotificationsController extends GetxController {
  final RxList<Notification> _notifications = <Notification>[].obs;

  RxList<Notification> get notifications => _notifications;

  Future<void> fetchNotifications() async {
    final Response<List<Notification>> response =
        await ServerApi.notificationService.getNotifications();
    _notifications.value = response.response;
  }

  void addNotification(final Notification notification) {
    _notifications.add(notification);
  }

  Future<void> joinGroup(final int index) async {
    final Notification notification = _notifications[index];
    String? sharedKeyWithSender = SharedKeyModelService()
        .getSharedKeyForUser(notification.senderUser.id)
        ?.key;
    if (sharedKeyWithSender == null) {
      final List<UserWiseSharedKeyResponse> value =
          await getSharedKeyWithOtherUsers([notification.senderUser],
              force: true);
      if (value.isEmpty) {
        log('Shared key is empty');
        return;
      }
      sharedKeyWithSender = value.first.sharedKey;
    }
    final String roomSecretKey =
        await AesGcmEncryption(secretKey: sharedKeyWithSender)
            .decryptString(notification.encryptedRoomSecretKey);
    final String userKey = CurrentUserModelService().getCurrentUser().userKey;
    final String selfEncryptedRoomSecretKey =
        await AesGcmEncryption(secretKey: userKey).encryptString(roomSecretKey);

    await ServerApi.roomService.joinGroup(JoinGroupRequest(
      invitationId: notification.id,
      selfEncryptedRoomSecretKey: selfEncryptedRoomSecretKey,
    ));

    _notifications.removeAt(index);
    final RoomsController inboxController = Get.find<RoomsController>();
    final HomeController homeController = Get.find<HomeController>();
    await inboxController.fetchRooms(fromServer: true);
    homeController.navigate(InboxScreen.routeName);
  }

  @override
  void onInit() {
    super.onInit();
    fetchNotifications();
  }

// void acceptNotification(String notificationId) async {
//   final response =
//       await ServerApi.notificationService.acceptNotification(notificationId);
//   if (response.success) {
//     _fetchNotifications();
//   }
// }
//
// void rejectNotification(String notificationId) async {
//   final response =
//       await ServerApi.notificationService.rejectNotification(notificationId);
//   if (response.success) {
//     _fetchNotifications();
//   }
// }
//
// void deleteNotification(String notificationId) async {
//   final response =
//       await ServerApi.notificationService.deleteNotification(notificationId);
//   if (response.success) {
//     _fetchNotifications();
//   }
// }
//
// void deleteAllNotifications() async {
//   final response =
//       await ServerApi.notificationService.deleteAllNotifications();
//   if (response.success) {
//     _fetchNotifications();
//   }
// }
}