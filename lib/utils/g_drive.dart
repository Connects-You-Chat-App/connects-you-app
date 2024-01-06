import 'package:connects_you/constants/hive_secure_storage_keys.dart';
import 'package:connects_you/constants/keys.dart';
import 'package:connects_you/controllers/auth_controller.dart';
import 'package:connects_you/utils/secure_storage.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:gdrive/g_drive.dart';
import 'package:get/get.dart';

class GDriveOps {
  static const _userKeyFileName = 'key.txt';
  static final _authController = Get.find<AuthController>();

  static Future<dynamic> _getLocallyStoredSharedKeyFileId() {
    return SecureStorage.read(key: HiveSecureStorageKeys.USER_KEY_FILE);
  }

  static Future<bool> _saveToDrive(String fileContent,
      [String? existedFileId]) async {
    final token = await _authController.refreshGoogleTokens();
    final accessToken = token.accessToken;
    if (accessToken == null) {
      throw Exception('accessToken null');
    }

    String? fileId = existedFileId ?? await _getLocallyStoredSharedKeyFileId();
    if (fileId == null) {
      final response = await GDrive.getFileAndWriteFileContent(
          _userKeyFileName, fileContent, accessToken);
      await SecureStorage.write(key: _userKeyFileName, value: response.fileId);
      return true;
    } else {
      final response = await GDrive.writeFileContent(
          _userKeyFileName, fileContent, accessToken, fileId);
      if (response.response == null) {
        throw Exception('Write file content response null');
      }
      return true;
    }
  }

  static Future<bool> saveUserKey(
    String userKey,
  ) async {
    final encryptedJsonString =
        await AesGcmEncryption(secretKey: Keys.ENCRYTION_KEY)
            .encryptString(userKey);
    if (encryptedJsonString != null) {
      return await _saveToDrive(encryptedJsonString);
    }
    throw Exception('unable to encrypt');
  }

  static Future<String> getUserKey() async {
    final token = await _authController.refreshGoogleTokens();
    final accessToken = token.accessToken;
    if (accessToken == null) {
      throw Exception('accessToken null');
    }

    String? fileId = await _getLocallyStoredSharedKeyFileId();
    String encryptedUserKey;
    if (fileId == null) {
      final response =
          await GDrive.getFileAndReadFileContent(_userKeyFileName, accessToken);
      await SecureStorage.write(key: _userKeyFileName, value: response.fileId);
      encryptedUserKey = response.response;
    } else {
      encryptedUserKey = await GDrive.readFileContent(fileId, accessToken);
    }
    final decryptedUserKey =
        await AesGcmEncryption(secretKey: Keys.ENCRYTION_KEY)
            .decryptString(encryptedUserKey);
    if (decryptedUserKey == null) {
      throw Exception('decrypted text null');
    }
    return decryptedUserKey;
  }
}