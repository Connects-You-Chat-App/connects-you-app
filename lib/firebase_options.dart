// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBybyey_i8FgZ15twVoRsvPa-iToSvEyMs',
    appId: '1:1029283828579:web:6344094adeb5cf60bb3956',
    messagingSenderId: '1029283828579',
    projectId: 'connects-you-ca764',
    authDomain: 'connects-you-ca764.firebaseapp.com',
    storageBucket: 'connects-you-ca764.appspot.com',
    measurementId: 'G-P9LZ1YK9VT',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCJGF__nRv3g_VRAlO91PDaP5PWyuQYrUw',
    appId: '1:1029283828579:android:b8bcde4bc769cf5fbb3956',
    messagingSenderId: '1029283828579',
    projectId: 'connects-you-ca764',
    storageBucket: 'connects-you-ca764.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBudaRkV3QY0dXwr1UsUrVom0t3P4dfipo',
    appId: '1:1029283828579:ios:6a8d8efd39511dafbb3956',
    messagingSenderId: '1029283828579',
    projectId: 'connects-you-ca764',
    storageBucket: 'connects-you-ca764.appspot.com',
    androidClientId:
        '1029283828579-ceaitlufk5oe21qnnhdnubh3r7kd7bqo.apps.googleusercontent.com',
    iosClientId:
        '1029283828579-o585bn84uan9fvu6g4rsdodiko4v3los.apps.googleusercontent.com',
    iosBundleId: 'com.adarsh.connectsYou',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBudaRkV3QY0dXwr1UsUrVom0t3P4dfipo',
    appId: '1:1029283828579:ios:8bd6fe8bbe676807bb3956',
    messagingSenderId: '1029283828579',
    projectId: 'connects-you-ca764',
    storageBucket: 'connects-you-ca764.appspot.com',
    androidClientId:
        '1029283828579-ceaitlufk5oe21qnnhdnubh3r7kd7bqo.apps.googleusercontent.com',
    iosClientId:
        '1029283828579-kt9a82ahrcueupojnr60scauhlar4hrr.apps.googleusercontent.com',
    iosBundleId: 'com.adarsh.connectsYou.RunnerTests',
  );
}