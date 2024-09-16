import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:permission_handler/permission_handler.dart';
import "package:timezone/data/latest.dart" as tz;
import "package:timezone/timezone.dart" as tz;

class NotificationHelper {
  static final _notifications = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final settingsAndroid = AndroidInitializationSettings('app_icon');
    final settings = InitializationSettings(
      android: settingsAndroid,
    );
    await _notifications.initialize(settings, onDidReceiveNotificationResponse:
        (NotificationResponse response) async {
      print(response);
    });
  }

  Future<void> requestPermissions() async {
    PermissionStatus status = await Permission.notification.status;
    if (status.isDenied) {
      await Permission.notification.request();
    }
    if (status.isPermanentlyDenied) {
      openAppSettings();
    }
    if (status.isRestricted) {
      openAppSettings();
    }
    if (status.isGranted) {
      await init();
    }
  }

  // utilizando o modelo abaixo para disparar a notificação assim que dê

  static Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    required DateTime scheduledDate,
  }) async {
    final androidDetails = const AndroidNotificationDetails(
      'Habitos',
      'monitorando habitos',
      importance: Importance.max,
      priority: Priority.high,
      enableVibration: true,
    );
    final notificationDetails = NotificationDetails(android: androidDetails);

    await _notifications.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledDate, tz.local),
      notificationDetails,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }


  Future<void> scheduledDateDailyNotification(DateTime time) async{
    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    return showNotification(
      id: 0,
      title: 'Hora de cumprir seu hábito!',
      body: 'Hora de cumprir seu hábito!',
      scheduledDate: scheduledDate,
    );
  }


  Future<void> scheduledDateWeaklyNotification(DateTime time, List<int> weakdays) async{
    final now = DateTime.now();
    final scheduledDate = DateTime(now.year, now.month, now.day, time.hour, time.minute);
    for (int i = 0; i < weakdays.length; i++){
      if (weakdays[i] == now.weekday){
        return showNotification(
          id: 0,
          title: 'Hora de cumprir seu hábito!',
          body: 'Hora de cumprir seu hábito!',
          scheduledDate: scheduledDate,
        );
      }
    }
  }
}
