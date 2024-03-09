import 'dart:developer';

import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:get/get.dart' hide Response;
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../models/base/notification.dart';
import '../models/common/shared_key.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/requests/join_group_request.dart';
import '../models/responses/main.dart';
import '../service/server.dart';
import '../utils/generate_shared_key.dart';
import '../widgets/screens/home/screens/inbox/inbox_screen.dart';
import 'home_controller.dart';
import 'room_controller.dart';

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
    final Box<SharedKeyHiveObject> sharedKeyBox =
        Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
    String? sharedKeyWithSender =
        sharedKeyBox.get(notification.senderUser.id)?.sharedKey;
    if (sharedKeyWithSender == null) {
      final SharedKeyResponse? value =
          await generateEncryptedSharedKey(notification.senderUser.publicKey);
      if (value == null) {
        log('Shared key is null');
        return;
      }
      final SharedKeyHiveObject sharedKeyHiveObject = SharedKeyHiveObject(
        sharedKey: value.key,
        forUserId: notification.senderUser.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      await Future.wait(<Future<void>>[
        sharedKeyBox.put(notification.senderUser.id, sharedKeyHiveObject),
        ServerApi.sharedKeyService.saveKey(
          SharedKey(
            key: value.encryptedKey,
            forUserId: notification.senderUser.id,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      ]);
      sharedKeyWithSender = value.key;
    }
    final String roomSecretKey =
        await AesGcmEncryption(secretKey: sharedKeyWithSender)
            .decryptString(notification.encryptedRoomSecretKey);
    final LazyBox<dynamic> commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
    final String userKey = await commonBox.get('USER_KEY') as String;
    final String selfEncryptedRoomSecretKey =
        await AesGcmEncryption(secretKey: userKey).encryptString(roomSecretKey);

    await ServerApi.roomService.joinGroup(JoinGroupRequest(
      invitationId: notification.id,
      selfEncryptedRoomSecretKey: selfEncryptedRoomSecretKey,
    ));

    _notifications.removeAt(index);
    final RoomController inboxController = Get.find<RoomController>();
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