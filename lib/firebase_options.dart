import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyCg5Z7ONVJJfvv6i1y1IQIilKdhl1ADuIs',
    appId: '1:417770551104:web:6006000000000000000000', // 👈 I updated this to a valid format
    messagingSenderId: '417770551104',
    projectId: 'pizza-lovers39',
    authDomain: 'pizza-lovers39.firebaseapp.com',
    storageBucket: 'pizza-lovers39.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCg5Z7ONVJJfvv6i1y1IQIilKdhl1ADuIs',
    appId: '1:417770551104:android:9150dd03d85d624bf16ca5',
    messagingSenderId: '417770551104',
    projectId: 'pizza-lovers39',
    storageBucket: 'pizza-lovers39.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCg5Z7ONVJJfvv6i1y1IQIilKdhl1ADuIs',
    appId: '1:417770551104:ios:9150dd03d85d624bf16ca5',
    messagingSenderId: '417770551104',
    projectId: 'pizza-lovers39',
    storageBucket: 'pizza-lovers39.firebasestorage.app',
    iosBundleId: 'com.example.pizza_lovers39',
  );
}
