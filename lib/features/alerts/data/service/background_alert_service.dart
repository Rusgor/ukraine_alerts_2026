import 'dart:convert';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/features/alerts/data/service/notification_service.dart';
import 'package:ua_air_alerts/features/alerts/data/service/permissions_service.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_status.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_transition.dart';
import 'package:workmanager/workmanager.dart';

const _taskName = 'checkAlertTask';
const _taskId = 'alertCheck';
const _baseUrl = 'https://api.alerts.in.ua';

bool _backgroundServiceInitialized = false;

Future<bool> initBackgroundService() async {
  if (_backgroundServiceInitialized) return true;
  try {
    await Workmanager().initialize(callbackDispatcher, isInDebugMode: false);
    _backgroundServiceInitialized = true;
    return true;
  } on Exception {
    return false;
  }
}

Future<bool> startBackgroundMonitoring({bool requestPermission = true}) async {
  final prefs = await SharedPreferences.getInstance();
  final uid = prefs.getString(StorageKeys.myRegionUid);
  final token = prefs.getString(StorageKeys.apiToken);
  if (uid == null || token == null || token.isEmpty) return false;

  if (!await initBackgroundService()) return false;
  if (requestPermission && !await requestNotificationPermission()) {
    return false;
  }
  try {
    await Workmanager().registerPeriodicTask(
      _taskId,
      _taskName,
      frequency: const Duration(minutes: 15),
      constraints: Constraints(networkType: NetworkType.connected),
      existingWorkPolicy: ExistingWorkPolicy.replace,
    );
    return true;
  } on Exception {
    return false;
  }
}

Future<bool> stopBackgroundMonitoring() async {
  if (!await initBackgroundService()) return false;
  try {
    await Workmanager().cancelByUniqueName(_taskId);
    return true;
  } on Exception {
    return false;
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

    final status = AlertStatus.parse(jsonDecode(response.body));
    if (status == AlertStatus.unknown) return;

    final isAlert = status.hasAlert;
    final wasAlert = prefs.getBool(StorageKeys.lastAlertState) ?? false;

    await prefs.setBool(StorageKeys.lastAlertState, isAlert);

    if (shouldNotifyForStatus(status, wasAlert: wasAlert)) {
      await _showNotification();
      await _playAlarm();
    }
  } on Exception {
    // Silent fail in background
  }
}

Future<void> _showNotification() async {
  final plugin = await NotificationService.instance;

  await plugin.show(
    0,
    'Повітряна тривога!',
    'Будь ласка, пройдіть до укриття',
    const NotificationDetails(
      iOS: DarwinNotificationDetails(presentAlert: true, presentSound: true),
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
