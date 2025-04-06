import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'hive_helper.dart';

class NotificationHelper {
  static final FlutterLocalNotificationsPlugin _notificationsPlugin =
      FlutterLocalNotificationsPlugin();
  static late List<Map<String, dynamic>> notificationData;

  static const int morningNotificationIdBase = 1000; // Base ID for morning
  static const int eveningNotificationIdBase = 2000; // Base ID for evening

  static Future<void> initialize() async {
      notificationData = HiveHelper.getNotificationData();
      tz.initializeTimeZones();

      const AndroidInitializationSettings androidSettings =
          AndroidInitializationSettings('@mipmap/ic_launcher');

      const DarwinInitializationSettings iOSSettings =
          DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const InitializationSettings settings = InitializationSettings(
        android: androidSettings,
        iOS: iOSSettings,
      );

      await _notificationsPlugin.initialize(settings);
      await _createNotificationChannel();

  }

  static Future<void> _createNotificationChannel() async {
    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'channel_id',
      'channel_name',
      description: 'Channel for daily notifications',
      importance: Importance.high,
    );

    await _notificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel);
  }

  static Future<void> requestPermissions() async {
    final androidPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();
    final iOSPlugin =
        _notificationsPlugin.resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>();

    await iOSPlugin?.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );

    await androidPlugin?.requestNotificationsPermission();

    await androidPlugin?.requestExactAlarmsPermission();
  }

  static String _getNotificationBody() {
    if ( notificationData.isNotEmpty) {
      return notificationData.map((data) {
        return 'Plant: ${data['common_name']}, '
            'Sunlight: ${data['sunlight_duration']} hours/day, '
            'Watering: ${data['average_watering_period']['value']} '
            '${data['average_watering_period']['unit']}';
      }).join('\n');
    }
    return '';
  }

  /// Schedules daily notifications at 8 AM and 8 PM until stopped.
  static Future<void> startDailyNotifications() async {
    // Cancel any existing scheduled notifications to avoid duplicates
    await cancelDailyNotifications();

    // Schedule notifications for the next 30 days (or adjust as needed)
    await _scheduleNotificationsForPeriod();
  }

  /// Cancels all scheduled daily notifications.
  static Future<void> cancelDailyNotifications() async {
      for (int i = 0; i < 30; i++) {
        await _notificationsPlugin.cancel(morningNotificationIdBase + i);
        await _notificationsPlugin.cancel(eveningNotificationIdBase + i);
      }
  }

  static Future<void> _scheduleNotificationsForPeriod() async {
    const AndroidNotificationDetails androidDetails =
        AndroidNotificationDetails(
      'channel_id',
      'channel_name',
      importance: Importance.high,
      priority: Priority.high,
      channelDescription: 'Channel for daily notifications',
    );

    const DarwinNotificationDetails iOSDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const NotificationDetails details = NotificationDetails(
      android: androidDetails,
      iOS: iOSDetails,
    );

    final now = tz.TZDateTime.now(tz.local);
    final String body = _getNotificationBody();
    for (int i = 0; i < 30; i++) {
      // Schedule morning notification (8 AM)
      final morningDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        8,
      ).add(Duration(days: i));

      if (morningDate.isAfter(now)) {
        await _notificationsPlugin.zonedSchedule(
          morningNotificationIdBase + i,
          "Good Morning!",
          body,
          morningDate,
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }

      // Schedule evening notification (8 PM)
      final eveningDate = tz.TZDateTime(
        tz.local,
        now.year,
        now.month,
        now.day,
        20, // 8 PM
      ).add(Duration(days: i));

      if (eveningDate.isAfter(now)) {
        await _notificationsPlugin.zonedSchedule(
          eveningNotificationIdBase + i,
          "Good Evening!",
          _getNotificationBody(),
          eveningDate,
          details,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        );
      }
    }

    // Fallback for exact alarms not permitted
    await _notificationsPlugin.pendingNotificationRequests();
  }
}
