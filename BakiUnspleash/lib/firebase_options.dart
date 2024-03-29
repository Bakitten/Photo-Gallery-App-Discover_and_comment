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
    apiKey: 'AIzaSyCQ-fLR2S7uN2-AJ97IsdjQ2kcS2HwQXWc',
    appId: '1:135681327017:web:f2d4f03245a1504cceceb8',
    messagingSenderId: '135681327017',
    projectId: 'baki-online-gallery',
    authDomain: 'baki-online-gallery.firebaseapp.com',
    storageBucket: 'baki-online-gallery.appspot.com',
    measurementId: 'G-BPTE8YH9KZ',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyBUFUkF5ASY53g0idbSs1b_R255OyUqURg',
    appId: '1:135681327017:android:57be6d0b4e66e121ceceb8',
    messagingSenderId: '135681327017',
    projectId: 'baki-online-gallery',
    storageBucket: 'baki-online-gallery.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCJ_8oBNX2d_wNBlj8z9MvFo4qMUv97Kpc',
    appId: '1:135681327017:ios:d5174fae5f6613eececeb8',
    messagingSenderId: '135681327017',
    projectId: 'baki-online-gallery',
    storageBucket: 'baki-online-gallery.appspot.com',
    iosBundleId: 'com.example.t6',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCJ_8oBNX2d_wNBlj8z9MvFo4qMUv97Kpc',
    appId: '1:135681327017:ios:10a2fb5471615c62ceceb8',
    messagingSenderId: '135681327017',
    projectId: 'baki-online-gallery',
    storageBucket: 'baki-online-gallery.appspot.com',
    iosBundleId: 'com.example.t6.RunnerTests',
  );
}
