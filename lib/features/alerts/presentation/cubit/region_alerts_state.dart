sealed class RegionAlertsState {}

final class RegionAlertsInitial implements RegionAlertsState {}

final class RegionAlertsLoading implements RegionAlertsState {
  RegionAlertsLoading({this.previousAlert});

  final bool? previousAlert;
}

final class RegionAlertsLoaded implements RegionAlertsState {
  RegionAlertsLoaded({required this.isAlert, this.alertType});

  final bool isAlert;
  final String? alertType;
}

final class RegionAlertsError implements RegionAlertsState {
  RegionAlertsError(this.message);

  final String message;
}
