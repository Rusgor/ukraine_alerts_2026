import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';

sealed class AlertsMapState {}

final class AlertsMapLoading implements AlertsMapState {}

final class AlertsMapLoaded implements AlertsMapState {
  AlertsMapLoaded(this.alerts);

  final List<AlertEntity> alerts;
}

final class AlertsMapError implements AlertsMapState {
  AlertsMapError(this.message);

  final String message;
}
