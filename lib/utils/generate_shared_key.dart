import 'dart:developer';

import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/diffie_hellman.dart';
import 'package:get/get.dart';

import '../controllers/auth_controller.dart';
import '../models/objects/current_user.dart';
import '../models/objects/room_with_room_users_and_messages.dart';
import '../models/objects/shared_key.dart';
import '../services/database/main.dart';
import '../services/http/server.dart';

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
  final CurrentUserModel user = authController.authenticatedUser!;
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

  if (user.userKey == null) {
    throw Exception('UserModel key is null');
  }

  return SharedKeyResponse(
    key: sharedKey,
    encryptedKey: await AesGcmEncryption(secretKey: user.userKey!)
        .encryptString(sharedKey),
  );
}

Future<List<UserWiseSharedKeyResponse>> getSharedKeyWithOtherUsers(
    final List<UserModel> users,
    {final bool force = false}) async {
  final List<UserWiseSharedKeyResponse> sharedKeys =
      <UserWiseSharedKeyResponse>[];
  List<UserModel> remainingUsers = <UserModel>[];

  if (!force) {
    await Future.wait(users.map((final UserModel user) async {
      final SharedKeyModel? sharedKey =
          RealmService.sharedKeyModelService.getSharedKeyForUser(user.id);
      if (sharedKey != null) {
        sharedKeys.add(UserWiseSharedKeyResponse(
          userId: user.id,
          sharedKey: sharedKey.key,
        ));
      } else {
        remainingUsers.add(user);
      }
    }));
  } else {
    remainingUsers = users;
  }

  final List<SharedKeyModel> encryptedSharedKeysToSave = <SharedKeyModel>[];
  final List<SharedKeyModel> sharedKeysToSave = <SharedKeyModel>[];

  await Future.wait(remainingUsers.map((final UserModel user) async {
    final SharedKeyResponse? encryptedSharedKey =
        await generateEncryptedSharedKey(user.publicKey);
    if (encryptedSharedKey == null) {
      log('Shared key is null');
      return;
    }
    encryptedSharedKeysToSave.add(SharedKeyModel(
      encryptedSharedKey.encryptedKey,
      DateTime.now(),
      DateTime.now(),
      forUserId: user.id,
    ));
    sharedKeysToSave.add(SharedKeyModel(
      encryptedSharedKey.key,
      DateTime.now(),
      DateTime.now(),
      forUserId: user.id,
    ));
    sharedKeys.add(UserWiseSharedKeyResponse(
      userId: user.id,
      sharedKey: encryptedSharedKey.key,
    ));
  }));

  if (sharedKeysToSave.isNotEmpty) {
    await ServerApi.sharedKeyService.saveKeys(encryptedSharedKeysToSave);
  }
  if (!RealmService.sharedKeyModelService.addSharedKeys(sharedKeysToSave)) {
    throw Exception('Failed to save shared keys');
  }

  return sharedKeys;
}
