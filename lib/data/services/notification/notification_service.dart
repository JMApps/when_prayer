import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  static final NotificationService _localNoticeService = NotificationService._internal();

  factory NotificationService() {
    return _localNoticeService;
  }

  NotificationService._internal();

  static const String _logoName = 'ic_app_notification';

  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails _prayerAndroidDetails =
  const AndroidNotificationDetails(
    'Prayer notifications', // channel id
    'WP notifications',     // channel name
    channelDescription: 'When prayer notifications',
    icon: _logoName,
    importance: Importance.max,
    priority: Priority.max,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('adhan'),
  );

  final AndroidNotificationDetails _androidTimeNotificationDetails =
  const AndroidNotificationDetails(
    'When prayer daily notifications', // channel id
    'When prayer notifications',       // channel name
    channelDescription: 'When prayer daily notifications',
    icon: _logoName,
    importance: Importance.max,
    priority: Priority.max,
  );

  final DarwinNotificationDetails _prayerIOSDetails =
  const DarwinNotificationDetails(
    presentSound: true,
    sound: 'adhan.caf',
  );

  final DarwinNotificationDetails _iOSTimeNotificationDetails =
  const DarwinNotificationDetails();

  Future<void> setupNotification() async {
    // Инициализация таймзон
    tz.initializeTimeZones();

    const AndroidInitializationSettings androidInitializationSettings =
    AndroidInitializationSettings(_logoName);

    const DarwinInitializationSettings iOSInitializationSettings =
    DarwinInitializationSettings(
      requestSoundPermission: true,
      requestAlertPermission: true,
      requestBadgePermission: true,
    );

    const InitializationSettings initializationSettings = InitializationSettings(
      android: androidInitializationSettings,
      iOS: iOSInitializationSettings,
    );

    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);

    if (Platform.isAndroid) {
      final androidPlugin = _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>();

      // Разрешение на уведомления (Android 13+)
      final notifGranted =
      await androidPlugin?.requestNotificationsPermission();

      // Разрешение на точные будильники (Android 12+)
      final exactGranted =
      await androidPlugin?.requestExactAlarmsPermission();

      debugPrint(
          'Notifications permission: $notifGranted, exact alarms: $exactGranted');
    }
  }

  Future<void> prayerNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tz.TZDateTime tzDateNotification =
    tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateNotification,
        NotificationDetails(
          android: _prayerAndroidDetails,
          iOS: _prayerIOSDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on PlatformException catch (e) {
      debugPrint("Error scheduling prayer notification: $e");
      if (e.code == 'exact_alarms_not_permitted') {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateNotification,
          NotificationDetails(
            android: _prayerAndroidDetails,
            iOS: _prayerIOSDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
    }
  }

  Future<void> dailyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tz.TZDateTime tzDateNotification =
    tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateNotification,
        NotificationDetails(
          android: _androidTimeNotificationDetails,
          iOS: _iOSTimeNotificationDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } on PlatformException catch (e) {
      debugPrint("Error scheduling daily notification: $e");
      if (e.code == 'exact_alarms_not_permitted') {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateNotification,
          NotificationDetails(
            android: _androidTimeNotificationDetails,
            iOS: _iOSTimeNotificationDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.time,
        );
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
    }
  }

  Future<void> weeklyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tz.TZDateTime tzDateNotification =
    tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateNotification,
        NotificationDetails(
          android: _androidTimeNotificationDetails,
          iOS: _iOSTimeNotificationDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
      );
    } on PlatformException catch (e) {
      debugPrint("Error scheduling weekly notification: $e");
      if (e.code == 'exact_alarms_not_permitted') {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateNotification,
          NotificationDetails(
            android: _androidTimeNotificationDetails,
            iOS: _iOSTimeNotificationDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfWeekAndTime,
        );
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
    }
  }

  Future<void> monthlyNotification({
    required int id,
    required String title,
    required String body,
    required DateTime dateTime,
  }) async {
    final tz.TZDateTime tzDateNotification =
    tz.TZDateTime.from(dateTime, tz.local);

    try {
      await _flutterLocalNotificationsPlugin.zonedSchedule(
        id,
        title,
        body,
        tzDateNotification,
        NotificationDetails(
          android: _androidTimeNotificationDetails,
          iOS: _iOSTimeNotificationDetails,
        ),
        androidScheduleMode: AndroidScheduleMode.alarmClock,
        matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
      );
    } on PlatformException catch (e) {
      debugPrint("Error scheduling monthly notification: $e");
      if (e.code == 'exact_alarms_not_permitted') {
        await _flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tzDateNotification,
          NotificationDetails(
            android: _androidTimeNotificationDetails,
            iOS: _iOSTimeNotificationDetails,
          ),
          androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );
      }
    } catch (e) {
      debugPrint("Unknown error: $e");
    }
  }

  Future<void> cancelNotificationWithId(int id) async {
    await _flutterLocalNotificationsPlugin.cancel(id);
  }
}
