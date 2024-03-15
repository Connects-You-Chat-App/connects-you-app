import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:gdrive/g_drive.dart';
import 'package:gdrive/response.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../constants/keys.dart';
import '../constants/secure_storage_keys.dart';
import '../controllers/auth_controller.dart';
import '../services/database/secure_storage_service.dart';

mixin GDriveOps {
  static const String _userKeyFileName = 'key.txt';
  static final AuthController _authController = Get.find<AuthController>();

  static String? _getLocallyStoredSharedKeyFileId() {
    // return SecureStorage.read(key: HiveSecureStorageKeys.USER_KEY_FILE);
    return SecureStorageModelService()
        .getValue()[SecureStorageKeys.USER_KEY_FILE];
  }

  static Future<bool> _saveToDrive(final String fileContent,
      [final String? existedFileId]) async {
    final GoogleSignInAuthentication token =
        await _authController.refreshGoogleTokens();
    final String? accessToken = token.accessToken;
    if (accessToken == null) {
      throw Exception('accessToken null');
    }

    final String? fileId =
        existedFileId ?? await _getLocallyStoredSharedKeyFileId() as String?;
    if (fileId == null) {
      final FileResponse<dynamic> response =
          await GDrive.getFileAndWriteFileContent(
              _userKeyFileName, fileContent, accessToken);
      SecureStorageModelService()
          .addOrUpdateValue(_userKeyFileName, response.fileId);
      return true;
    } else {
      final FileResponse<dynamic> response = await GDrive.writeFileContent(
          _userKeyFileName, fileContent, accessToken, fileId);
      if (response.response == null) {
        throw Exception('Write file content response null');
      }
      return true;
    }
  }

  static Future<bool> saveUserKey(
    final String userKey,
  ) async {
    final String encryptedJsonString =
        await AesGcmEncryption(secretKey: Keys.ENCRYPTION_KEY)
            .encryptString(userKey);
    return _saveToDrive(encryptedJsonString);
  }

  static Future<String> getUserKey() async {
    final GoogleSignInAuthentication token =
        await _authController.refreshGoogleTokens();
    final String? accessToken = token.accessToken;
    if (accessToken == null) {
      throw Exception('accessToken null');
    }

    final String? fileId = await _getLocallyStoredSharedKeyFileId() as String?;
    String encryptedUserKey;
    if (fileId == null) {
      final FileResponse<String> response =
          await GDrive.getFileAndReadFileContent(_userKeyFileName, accessToken);
      SecureStorageModelService()
          .addOrUpdateValue(_userKeyFileName, response.fileId);
      encryptedUserKey = response.response;
    } else {
      encryptedUserKey = await GDrive.readFileContent(fileId, accessToken);
    }
    final String decryptedUserKey =
        await AesGcmEncryption(secretKey: Keys.ENCRYPTION_KEY)
            .decryptString(encryptedUserKey);
    return decryptedUserKey;
  }
}