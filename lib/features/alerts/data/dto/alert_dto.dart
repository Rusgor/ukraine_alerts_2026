import 'package:json_annotation/json_annotation.dart';

part 'alert_dto.g.dart';

@JsonSerializable()
class AlertDto {
  AlertDto({
    required this.id,
    required this.locationTitle,
    required this.locationType,
    required this.startedAt,
    required this.alertType,
    required this.locationUid,
    this.finishedAt,
    this.updatedAt,
    this.locationOblast,
    this.locationOblastUid,
    this.locationRaion,
    this.notes,
    this.calculated,
  });

  factory AlertDto.fromJson(Map<String, dynamic> json) =>
      _$AlertDtoFromJson(json);

  final int id;
  @JsonKey(name: 'location_title')
  final String locationTitle;
  @JsonKey(name: 'location_type')
  final String locationType;
  @JsonKey(name: 'started_at')
  final String startedAt;
  @JsonKey(name: 'finished_at')
  final String? finishedAt;
  @JsonKey(name: 'updated_at')
  final String? updatedAt;
  @JsonKey(name: 'alert_type')
  final String alertType;
  @JsonKey(name: 'location_uid')
  final String locationUid;
  @JsonKey(name: 'location_oblast')
  final String? locationOblast;
  @JsonKey(name: 'location_oblast_uid')
  final int? locationOblastUid;
  @JsonKey(name: 'location_raion')
  final String? locationRaion;
  final String? notes;
  final bool? calculated;

  Map<String, dynamic> toJson() => _$AlertDtoToJson(this);
}
