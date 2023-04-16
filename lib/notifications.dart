import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationApi {
  static final notifications = FlutterLocalNotificationsPlugin();

  static Future notificationDetails() async {
    return NotificationDetails(
      android: AndroidNotificationDetails('channel id', 'channel name',
          channelDescription: 'channel description',
          importance: Importance.max),
    );
  }

  static Future showNotification({
    required int id,
    required String title,
    required String body,
    required String payload,
  }) async {
    FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

const AndroidInitializationSettings initializationSettingsAndroid =  AndroidInitializationSettings('@mipmap/ic_launcher');


final InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,);

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
   await notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }
}
