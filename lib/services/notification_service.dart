import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:crm/utils/default_logger.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

import '../database/notification_database.dart';


class NotificationService {
  // Tag for logging purposes
  static const String tag = 'NotificationService';

  // Instance of the local notifications plugin to show notifications on the device
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  // Private constructor for singleton pattern (ensures only one instance of NotificationService exists)
  NotificationService._privateConstructor();

  // Static instance of NotificationService
  static final NotificationService instance = NotificationService._privateConstructor();

  // Channel details for Android notifications
  static String channelId = 'high_importance_channel';
  static String channelName = 'High Importance Notifications';
  static String channelDescription = 'This channel is used for important notifications.';

  /// Get the FCM (Firebase Cloud Messaging) token
  /// This token is unique to each device and is used to send push notifications to it
  static Future<String?> getToken() async => await FirebaseMessaging.instance.getToken();

  /// Get the initial notification when the app is launched from a terminated state
  /// This helps to retrieve the message that opened the app
  static Future<RemoteMessage?> getInitialNotification() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }

  /// Show a notification when a new RemoteMessage (push notification) is received
  static void showNotification(RemoteMessage message) {
    print('showNotification: $message');
    handleMessages(message);  // Handle and display the notification
  }

  /// Handle notification when the app is in the foreground
  static void onMessage(RemoteMessage message) {
    print('onMessage: $message');
    showNotification(message);
  }

  /// Handle notification when the app is opened via a notification tap
  static void onMessageOpenedApp(RemoteMessage message) {
    print('onMessageOpenedApp: $message');
  }
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  /// Initialize the local notification plugin and request notification permissions
  Future<void> initialize() async {
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');

    // iOS and macOS initialization settings, requesting permissions for alerts, sounds, and badges
    const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestSoundPermission: true,
      requestBadgePermission: true,
    );

    // Combine Android and iOS/macOS settings
    const InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    // Initialize the plugin with settings and response handler for notification taps
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
    );

    // Request permission for Firebase Messaging notifications
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      infoLog("User granted permission for push notifications");
    } else {
      errorLog("User denied push notification permission");
    }

    // Ensure that notifications are displayed while the app is in the foreground
    await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  /// Request notification permission from the user
  // Future<void> requestPermission() async {
  //   var status = await Permission.notification.request();  // Request notification access
  //   if (status.isGranted) {
  //     print('🔔 Notification access granted');
  //   } else {
  //     await openAppSettings();  // Open app settings if permission is denied
  //   }
  // }

  /// Handle and display the incoming notification based on its type (text or image)
  static Future<void> handleMessages(RemoteMessage message) async {
    RemoteNotification? notification = message.notification;
    Map<String, dynamic> data = message.data;

    String? title = notification?.title ?? data['title'];
    String? body = notification?.body ?? data['body'];
    String? image = data['image'];

    // Format the current date and time in 'MM/dd/yyyy hh:mm a' format
    String timestamp = DateFormat('MM/dd/yyyy hh:mm a').format(DateTime.now());

    String payload = jsonEncode(data);
    int notificationId = int.parse(message.messageId?.hashCode.toString().substring(0, 8) ?? DateTime.now().microsecondsSinceEpoch.toString());
    Map<String, dynamic> notificationData = {
      "id":  notificationId,
      'title': title,
      'body': body,
      'image': image,
      'payload': payload,
      'timestamp': timestamp,  // Store the formatted timestamp
    };

    await NotificationDatabase.instance.insertNotification(notificationData);
    infoLog('📥 New Notification Stored: $notificationData');

    List<Map<String, dynamic>> allNotifications = await NotificationDatabase.instance.getAllNotifications();
    infoLog('📜 All Stored Notifications:');
    for (var n in allNotifications) {
      infoLog("$n");
    }

    if (image != null) {
      showBigPictureNotification(title ?? '', body ?? '', image, message);
    } else {
      showBigTextNotification(title ?? '', body ?? '', payload);
    }
  }



  /// Show a notification with big text style (for longer message content)
  static void showBigTextNotification(String title, String body, String payload) async {
    print('Notification: 💬 showBigTextNotification');

    // Configure Android-specific notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      styleInformation: BigTextStyleInformation(body),  // Use BigText style
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification with a random unique ID
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000),
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  /// Show a big picture notification with an image
  static Future<void> showBigPictureNotification(
      String title, String body, String picturePath, RemoteMessage message) async {
    print('Notification: 🌃 showBigPictureNotification');

    // Download the image and save it locally
    final String filePath = await _downloadAndSaveFile(picturePath, 'bigPictureNotification');
    FilePathAndroidBitmap bigPictureBitmap = FilePathAndroidBitmap(filePath);

    // Configure the big picture style for the notification
    final BigPictureStyleInformation bigPictureStyleInformation = BigPictureStyleInformation(
      bigPictureBitmap,
      contentTitle: title,
      summaryText: body,
      htmlFormatContentTitle: true,
      htmlFormatSummaryText: true,
    );

    // Configure Android-specific notification details
    AndroidNotificationDetails androidPlatformChannelSpecifics = AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      styleInformation: bigPictureStyleInformation,
      importance: Importance.max,
      priority: Priority.high,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    // Show the notification with the big picture
    await flutterLocalNotificationsPlugin.show(
      Random().nextInt(10000),
      title,
      body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  /// Download an image from the given URL and save it locally
  static Future<String> _downloadAndSaveFile(String url, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    String ext = url.split('.').last;  // Extract the file extension from the URL
    final String filePath = '${directory.path}/$fileName.$ext';

    try {
      // Download the file using Dio package
      final Response response = await Dio().get(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      final File file = File(filePath);
      await file.writeAsBytes(response.data);  // Save the file locally
    } catch (e) {
      print('Notification: _downloadAndSaveFile error: $e');
    }

    return filePath;
  }

  /// Handle the response when a notification is tapped by the user
  static Future<void> onDidReceiveNotificationResponse(NotificationResponse response) async {
    print('Notification clicked with payload: ${response.payload}');
  }
}

