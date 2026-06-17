import 'package:ua_air_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';

extension AlertDtoMapper on AlertDto {
  AlertEntity toEntity() {
    return AlertEntity(
      id: id,
      locationTitle: locationTitle,
      locationType: locationType,
      locationUid: locationUid,
      alertType: alertType,
      startedAt: DateTime.parse(startedAt),
      locationOblastUid: locationOblastUid,
    );
  }
}
