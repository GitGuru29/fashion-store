import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
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
    apiKey: 'AIzaSyANwbo9yanv8HAVH738C8TJ8Ew8FEU3wp4',
    appId: '1:534393609979:web:516cf26327f83f72041a5e',
    messagingSenderId: '534393609979',
    projectId: 'belldi',
    authDomain: 'belldi.firebaseapp.com',
    storageBucket: 'belldi.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCCGI2L33-Dr-AvfF51hQS9n0RXWIAjUXg',
    appId: '1:534393609979:android:1fd70c5618458027041a5e',
    messagingSenderId: '534393609979',
    projectId: 'belldi',
    storageBucket: 'belldi.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyANwbo9yanv8HAVH738C8TJ8Ew8FEU3wp4',
    appId: '1:534393609979:ios:0000000000000000000000', // Placeholder
    messagingSenderId: '534393609979',
    projectId: 'belldi',
    storageBucket: 'belldi.firebasestorage.app',
    iosBundleId: 'com.example.belldi', // Placeholder
  );
}
