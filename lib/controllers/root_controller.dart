import 'dart:io';

import 'package:get/get.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart' as pathProvider;

import '../configs/firebase_options.dart';
import '../models/objects/current_user_collection.dart';
import '../models/objects/message_collection.dart';
import '../models/objects/room_with_room_users_collection.dart';
import '../models/objects/shared_key_collection.dart';

class RootController extends GetxController {
  Future openBoxes() async {
    final Directory directory =
        await pathProvider.getApplicationDocumentsDirectory();
    Isar.open([
      CurrentUserCollectionSchema,
      MessageCollectionSchema,
      RoomCollectionSchema,
      SharedKeyCollectionSchema,
    ], directory: directory.path, name: "ConnectsYou");
  }

  Future initializeApp() async {
    await initializeAppIfNotAlready();
    await openBoxes();
    print("Hive boxes opened");
  }
}