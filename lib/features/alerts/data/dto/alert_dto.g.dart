// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alert_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlertDto _$AlertDtoFromJson(Map<String, dynamic> json) => AlertDto(
  id: (json['id'] as num).toInt(),
  locationTitle: json['location_title'] as String,
  locationType: json['location_type'] as String,
  locationUid: json['location_uid'] as String,
  alertType: json['alert_type'] as String,
  startedAt: json['started_at'] as String,
  finishedAt: json['finished_at'] as String?,
  locationOblast: json['location_oblast'] as String?,
  locationOblastUid: json['location_oblast_uid'] as String?,
);

Map<String, dynamic> _$AlertDtoToJson(AlertDto instance) => <String, dynamic>{
  'id': instance.id,
  'location_title': instance.locationTitle,
  'location_type': instance.locationType,
  'location_uid': instance.locationUid,
  'alert_type': instance.alertType,
  'started_at': instance.startedAt,
  'finished_at': instance.finishedAt,
  'location_oblast': instance.locationOblast,
  'location_oblast_uid': instance.locationOblastUid,
};
