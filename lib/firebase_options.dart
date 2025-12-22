
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
        return windows;
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
    apiKey: 'AIzaSyCmUlVCVU_b5f9EvCCR4OjpV7o0332SF30',
    appId: '1:277253889002:web:799c2f05851de6c0ab7093',
    messagingSenderId: '277253889002',
    projectId: 'wealthyfy-940a0',
    authDomain: 'wealthyfy-940a0.firebaseapp.com',
    storageBucket: 'wealthyfy-940a0.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAnbxJNYJONLqFDhIipOw5_vaY5Y7ho5aI',
    appId: '1:277253889002:android:b29fcf9c13d8ac2fab7093',
    messagingSenderId: '277253889002',
    projectId: 'wealthyfy-940a0',
    storageBucket: 'wealthyfy-940a0.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBIzbn0PSSAYsqVQAfhRwciR7A34Q1S6S8',
    appId: '1:277253889002:ios:4b99b7e4d4749096ab7093',
    messagingSenderId: '277253889002',
    projectId: 'wealthyfy-940a0',
    storageBucket: 'wealthyfy-940a0.firebasestorage.app',
    iosBundleId: 'com.lgt.wealthyfy',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBIzbn0PSSAYsqVQAfhRwciR7A34Q1S6S8',
    appId: '1:277253889002:ios:623f894d56083709ab7093',
    messagingSenderId: '277253889002',
    projectId: 'wealthyfy-940a0',
    storageBucket: 'wealthyfy-940a0.firebasestorage.app',
    iosBundleId: 'com.example.meeting',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyCmUlVCVU_b5f9EvCCR4OjpV7o0332SF30',
    appId: '1:277253889002:web:b8d35432e877af40ab7093',
    messagingSenderId: '277253889002',
    projectId: 'wealthyfy-940a0',
    authDomain: 'wealthyfy-940a0.firebaseapp.com',
    storageBucket: 'wealthyfy-940a0.firebasestorage.app',
  );

}