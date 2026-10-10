import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ua_air_alerts/features/alerts/data/mapper/alert_mapper.dart';

void main() {
  group('AlertDto', () {
    test('parses a valid payload and maps it to an entity', () {
      final dto = AlertDto.fromJson(_validPayload);
      final entity = dto.toEntity();

      expect(dto.id, 42);
      expect(entity.locationUid, '14');
      expect(entity.startedAt, DateTime.utc(2026, 10, 10, 12));
    });

    test('rejects a payload missing required fields', () {
      expect(() => AlertDto.fromJson({'id': 42}), throwsA(isA<TypeError>()));
    });

    test('rejects fields with an unexpected type', () {
      expect(
        () => AlertDto.fromJson({..._validPayload, 'location_uid': 14}),
        throwsA(isA<TypeError>()),
      );
    });

    test('rejects an invalid timestamp when mapping', () {
      final dto = AlertDto.fromJson({
        ..._validPayload,
        'started_at': 'invalid',
      });

      expect(dto.toEntity, throwsFormatException);
    });
  });
}

const _validPayload = <String, dynamic>{
  'id': 42,
  'location_title': 'Київська область',
  'location_type': 'oblast',
  'started_at': '2026-10-10T12:00:00Z',
  'alert_type': 'air_raid',
  'location_uid': '14',
};
