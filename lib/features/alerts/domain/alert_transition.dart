import 'package:ua_air_alerts/features/alerts/domain/alert_status.dart';

bool shouldNotifyForStatus(AlertStatus status, {required bool wasAlert}) =>
    status.hasAlert && !wasAlert;
