import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:ua_air_alerts/features/alerts/data/service/notification_service.dart';

Future<bool> requestNotificationPermission() async {
  final notifications = await NotificationService.instance;
  final androidGranted = await notifications
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
      ?.requestNotificationsPermission();
  final iosGranted = await notifications
      .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin
      >()
      ?.requestPermissions(alert: true, sound: true, badge: true);

  return (androidGranted ?? true) && (iosGranted ?? true);
}
