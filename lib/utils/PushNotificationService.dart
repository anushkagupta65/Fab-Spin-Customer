import 'dart:convert';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationModel {
  final String title;
  final String body;
  final String imageUrl;

  NotificationModel({
    required this.title,
    required this.body,
    this.imageUrl = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'imageUrl': imageUrl,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      title: map['title'] ?? 'No Title',
      body: map['body'] ?? 'No Body',
      imageUrl: map['imageUrl'] ?? '',
    );
  }
}



class PushNotificationService {
  FirebaseMessaging _fcm = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  List<NotificationModel> notifications = [];

  Future<void> initialize(void Function(List<NotificationModel>) updateUI) async {
    print("Initializing PushNotificationService...");

    // Initialize local notifications
    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    print("Local Notifications Plugin initialized");

    // Foreground message handling
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Foreground Message Received: ${message.notification?.title}");
      if (message.notification != null) {
        NotificationModel notification = NotificationModel(
          title: message.notification!.title ?? "No Title",
          body: message.notification!.body ?? "No Body",
          imageUrl: message.data['imageUrl'] ?? '',
        );

        // Add the notification to the list if it does not exist
        if (!_doesNotificationExist(notification)) {
          notifications.add(notification);
          await _saveNotifications(); // Save notifications to SharedPreferences
          updateUI(notifications); // Call the callback to update the UI
          _showNotification(notification);
        }
      }
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  // Check if the notification already exists
  bool _doesNotificationExist(NotificationModel notification) {
    return notifications.any((n) => n.title == notification.title && n.body == notification.body);
  }

  // Save notifications to SharedPreferences
  Future<void> _saveNotifications() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Retrieve existing notifications
      List<String> notificationsJson = prefs.getStringList('notifications') ?? [];

      // Add new notifications (no duplicates)
      List<String> newNotificationsJson = notifications.map((n) => jsonEncode(n.toMap())).toList();
      notificationsJson = newNotificationsJson; // Replace list to avoid duplication

      // Save the updated list
      await prefs.setStringList('notifications', notificationsJson);
      print("Notifications saved successfully");
    } catch (e) {
      print("Error saving notifications: $e");
    }
  }

  // Background message handler
  static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
    print("Background Message Received: ${message.data}");

    // Initialize Firebase if needed
    await Firebase.initializeApp();

    // Initialize SharedPreferences and FlutterLocalNotificationsPlugin
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (message.notification != null) {
      NotificationModel notification = NotificationModel(
        title: message.notification!.title ?? "No Title",
        body: message.notification!.body ?? "No Body",
        imageUrl: message.data['imageUrl'] ?? '',
      );

      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> notificationsJson = prefs.getStringList('notifications') ?? [];

      // Avoid duplicates
      if (!notificationsJson.contains(jsonEncode(notification.toMap()))) {
        notificationsJson.add(jsonEncode(notification.toMap()));
        await prefs.setStringList('notifications', notificationsJson);
        print("Notification saved in background: ${notification.title}");
      }

      // Show the notification
      flutterLocalNotificationsPlugin.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'high_importance_channel',
            'High Importance Notifications',
            channelDescription: 'This channel is used for important notifications.',
            importance: Importance.max,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
        ),
      );
    }
  }

  // Show the notification
  void _showNotification(NotificationModel notification) {
    flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      notification.title,
      notification.body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_importance_channel',
          'High Importance Notifications',
          channelDescription: 'This channel is used for important notifications.',
          importance: Importance.max,
          priority: Priority.high,
          icon: '@mipmap/ic_launcher',
        ),
      ),
    );
    print("Notification displayed: ${notification.title}");
  }
}

