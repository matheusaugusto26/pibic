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
    apiKey: 'AIzaSyD6vd1iNb3WjFnihgSxIG8SfzEsX3UR-Wc',
    appId: '1:141928664195:web:7480cb1c61e5b328489fb6',
    messagingSenderId: '141928664195',
    projectId: 'pibic-matheusaugusto-2024',
    authDomain: 'pibic-matheusaugusto-2024.firebaseapp.com',
    storageBucket: 'pibic-matheusaugusto-2024.appspot.com',
    measurementId: 'G-0VREXB3DM5',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC8MiOfHyHPobILX5ZdiPyUnmWDe0WFtc4',
    appId: '1:141928664195:android:a48db8dd27b48ddc489fb6',
    messagingSenderId: '141928664195',
    projectId: 'pibic-matheusaugusto-2024',
    storageBucket: 'pibic-matheusaugusto-2024.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyC16kfDBfaWZA2j1x_C3wKOzugjp327tGI',
    appId: '1:141928664195:ios:ecc1d55f67acd76f489fb6',
    messagingSenderId: '141928664195',
    projectId: 'pibic-matheusaugusto-2024',
    storageBucket: 'pibic-matheusaugusto-2024.appspot.com',
    iosBundleId: 'com.example.aplicacao',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyC16kfDBfaWZA2j1x_C3wKOzugjp327tGI',
    appId: '1:141928664195:ios:ecc1d55f67acd76f489fb6',
    messagingSenderId: '141928664195',
    projectId: 'pibic-matheusaugusto-2024',
    storageBucket: 'pibic-matheusaugusto-2024.appspot.com',
    iosBundleId: 'com.example.aplicacao',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyD6vd1iNb3WjFnihgSxIG8SfzEsX3UR-Wc',
    appId: '1:141928664195:web:7480cb1c61e5b328489fb6',
    messagingSenderId: '141928664195',
    projectId: 'pibic-matheusaugusto-2024',
    authDomain: 'pibic-matheusaugusto-2024.firebaseapp.com',
    storageBucket: 'pibic-matheusaugusto-2024.appspot.com',
    measurementId: 'G-0VREXB3DM5',
  );
}
