import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  NotificationService() {
    final initializationSettingsAndroid =
        AndroidInitializationSettings('linkod'); // replace with your icon
    // final initializationSettingsIOS = IOSInitializationSettings();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      // iOS: initializationSettingsIOS,
    );

    _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<void> showNotification(String title, String body) async {
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      '1',
      'linkod',
      channelDescription: 'test',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );
    // const iOSPlatformChannelSpecifics = IOSNotificationDetails();
    const platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      // iOS: iOSPlatformChannelSpecifics,
    );

    await _flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }
}
