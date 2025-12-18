// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;
import 'package:mood_diary/env/env.dart';

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
          'DefaultFirebaseOptions have not been configured for linux.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static FirebaseOptions get web => FirebaseOptions(
    apiKey: Env.webApiKey,
    appId: Env.webAppId,
    messagingSenderId: Env.messagingSenderId,
    projectId: Env.projectId,
    authDomain: Env.authDomain,
    storageBucket: Env.storageBucket,
    measurementId: Env.webMeasurementId,
  );

  static FirebaseOptions get android => FirebaseOptions(
    apiKey: Env.androidApiKey,
    appId: Env.androidAppId,
    messagingSenderId: Env.messagingSenderId,
    projectId: Env.projectId,
    storageBucket: Env.storageBucket,
  );

  static FirebaseOptions get ios => FirebaseOptions(
    apiKey: Env.iosApiKey,
    appId: Env.iosAppId,
    messagingSenderId: Env.messagingSenderId,
    projectId: Env.projectId,
    storageBucket: Env.storageBucket,
    iosBundleId: Env.iosBundleId,
  );

  static FirebaseOptions get macos => FirebaseOptions(
    apiKey: Env.iosApiKey, // Використовує ті ж ключі, що і iOS
    appId: Env.iosAppId,
    messagingSenderId: Env.messagingSenderId,
    projectId: Env.projectId,
    storageBucket: Env.storageBucket,
    iosBundleId: Env.iosBundleId,
  );

  static FirebaseOptions get windows => FirebaseOptions(
    apiKey: Env.windowsApiKey,
    appId: Env.windowsAppId,
    messagingSenderId: Env.messagingSenderId,
    projectId: Env.projectId,
    authDomain: Env.authDomain,
    storageBucket: Env.storageBucket,
    measurementId: Env.windowsMeasurementId,
  );
}