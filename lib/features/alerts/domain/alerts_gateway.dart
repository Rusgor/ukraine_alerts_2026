import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';

abstract interface class AlertsGateway {
  Future<List<AlertEntity>> getActiveAlerts({bool forceRefresh = false});

  Future<String> getRegionAlertStatus(String uid, {bool forceRefresh = false});
}
