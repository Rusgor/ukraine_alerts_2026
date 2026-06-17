class AlertEntity {
  const AlertEntity({
    required this.id,
    required this.locationTitle,
    required this.locationType,
    required this.locationUid,
    required this.alertType,
    required this.startedAt,
    this.locationOblastUid,
  });

  final int id;
  final String locationTitle;
  final String locationType;
  final String locationUid;
  final String alertType;
  final DateTime startedAt;
  final int? locationOblastUid;
}
