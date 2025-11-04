// Generated manually: Firebase options for Android and Web.
import 'package:firebase_core/firebase_core.dart';
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
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'FirebaseOptions for this platform not configured. Run flutterfire configure.',
        );
    }
  }

  // Values derived from android/app/google-services.json
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyC0iD3RLeceBs2fx9sFYto4il28QyP6Qk8',
    appId: '1:371882981753:android:030c0365910f56471897a8',
    messagingSenderId: '371882981753',
    projectId: 'chatd22-836f0',
    storageBucket: 'chatd22-836f0.firebasestorage.app',
  );

  
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyC0t7NfsoFqS9P7G5pVfMAYlEU671Po1TE',
    appId: '1:371882981753:web:03f425727b14d0461897a8',
    messagingSenderId: '371882981753',
    projectId: 'chatd22-836f0',
    authDomain: 'chatd22-836f0.firebaseapp.com',
    storageBucket: 'chatd22-836f0.firebasestorage.app',
  );
}
