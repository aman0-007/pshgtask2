
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
    apiKey: 'AIzaSyB84aT71-3pCNPBAzFydl9eC52Ocb9OqPo',
    appId: '1:274695880965:web:6088a21534a2974ca9376c',
    messagingSenderId: '274695880965',
    projectId: 'pshg-7c178',
    authDomain: 'pshg-7c178.firebaseapp.com',
    storageBucket: 'pshg-7c178.appspot.com',
    measurementId: 'G-LM9XJRK9M7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA84GhbV4JPbdskZ_Y8TMTjCC_hJM0rGqo',
    appId: '1:274695880965:android:c0cd1adeaa8db947a9376c',
    messagingSenderId: '274695880965',
    projectId: 'pshg-7c178',
    storageBucket: 'pshg-7c178.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC-00ilW7Z2J8G-8D1m9H4OLYRsn-pIaZM',
    appId: '1:274695880965:ios:709a6e2c3ec6ea5da9376c',
    messagingSenderId: '274695880965',
    projectId: 'pshg-7c178',
    storageBucket: 'pshg-7c178.appspot.com',
    iosClientId: '274695880965-n9nikaj1lbjej0rtl1v1bd1ffaaufj6i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pshgtask2',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC-00ilW7Z2J8G-8D1m9H4OLYRsn-pIaZM',
    appId: '1:274695880965:ios:709a6e2c3ec6ea5da9376c',
    messagingSenderId: '274695880965',
    projectId: 'pshg-7c178',
    storageBucket: 'pshg-7c178.appspot.com',
    iosClientId: '274695880965-n9nikaj1lbjej0rtl1v1bd1ffaaufj6i.apps.googleusercontent.com',
    iosBundleId: 'com.example.pshgtask2',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyB84aT71-3pCNPBAzFydl9eC52Ocb9OqPo',
    appId: '1:274695880965:web:956db7670ca88c0ba9376c',
    messagingSenderId: '274695880965',
    projectId: 'pshg-7c178',
    authDomain: 'pshg-7c178.firebaseapp.com',
    storageBucket: 'pshg-7c178.appspot.com',
    measurementId: 'G-CET2PHD20C',
  );
}
