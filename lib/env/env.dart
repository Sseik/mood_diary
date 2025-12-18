import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  // --- Android ---
  @EnviedField(varName: 'ANDROID_API_KEY', obfuscate: true)
  static final String androidApiKey = _Env.androidApiKey;
  @EnviedField(varName: 'ANDROID_APP_ID', obfuscate: true)
  static final String androidAppId = _Env.androidAppId;

  // --- Web ---
  @EnviedField(varName: 'WEB_API_KEY', obfuscate: true)
  static final String webApiKey = _Env.webApiKey;
  @EnviedField(varName: 'WEB_APP_ID', obfuscate: true)
  static final String webAppId = _Env.webAppId;
  @EnviedField(varName: 'WEB_MEASUREMENT_ID')
  static const String webMeasurementId = _Env.webMeasurementId;

  // --- iOS & macOS ---
  @EnviedField(varName: 'IOS_API_KEY', obfuscate: true)
  static final String iosApiKey = _Env.iosApiKey;
  @EnviedField(varName: 'IOS_APP_ID', obfuscate: true)
  static final String iosAppId = _Env.iosAppId;
  @EnviedField(varName: 'IOS_BUNDLE_ID')
  static const String iosBundleId = _Env.iosBundleId;

  // --- Windows ---
  @EnviedField(varName: 'WINDOWS_API_KEY', obfuscate: true)
  static final String windowsApiKey = _Env.windowsApiKey;
  @EnviedField(varName: 'WINDOWS_APP_ID', obfuscate: true)
  static final String windowsAppId = _Env.windowsAppId;
  @EnviedField(varName: 'WINDOWS_MEASUREMENT_ID')
  static const String windowsMeasurementId = _Env.windowsMeasurementId;

  // --- Common ---
  @EnviedField(varName: 'MESSAGING_SENDER_ID')
  static const String messagingSenderId = _Env.messagingSenderId;
  @EnviedField(varName: 'PROJECT_ID')
  static const String projectId = _Env.projectId;
  @EnviedField(varName: 'STORAGE_BUCKET')
  static const String storageBucket = _Env.storageBucket;
  @EnviedField(varName: 'AUTH_DOMAIN')
  static const String authDomain = _Env.authDomain;
}