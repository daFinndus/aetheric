// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyAWHVKrAnqdTvS_8MN0ARl_25MBoysNzP4',
    appId: '1:950127373298:web:49e12481f24aac2365d96b',
    messagingSenderId: '950127373298',
    projectId: 'aetheric-e793e',
    authDomain: 'aetheric-e793e.firebaseapp.com',
    databaseURL: 'https://aetheric-e793e-default-rtdb.firebaseio.com',
    storageBucket: 'aetheric-e793e.appspot.com',
    measurementId: 'G-LTV2SX7L4D',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCCiduhy2bJwMNBy2VfYXN15QJjs5XGyU',
    appId: '1:950127373298:android:cee45b7b2abb6f8365d96b',
    messagingSenderId: '950127373298',
    projectId: 'aetheric-e793e',
    databaseURL: 'https://aetheric-e793e-default-rtdb.firebaseio.com',
    storageBucket: 'aetheric-e793e.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDasF2KaNMIKQa-fVOeZpoSC1qjz6v0vM8',
    appId: '1:950127373298:ios:acaaf8e3e57a798465d96b',
    messagingSenderId: '950127373298',
    projectId: 'aetheric-e793e',
    databaseURL: 'https://aetheric-e793e-default-rtdb.firebaseio.com',
    storageBucket: 'aetheric-e793e.appspot.com',
    iosBundleId: 'com.example.aetheric',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDasF2KaNMIKQa-fVOeZpoSC1qjz6v0vM8',
    appId: '1:950127373298:ios:203a433019391c6965d96b',
    messagingSenderId: '950127373298',
    projectId: 'aetheric-e793e',
    databaseURL: 'https://aetheric-e793e-default-rtdb.firebaseio.com',
    storageBucket: 'aetheric-e793e.appspot.com',
    iosBundleId: 'com.example.aetheric.RunnerTests',
  );
}
