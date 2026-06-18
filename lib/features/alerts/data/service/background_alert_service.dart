import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/features/alerts/data/service/notification_service.dart';
import 'package:workmanager/workmanager.dart';

const _taskName = 'checkAlertTask';
const _taskId = 'alertCheck';
const _baseUrl = 'https://api.alerts.in.ua';

Future<void> initBackgroundService() async {
  try {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
  } catch (_) {
    // Workmanager not supported (e.g. iOS simulator)
  }
}

Future<void> startBackgroundMonitoring() async {
  try {
    await Workmanager().registerPeriodicTask(
      _taskId,
      _taskName,
      frequency: const Duration(minutes: 5),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
  } catch (_) {
    // Workmanager not supported
  }
}

Future<void> stopBackgroundMonitoring() async {
  try {
    await Workmanager().cancelByUniqueName(_taskId);
  } catch (_) {
    // Workmanager not supported
  }
}

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    if (task == _taskName) {
      await _checkAndNotify();
    }
    return true;
  });
}

Future<void> _checkAndNotify() async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString(StorageKeys.myRegionUid);
  if (uid == null) return;

  final token = prefs.getString(StorageKeys.apiToken) ?? '';
  if (token.isEmpty) return;

  try {
    final response = await http.get(
      Uri.parse('$_baseUrl/v1/iot/active_air_raid_alerts/$uid.json'),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response.statusCode != 200) return;

    final body = jsonDecode(response.body);
    final status = body is String ? body : body.toString();
    final isAlert = status.contains('A');
    final wasAlert = prefs.getBool(StorageKeys.lastAlertState) ?? false;

    await prefs.setBool(StorageKeys.lastAlertState, isAlert);

    if (isAlert && !wasAlert) {
      await _showNotification();
      await _playAlarm();
    }
  } on Exception {
    // Silent fail in background
  }
}

Future<void> _showNotification() async {
  final plugin = await NotificationService.instance;

  // Request permission on iOS
  await plugin
      .resolvePlatformSpecificImplementation<
          IOSFlutterLocalNotificationsPlugin>()
      ?.requestPermissions(alert: true, sound: true, badge: true);

  // Request permission on Android 13+
  await plugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.requestNotificationsPermission();

  await plugin.show(
    0,
    'Повітряна тривога!',
    'Будь ласка, пройдіть до укриття',
    const NotificationDetails(
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentSound: true,
      ),
      android: AndroidNotificationDetails(
        'air_raid_channel',
        'Air Raid Alerts',
        importance: Importance.max,
        priority: Priority.high,
      ),
    ),
  );
}

Future<void> _playAlarm() async {
  final player = AudioPlayer();
  await player.play(AssetSource('sounds/alarm.mp3'));
}
