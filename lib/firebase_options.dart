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
    apiKey: 'AIzaSyAVNZmJ2dD4bhAT_OFZh0_7kr2krR_oqO8',
    appId: '1:645186470981:web:3430baa6622bbe8df38f2c',
    messagingSenderId: '645186470981',
    projectId: 'aub-pickusup',
    authDomain: 'aub-pickusup.firebaseapp.com',
    storageBucket: 'aub-pickusup.appspot.com',
    measurementId: 'G-VLY053XQ4N',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDQCy6x3z38KV22yUztkQVZ8ppy53Ihkxg',
    appId: '1:645186470981:android:1ea20d28e4e3d7f6f38f2c',
    messagingSenderId: '645186470981',
    projectId: 'aub-pickusup',
    storageBucket: 'aub-pickusup.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDy8mrAwG7VUqB25mVQLC1zx2n1OnXIblQ',
    appId: '1:645186470981:ios:e94ab63e3fb48bbff38f2c',
    messagingSenderId: '645186470981',
    projectId: 'aub-pickusup',
    storageBucket: 'aub-pickusup.appspot.com',
    iosClientId:
        '645186470981-5nofdlrotprplr9h8qdkdrfuo36i85k8.apps.googleusercontent.com',
    iosBundleId: 'com.example.aubPickusup',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDy8mrAwG7VUqB25mVQLC1zx2n1OnXIblQ',
    appId: '1:645186470981:ios:e94ab63e3fb48bbff38f2c',
    messagingSenderId: '645186470981',
    projectId: 'aub-pickusup',
    storageBucket: 'aub-pickusup.appspot.com',
    iosClientId:
        '645186470981-5nofdlrotprplr9h8qdkdrfuo36i85k8.apps.googleusercontent.com',
    iosBundleId: 'com.example.aubPickusup',
  );
}
