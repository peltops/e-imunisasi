import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';
import 'package:timezone/timezone.dart' as tz;

@Singleton()
class NotificationService extends ChangeNotifier {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<bool?> initialize() async {
    final localNotificationPlugin = FlutterLocalNotificationsPlugin();
    localNotificationPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    final androidSetting = AndroidInitializationSettings("ic_launcher");
    final iosSetting = DarwinInitializationSettings();
    final initSetting = InitializationSettings(
      android: androidSetting,
      iOS: iosSetting,
    );
    return await localNotificationPlugin.initialize(initSetting);
  }

  Future<void> instantNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    final channelId = "instant_notification_id";
    final channelName = "instant_notification_channel";
    var android = AndroidNotificationDetails(
      channelId,
      channelName,
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
      enableVibration: true,
      enableLights: true,
      styleInformation: DefaultStyleInformation(true, true),
    );
    var ios = DarwinNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: ios);

    return await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<void> imageNotification({
    String? title,
    String? body,
    String? payload,
  }) async {
    var bigPicture = BigPictureStyleInformation(
      DrawableResourceAndroidBitmap("ic_launcher"),
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      contentTitle: title,
      summaryText: body,
      htmlFormatContent: true,
      htmlFormatContentTitle: true,
    );

    final channelId = "image_notification_id";
    final channelName = "image_notification_channel";
    var android = AndroidNotificationDetails(
      channelId,
      channelName,
      styleInformation: bigPicture,
    );
    var platform = NotificationDetails(android: android);

    return await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<void> stylishNotification({
    required String title,
    required String body,
    required String payload,
  }) async {
    final channelId = "stylish_notification_id";
    final channelName = "stylish_notification_channel";
    var android = AndroidNotificationDetails(
      channelId,
      channelName,
      color: Colors.pink[300],
      enableLights: true,
      enableVibration: true,
      largeIcon: DrawableResourceAndroidBitmap("ic_launcher"),
      styleInformation: MediaStyleInformation(
        htmlFormatContent: true,
        htmlFormatTitle: true,
      ),
    );

    var platform = NotificationDetails(android: android);

    return await _flutterLocalNotificationsPlugin.show(
      0,
      title,
      body,
      platform,
      payload: payload,
    );
  }

  Future<void> scheduledNotification(
    int id,
    String title,
    String body,
    DateTime date,
  ) async {
    final channelId = "scheduled_notification_id";
    final channelName = "scheduled_notification_channel";
    var android = AndroidNotificationDetails(
      channelId,
      channelName,
      enableLights: true,
      playSound: true,
      enableVibration: true,
    );

    var ios = DarwinNotificationDetails();

    var platform = NotificationDetails(android: android, iOS: ios);
    return await _flutterLocalNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(date, tz.local),
      platform,
      androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> cancelNotification(int id) async {
   return await _flutterLocalNotificationsPlugin.cancel(id);
  }

  Future<void> cancelNotificationAll() async {
   return await _flutterLocalNotificationsPlugin.cancelAll();
  }
}
