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
    apiKey: 'AIzaSyDFXl7f13s8d8LwcSQdbQMcGLMOBpwjmvc',
    appId: '1:197972141258:web:YOUR_WEB_APP_ID',
    messagingSenderId: '197972141258',
    projectId: 'paw-rescue-a8681',
    authDomain: 'paw-rescue-a8681.firebaseapp.com',
    storageBucket: 'paw-rescue-a8681.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyDFXl7f13s8d8LwcSQdbQMcGLMOBpwjmvc',
    appId: '1:197972141258:android:f5c39199b230c150d40033', // This is the correct App ID for com.example.sdgp_pawrescue
    messagingSenderId: '197972141258',
    projectId: 'paw-rescue-a8681',
    storageBucket: 'paw-rescue-a8681.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyDFXl7f13s8d8LwcSQdbQMcGLMOBpwjmvc',
    appId: '1:197972141258:ios:YOUR_IOS_APP_ID',
    messagingSenderId: '197972141258',
    projectId: 'paw-rescue-a8681',
    storageBucket: 'paw-rescue-a8681.firebasestorage.app',
    iosClientId: 'YOUR_IOS_CLIENT_ID',
    iosBundleId: 'com.example.pawRescue',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyDFXl7f13s8d8LwcSQdbQMcGLMOBpwjmvc',
    appId: '1:197972141258:macos:YOUR_MACOS_APP_ID',
    messagingSenderId: '197972141258',
    projectId: 'paw-rescue-a8681',
    storageBucket: 'paw-rescue-a8681.firebasestorage.app',
    iosClientId: 'YOUR_MACOS_CLIENT_ID',
    iosBundleId: 'com.example.pawRescue',
  );
}