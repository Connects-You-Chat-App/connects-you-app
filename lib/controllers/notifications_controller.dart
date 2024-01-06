import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/controllers/home_controller.dart';
import 'package:connects_you/controllers/inbox_controller.dart';
import 'package:connects_you/models/base/notification.dart';
import 'package:connects_you/models/common/shared_key.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/models/requests/join_group_request.dart';
import 'package:connects_you/service/server.dart';
import 'package:connects_you/utils/generate_shared_key.dart';
import 'package:connects_you/widgets/screens/home/screens/inbox/inbox_screen.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class NotificationsController extends GetxController {
  final RxList<Notification> _notifications = <Notification>[].obs;

  RxList<Notification> get notifications => _notifications;

  Future fetchNotifications() async {
    final response = await ServerApi.notificationService.getNotifications();
    _notifications.value = response.response;
  }

  void addNotification(Notification notification) {
    _notifications.add(notification);
  }

  Future joinGroup(int index) async {
    final notification = _notifications[index];
    final sharedKeyBox =
        Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
    var sharedKeyWithSender =
        (await sharedKeyBox.get(notification.senderUser.id))?.key;
    if (sharedKeyWithSender == null) {
      final value =
          await generateEncryptedSharedKey(notification.senderUser.publicKey);
      final sharedKeyHiveObject = SharedKeyHiveObject(
        key: value.key,
        forUserId: notification.senderUser.id,
      );
      await Future.wait([
        sharedKeyBox.put(notification.senderUser.id, sharedKeyHiveObject),
        ServerApi.sharedKeyService.saveKey(
          SharedKey(
              key: value.encryptedKey, forUserId: notification.senderUser.id),
        ),
      ]);
      sharedKeyWithSender = value.key;
    }
    final roomSecretKey = await AesGcmEncryption(secretKey: sharedKeyWithSender)
        .decryptString(notification.encryptedRoomSecretKey);
    final commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
    final userKey = await commonBox.get("USER_KEY");
    final selfEncryptedRoomSecretKey =
        await AesGcmEncryption(secretKey: userKey).encryptString(roomSecretKey);

    await ServerApi.roomService.joinGroup(JoinGroupRequest(
      invitationId: notification.id,
      selfEncryptedRoomSecretKey: selfEncryptedRoomSecretKey,
    ));

    _notifications.removeAt(index);
    final inboxController = Get.find<InboxController>();
    final homeController = Get.find<HomeController>();
    await inboxController.fetchRooms(true);
    homeController.navigate(InboxScreen.routeName);
  }

  @override
  onInit() {
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