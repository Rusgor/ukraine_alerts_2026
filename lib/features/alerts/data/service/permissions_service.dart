import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ua_air_alerts/features/alerts/data/service/notification_service.dart';

Future<void> requestAllPermissions() async {
  // Location
  var permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.denied) {
    await Geolocator.requestPermission();
  }

  // Notifications
  final notifications = await NotificationService.instance;

  // Android 13+
  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  // iOS
  await notifications
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, sound: true, badge: true);
}
