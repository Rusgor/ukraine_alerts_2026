sealed class RegionAlertsState {
  const RegionAlertsState({
    this.selectedUid,
    this.myRegionUid,
    this.monitoringEnabled = false,
  });

  final String? selectedUid;
  final String? myRegionUid;
  final bool monitoringEnabled;

  bool get isMyRegion => selectedUid != null && selectedUid == myRegionUid;
}

final class RegionAlertsInitial extends RegionAlertsState {
  const RegionAlertsInitial({
    super.selectedUid,
    super.myRegionUid,
    super.monitoringEnabled,
  });
}

final class RegionAlertsLoading extends RegionAlertsState {
  const RegionAlertsLoading({
    this.previousAlert,
    super.selectedUid,
    super.myRegionUid,
    super.monitoringEnabled,
  });

  final bool? previousAlert;
}

final class RegionAlertsLoaded extends RegionAlertsState {
  const RegionAlertsLoaded({
    required this.isAlert,
    this.alertType,
    super.selectedUid,
    super.myRegionUid,
    super.monitoringEnabled,
  });

  final bool isAlert;
  final String? alertType;
}

final class RegionAlertsError extends RegionAlertsState {
  const RegionAlertsError(
    this.message, {
    super.selectedUid,
    super.myRegionUid,
    super.monitoringEnabled,
  });

  final String message;
}
