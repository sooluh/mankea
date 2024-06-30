import 'dart:convert';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';

class NotificationService {
  static final plugin = FlutterLocalNotificationsPlugin();
  static final subject = BehaviorSubject<String?>();
  static NotificationService? instance;

  NotificationService.internal() {
    instance = this;
  }

  factory NotificationService() => instance ?? NotificationService.internal();

  Future<void> init() async {
    const initializationSettingsAndroid = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );

    const initializationSettingsIOS = DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    const initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );

    await plugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response) async {
        subject.add(response.payload);
      },
    );
  }

  final androidNotificationDetails = const AndroidNotificationDetails(
    'mankea',
    'Book Notifications',
    playSound: true,
    priority: Priority.high,
    importance: Importance.max,
  );

  Future<void> showNotification(title, message, data) async {
    await plugin.show(
      0,
      title,
      message,
      NotificationDetails(android: androidNotificationDetails),
      payload: json.encode(data),
    );
  }
}
