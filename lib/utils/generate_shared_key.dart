import 'dart:developer';

import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/diffie_hellman.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

import '../constants/hive_box_keys.dart';
import '../controllers/auth_controller.dart';
import '../models/base/user.dart';
import '../models/common/current_user.dart';
import '../models/common/shared_key.dart';
import '../models/objects/shared_key_hive_object.dart';
import '../service/server.dart';

class SharedKeyResponse {
  SharedKeyResponse({required this.key, required this.encryptedKey});

  final String key;
  final String encryptedKey;
}

class UserWiseSharedKeyResponse {
  UserWiseSharedKeyResponse({required this.userId, required this.sharedKey});

  final String userId;
  final String sharedKey;
}

Future<SharedKeyResponse?> generateEncryptedSharedKey(
    final String otherUserPublicKey) async {
  final AuthController authController = Get.find<AuthController>();
  final CurrentUser user = authController.authenticatedUser!;
  final String? privateKey = user.privateKey;
  final String publicKey = user.publicKey;

  if (user.publicKey.hashCode == otherUserPublicKey.hashCode) {
    return null;
  }

  final DiffieHellman dh = DiffieHellman();
  dh.alicePrivateKey = privateKey;
  dh.alicePublicKey = publicKey;

  final String sharedKey =
      await dh.calculateSharedKey(bobPublicKey: otherUserPublicKey);
  final LazyBox<dynamic> commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
  final String userKey = await commonBox.get('USER_KEY')
      as String; // TODO: add user key in current user object and use it instead of this

  return SharedKeyResponse(
    key: sharedKey,
    encryptedKey:
        await AesGcmEncryption(secretKey: userKey).encryptString(sharedKey),
  );
}

Future<List<UserWiseSharedKeyResponse>> getSharedKeyWithOtherUsers(
    final List<User> users,
    {final bool force = false}) async {
  final Box<SharedKeyHiveObject> sharedKeyBox =
      Hive.box<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
  final List<UserWiseSharedKeyResponse> sharedKeys =
      <UserWiseSharedKeyResponse>[];
  List<User> remainingUsers = <User>[];

  if (!force) {
    await Future.wait(users.map((final User user) async {
      final SharedKeyHiveObject? sharedKey = sharedKeyBox.get(user.id);
      if (sharedKey != null) {
        sharedKeys.add(UserWiseSharedKeyResponse(
          userId: user.id,
          sharedKey: sharedKey.sharedKey,
        ));
      } else {
        remainingUsers.add(user);
      }
    }));
  } else {
    remainingUsers = users;
  }

  final List<SharedKey> sharedKeysToSave = <SharedKey>[];

  await Future.wait(remainingUsers.map((final User user) async {
    final SharedKeyResponse? encryptedSharedKey =
        await generateEncryptedSharedKey(user.publicKey);
    if (encryptedSharedKey == null) {
      log('Shared key is null');
      return;
    }
    await sharedKeyBox.put(
      user.id,
      SharedKeyHiveObject(
        sharedKey: encryptedSharedKey.key,
        forUserId: user.id,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    sharedKeysToSave.add(SharedKey(
      key: encryptedSharedKey.encryptedKey,
      forUserId: user.id,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    ));
    sharedKeys.add(UserWiseSharedKeyResponse(
      userId: user.id,
      sharedKey: encryptedSharedKey.key,
    ));
  }));

  if (sharedKeysToSave.isNotEmpty) {
    await ServerApi.sharedKeyService.saveKeys(sharedKeysToSave);
  }

  return sharedKeys;
}