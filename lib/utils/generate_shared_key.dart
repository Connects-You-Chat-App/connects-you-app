import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/controllers/auth_controller.dart';
import 'package:connects_you/models/base/user.dart';
import 'package:connects_you/models/common/shared_key.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/service/server.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/diffie_hellman.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';

class SharedKeyResponse {
  final String key;
  final String encryptedKey;

  SharedKeyResponse({required this.key, required this.encryptedKey});
}

class UserWiseSharedKeyResponse {
  final String userId;
  final String sharedKey;

  UserWiseSharedKeyResponse({required this.userId, required this.sharedKey});
}

Future<SharedKeyResponse> generateEncryptedSharedKey(
    String otherUserPublicKey) async {
  final authController = Get.find<AuthController>();
  final user = authController.authenticatedUser!;
  final privateKey = user.privateKey;
  final publicKey = user.publicKey;

  final dh = DiffieHellman();
  dh.alicePrivateKey = privateKey;
  dh.alicePublicKey = publicKey;

  final sharedKey =
      await dh.calculateSharedKey(bobPublicKey: otherUserPublicKey);
  final commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
  final userKey = await commonBox.get("USER_KEY");

  return SharedKeyResponse(
    key: sharedKey,
    encryptedKey:
        await AesGcmEncryption(secretKey: userKey).encryptString(sharedKey),
  );
}

Future<List<UserWiseSharedKeyResponse>> getSharedKeyWithOtherUsers(
    List<User> users) async {
  final sharedKeyBox =
      Hive.lazyBox<SharedKeyHiveObject>(HiveBoxKeys.SHARED_KEY);
  final sharedKeys = <UserWiseSharedKeyResponse>[];
  final remainingUsers = <User>[];

  await Future.wait(users.map((user) async {
    final sharedKey = await sharedKeyBox.get(user.id);
    if (sharedKey != null) {
      sharedKeys.add(UserWiseSharedKeyResponse(
        userId: user.id,
        sharedKey: sharedKey.key,
      ));
    } else {
      remainingUsers.add(user);
    }
  }));

  final sharedKeysToSave = <SharedKey>[];

  await Future.wait(remainingUsers.map((user) async {
    final encryptedSharedKey = await generateEncryptedSharedKey(user.publicKey);
    await sharedKeyBox.put(
      user.id,
      SharedKeyHiveObject(key: encryptedSharedKey.key, forUserId: user.id),
    );
    sharedKeysToSave.add(
      SharedKey(key: encryptedSharedKey.encryptedKey, forUserId: user.id),
    );
    sharedKeys.add(UserWiseSharedKeyResponse(
      userId: user.id,
      sharedKey: encryptedSharedKey.key,
    ));
  }));

  await ServerApi.sharedKeyService.saveKeys(sharedKeysToSave);

  return sharedKeys;
}