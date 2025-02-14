


import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';

Future<String?> getDeviceId() async {
  final DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  try {
    if (defaultTargetPlatform == TargetPlatform.android) {
      // For Android devices
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      return androidInfo.id; // Unique device ID for Android
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      // For iOS devices
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      return iosInfo.identifierForVendor; // Unique device ID for iOS
    } else if (defaultTargetPlatform == TargetPlatform.windows) {
      // For Windows
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      return windowsInfo.deviceId; // Unique device ID for Windows
    } else if (defaultTargetPlatform == TargetPlatform.macOS) {
      // For macOS
      MacOsDeviceInfo macInfo = await deviceInfo.macOsInfo;
      return macInfo.systemGUID; // Unique device ID for macOS
    } else if (defaultTargetPlatform == TargetPlatform.linux) {
      // For Linux
      LinuxDeviceInfo linuxInfo = await deviceInfo.linuxInfo;
      return linuxInfo.machineId; // Unique device ID for Linux
    } else if (defaultTargetPlatform == TargetPlatform.fuchsia) {
      // For Fuchsia
      return 'Unsupported platform: Fuchsia';
    } else {
      return 'Unsupported platform';
    }
  } catch (e) {
    debugPrint('Error getting device ID: $e');
    return null;
  }
}


Future<String?> getFbToken() async {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  try {
    String? token = defaultTargetPlatform == TargetPlatform.macOS
        ? await firebaseMessaging.getAPNSToken() ?? 'unable to get token [macos]'
        : await firebaseMessaging.getToken();
    debugPrint('FirebaseMessaging token: $token');
    return token;
  } catch (e) {
    debugPrint('Error getting FirebaseMessaging token: $e');
    return null;
  }
}

