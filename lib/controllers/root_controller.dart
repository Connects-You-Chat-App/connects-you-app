import 'package:connects_you/configs/firebase_options.dart';
import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/constants/keys.dart';
import 'package:connects_you/models/objects/current_user_hive_object.dart';
import 'package:connects_you/models/objects/room_with_room_users_hive_object.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/models/objects/user_hive_object.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

class RootController extends GetxController {
  void registerAdapters() {
    Hive.registerAdapter(CurrentUserHiveObjectAdapter());
    Hive.registerAdapter(SharedKeyHiveObjectAdapter());
    Hive.registerAdapter(RoomWithRoomUsersHiveObjectAdapter());
    Hive.registerAdapter(UserHiveObjectAdapter());
  }

  Future flushBoxes() async {
    await Hive.lazyBox(HiveBoxKeys.COMMON_BOX).flush();
    await Hive.lazyBox<CurrentUserHiveObject>(HiveBoxKeys.CURRENT_USER).flush();
    await Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).flush();
    await Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS)
        .flush();
  }

  Future openBoxes() async {
    final hiveCipher = HiveAesCipher(Keys.HIVE_STORAGE_KEY.codeUnits);

    await Hive.openLazyBox<CurrentUserHiveObject>(HiveBoxKeys.CURRENT_USER,
        encryptionCipher: hiveCipher);
    await Hive.openLazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY,
        encryptionCipher: hiveCipher);
    await Hive.openLazyBox(HiveBoxKeys.COMMON_BOX,
        encryptionCipher: hiveCipher);
    await Hive.openBox<RoomWithRoomUsersHiveObject>(
        HiveBoxKeys.ROOMS_WITH_ROOM_USERS,
        encryptionCipher: hiveCipher);

    await Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY).clear();
    await Hive.box<RoomWithRoomUsersHiveObject>(
            HiveBoxKeys.ROOMS_WITH_ROOM_USERS)
        .clear();
  }

  Future initializeApp() async {
    await initializeAppIfNotAlready();
    final directory = await pathProvider.getApplicationDocumentsDirectory();
    Hive.init(directory.path);
    registerAdapters();
    await openBoxes();
  }

  @override
  void onClose() async {
    await flushBoxes();
    await Hive.close();
    super.onClose();
  }
}