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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyDjnE6SNdi9TtHBqIt-BvPAXUq_YRqOOWw',
    appId: '1:666010994276:web:9480636013d5479fe90171',
    messagingSenderId: '666010994276',
    projectId: 'classcheckup',
    authDomain: 'classcheckup.firebaseapp.com',
    storageBucket: 'classcheckup.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDR1_cKA7iYPLMjzN-ulQQJIQVadGu0JjY',
    appId: '1:666010994276:android:a1a50e7bd5952e44e90171',
    messagingSenderId: '666010994276',
    projectId: 'classcheckup',
    storageBucket: 'classcheckup.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDy7t4ZtauuY0_twQcgtDsKPvQu7mEdHf8',
    appId: '1:666010994276:ios:110d34f0f741a1a9e90171',
    messagingSenderId: '666010994276',
    projectId: 'classcheckup',
    storageBucket: 'classcheckup.appspot.com',
    iosClientId: '666010994276-jat7c9veovrlgirgpepd8j5ms8p4kgmi.apps.googleusercontent.com',
    iosBundleId: 'com.example.classcheckup',
  );
}