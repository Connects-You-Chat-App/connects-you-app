import 'dart:async';

import 'package:connects_you/configs/google.dart';
import 'package:connects_you/constants/hive_box_keys.dart';
import 'package:connects_you/controllers/root_controller.dart';
import 'package:connects_you/controllers/socket_controller.dart';
import 'package:connects_you/models/common/current_user.dart';
import 'package:connects_you/models/common/device_info.dart';
import 'package:connects_you/models/common/shared_key.dart';
import 'package:connects_you/models/objects/current_user_hive_object.dart';
import 'package:connects_you/models/objects/shared_key_hive_object.dart';
import 'package:connects_you/models/requests/authentication_request.dart';
import 'package:connects_you/models/requests/save_user_keys_request.dart';
import 'package:connects_you/models/responses/authentication_response.dart';
import 'package:connects_you/models/responses/main.dart' show Response;
import 'package:connects_you/service/server.dart';
import 'package:connects_you/utils/custom_exception.dart';
import 'package:connects_you/utils/device_info.dart';
import 'package:connects_you/utils/g_drive.dart';
import 'package:connects_you/utils/secure_storage.dart';
import 'package:connects_you/widgets/screens/home/home_screen.dart';
import 'package:connects_you/widgets/screens/splash/splash_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cryptography/aes_gcm_encryption.dart';
import 'package:flutter_cryptography/diffie_hellman.dart';
import 'package:flutter_cryptography/helper.dart';
import 'package:get/get.dart' hide Response;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hive/hive.dart';

class AuthStatesMessages {
  static const String fetchingYourPrevSession =
      'Fetching Your Previous Session';
  static const String sessionRetrieved = 'Session Retrieved';
  static const String sessionNotRetrieved =
      'Session Not Retrieved\nKindly authenticate yourself';
  static const String authenticatingYou = 'Authenticating You';
  static const String savingYourDetails =
      '$creatingYourAccount${'\n'}Saving Your Details';
  static const String savingLocalKeys = '$authenticatingYou${'\n'}Saving Keys';
  static const String creatingYourAccount = 'Creating Your Account';
  static const String savingDriveKeys =
      '$creatingYourAccount${'\n'}Saving Keys';
  static const String fetchingAndSavingYourPrevData =
      '$authenticatingYou${'\n'}Fetching And Saving Your Previous Data';
  static const String authCompleted = 'Authentication Process Completed';
  static const String authError =
      'Authentication Process Failed. ${'\n'}Try Again.';
}

enum AuthStates { notStarted, inProgress, completed }

class AuthController extends GetxController {
  final Rx<CurrentUser?> _authenticatedUser = Rx(null);
  final Rx<String?> _authStateMessage = Rx(null);
  final Rx<AuthStates> _authState = Rx(AuthStates.notStarted);

  CurrentUser? get authenticatedUser => _authenticatedUser.value;

  String? get authStateMessage => _authStateMessage.value;

  AuthStates get authState => _authState.value;

  StreamSubscription<AuthStates> Function(void Function(AuthStates p1) onData,
      {bool? cancelOnError,
      void Function()? onDone,
      Function? onError}) get authStateSubscription => _authState.listen;

  late final GoogleSignIn _googleSignIn;

  late final FirebaseAuth _auth;

  late final LazyBox<CurrentUserHiveObject> _currentUserBox;
  late final LazyBox<SharedKeyHiveObject> _sharedKeyBox;

  late final LazyBox _commonBox;

  late SocketController _socketController;

  @override
  void onInit() async {
    await Get.find<RootController>().initializeApp();
    _currentUserBox = Hive.lazyBox<CurrentUserHiveObject>(
      HiveBoxKeys.CURRENT_USER,
    );
    _commonBox = Hive.lazyBox(HiveBoxKeys.COMMON_BOX);
    _sharedKeyBox = Hive.lazyBox<SharedKeyHiveObject>(
      HiveBoxKeys.SHARED_KEY,
    );
    _googleSignIn = GoogleSignIn(
      scopes: GoogleConfig.scopes,
    );
    _auth = FirebaseAuth.instance;
    _socketController = Get.find<SocketController>();
    await _fetchAndSetAuthUser();
    super.onInit();
  }

  void afterAuthenticated() {
    _socketController.initializeSocket(_authenticatedUser.value!.token);
    Get.offAllNamed(HomeScreen.routeName);
  }

  Future _fetchAndSetAuthUser() async {
    try {
      final currentUser = await _currentUserBox.get("CURRENT_USER");
      if (currentUser == null) {
        throw const CustomException(errorMessage: 'currentUser is null');
      }
      _authenticatedUser.value = currentUser.toCurrentUser();
      await Future.delayed(const Duration(seconds: 1));
      afterAuthenticated();
    } catch (error) {
      await SecureStorage.deleteAll();
    }
    _authState.value = AuthStates.completed;
  }

  bool get isAuthenticated {
    return _authenticatedUser.value?.token != null;
  }

  Future _onLogin(CurrentUser user) async {
    if (user.publicKey == null || user.privateKey == null) {
      throw const CustomException(
          errorMessage: 'publicKey or privateKey is null');
    }
    final userDriveResponse = await GDriveOps.getUserKey();
    _authStateMessage.value = AuthStatesMessages.fetchingAndSavingYourPrevData;
    final decryptedPrivateKey = await AesGcmEncryption(
      secretKey: userDriveResponse,
    ).decryptString(user.privateKey!);

    _authenticatedUser.value = CurrentUser(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      publicKey: user.publicKey,
      privateKey: decryptedPrivateKey,
      token: user.token,
    );

    final [_, _, keys as Response<List<SharedKey>>] = await Future.wait([
      _currentUserBox.put("CURRENT_USER",
          CurrentUserHiveObject.fromCurrentUser(_authenticatedUser.value!)),
      _commonBox.put('USER_KEY', userDriveResponse),
      ServerApi.sharedKeyService.getKeys(),
    ]);

    await Future.wait(keys.response.map((key) => _sharedKeyBox.put(
        key.forUserId ?? key.forRoomId,
        SharedKeyHiveObject.fromSharedKey(key))));
  }

  Future _onSignup(CurrentUser user) async {
    _authStateMessage.value = AuthStatesMessages.savingYourDetails;
    final dh = DiffieHellman();
    await dh.generateKeyPair();
    final userSecretKey = (randomUUID() + randomUUID()).replaceAll('-', '');
    final String? privateKey = dh.alicePrivateKey;
    final String? publicKey = dh.alicePublicKey;

    if (privateKey == null || publicKey == null) {
      throw const CustomException(
          errorMessage: 'privateKey or publicKey is null');
    }

    final encryptedPrivateKey = await AesGcmEncryption(secretKey: userSecretKey)
        .encryptString(privateKey);

    _authStateMessage.value = AuthStatesMessages.savingDriveKeys;
    _authenticatedUser.value = CurrentUser(
      id: user.id,
      name: user.name,
      email: user.email,
      photoUrl: user.photoUrl,
      publicKey: publicKey,
      privateKey: privateKey,
      token: user.token,
    );

    await Future.wait([
      _currentUserBox.put("CURRENT_USER",
          CurrentUserHiveObject.fromCurrentUser(_authenticatedUser.value!)),
      ServerApi.authService.saveUserKeys(SaveUserKeysRequest(
        privateKey: encryptedPrivateKey,
        publicKey: publicKey,
      )),
      GDriveOps.saveUserKey(
        userSecretKey,
      ),
      _commonBox.put('USER_KEY', userSecretKey)
    ]);
  }

  Future<String> _authenticateViaGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) {
      throw const CustomException(errorMessage: 'googleUser is null');
    }
    final googleAuth = await googleUser.authentication;
    final googleCredential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    final firebaseUser =
        (await _auth.signInWithCredential(googleCredential)).user;

    if (firebaseUser == null) {
      throw const CustomException(errorMessage: 'firebaseUser is null');
    }

    final idToken = await firebaseUser.getIdToken();
    if (idToken == null) {
      throw const CustomException(errorMessage: 'idToken is null');
    }

    return idToken;
  }

  Future<AuthenticationResponse> authenticate() async {
    try {
      _authState.value = AuthStates.inProgress;
      final [idToken as String, fcmToken as String, deviceInfo as DeviceInfo] =
          await Future.wait([
        _authenticateViaGoogle(),
        FirebaseMessaging.instance.getToken(),
        getDeviceInfo()
      ]);
      final serverAuthUser =
          await ServerApi.authService.authenticate(AuthenticationRequest(
        token: idToken,
        fcmToken: fcmToken,
        deviceInfo: deviceInfo,
      ));

      if (serverAuthUser == null) {
        throw const CustomException(errorMessage: 'ServerApi user is null');
      }
      if (serverAuthUser.response.method == AuthMethod.none) {
        throw const CustomException(errorMessage: 'AuthMethod is none');
      }

      if (serverAuthUser.response.method == AuthMethod.login) {
        _authStateMessage.value = AuthStatesMessages.authenticatingYou;
        await _onLogin(
          serverAuthUser.response.user,
        );
      } else if (serverAuthUser.response.method == AuthMethod.signup) {
        _authStateMessage.value = AuthStatesMessages.creatingYourAccount;
        await _onSignup(serverAuthUser.response.user);
      }

      _authStateMessage.value = AuthStatesMessages.authCompleted;
      _authState.value = AuthStates.completed;
      afterAuthenticated();
      return serverAuthUser.response;
    } catch (error) {
      debugPrint(error.toString());
      _authenticatedUser.value = null;
      _authStateMessage.value = AuthStatesMessages.authError;
      _authState.value = AuthStates.completed;
      await _auth.signOut();
      await _googleSignIn.signOut();
      await _currentUserBox.clear();
      await SecureStorage.deleteAll();
      rethrow;
    }
  }

  Future<bool?> signOut() async {
    _authState.value = AuthStates.inProgress;
    final signOutResponse = await ServerApi.authService.signOut();
    await _currentUserBox.clear();
    await SecureStorage.deleteAll();
    _googleSignIn.signOut();
    _auth.signOut();
    Get.offAllNamed(SplashScreen.routeName);
    await Future.delayed(const Duration(seconds: 1));
    _authenticatedUser.value = null;
    _authStateMessage.value = null;
    _authState.value = AuthStates.completed;
    return signOutResponse?.response;
  }

  Future<GoogleSignInAuthentication> refreshGoogleTokens() async {
    final user = await _googleSignIn.signInSilently();
    if (user == null) {
      throw Exception('signin silently but user null');
    }
    return await user.authentication;
  }
}