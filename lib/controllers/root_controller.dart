import 'dart:io';

import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import '../configs/firebase_options.dart';
import '../constants/hive_box_keys.dart';
import '../constants/keys.dart';
import '../models/objects/current_user_hive_object.dart';
import '../models/objects/message_hive_object.dart';
import '../models/objects/room_with_room_users_hive_object.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../models/objects/user_hive_object.dart';

class RootController extends GetxController {
  void registerAdapters() {
    Hive.registerAdapter(UserHiveObjectAdapter());
    Hive.registerAdapter(CurrentUserHiveObjectAdapter());
    Hive.registerAdapter(SharedKeyHiveObjectAdapter());
    Hive.registerAdapter(RoomWithRoomUsersHiveObjectAdapter());
    Hive.registerAdapter(MessageUserHiveObjectAdapter());
    Hive.registerAdapter(MessageHiveObjectAdapter());
  }

  Future flushBoxes() async {
    await Hive.lazyBox(HiveBoxKeys.COMMON_BOX).flush();
    await Hive.lazyBox<CurrentUserHiveObject>(HiveBoxKeys.CURRENT_USER).flush();
    await Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).flush();
    await Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS)
        .flush();
    await Hive.box<List<MessageHiveObject>>(HiveBoxKeys.MESSAGES).flush();
  }

  Future openBoxes() async {
    final HiveAesCipher hiveCipher =
        HiveAesCipher(Keys.HIVE_STORAGE_KEY.codeUnits);
    await Future.wait(<Future<Object>>[
      Hive.openLazyBox<CurrentUserHiveObject>(HiveBoxKeys.CURRENT_USER,
          encryptionCipher: hiveCipher),
      Hive.openBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY,
          encryptionCipher: hiveCipher),
      Hive.openLazyBox(HiveBoxKeys.COMMON_BOX, encryptionCipher: hiveCipher),
      Hive.openBox<RoomWithRoomUsersHiveObject>(
          HiveBoxKeys.ROOMS_WITH_ROOM_USERS,
          encryptionCipher: hiveCipher),
      Hive.openBox<List<MessageHiveObject>>(HiveBoxKeys.MESSAGES,
          encryptionCipher: hiveCipher),
    ]);
  }

  Future initializeApp() async {
    await initializeAppIfNotAlready();
    final Directory directory =
        await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    registerAdapters();
    await openBoxes();
    print("Hive boxes opened");
  }

  @override
  Future<void> onClose() async {
    await flushBoxes();
    await Hive.close();
    super.onClose();
  }
}