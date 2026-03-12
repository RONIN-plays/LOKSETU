import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyCdkNL9k6qrrfMqKgH49OKtvfar9bU-SJw',
    appId: '1:55358444965:web:f2b00400519365fa8e844c',
    messagingSenderId: '55358444965',
    projectId: 'loksetu-8199a',
    authDomain: 'loksetu-8199a.firebaseapp.com',
    storageBucket: 'loksetu-8199a.firebasestorage.app',
    measurementId: 'G-2VBPLWK2DV',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCdkNL9k6qrrfMqKgH49OKtvfar9bU-SJw',
    appId: '1:55358444965:android:9e39d3e3c9e7a5b6c1234d5e',
    messagingSenderId: '55358444965',
    projectId: 'loksetu-8199a',
    storageBucket: 'loksetu-8199a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCdkNL9k6qrrfMqKgH49OKtvfar9bU-SJw',
    appId: '1:55358444965:ios:9e39d3e3c9e7a5b6c1234d5e',
    messagingSenderId: '55358444965',
    projectId: 'loksetu-8199a',
    storageBucket: 'loksetu-8199a.firebasestorage.app',
  );
}
