import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_status.dart';

void main() {
  group('AlertStatus.parse', () {
    test('recognizes active, partial, and inactive statuses', () {
      expect(AlertStatus.parse('A'), AlertStatus.active);
      expect(AlertStatus.parse('P'), AlertStatus.partial);
      expect(AlertStatus.parse('N'), AlertStatus.inactive);
    });

    test('normalizes whitespace and case', () {
      expect(AlertStatus.parse(' a '), AlertStatus.active);
    });

    test('returns unknown for unsupported and malformed values', () {
      expect(AlertStatus.parse('alarm'), AlertStatus.unknown);
      expect(AlertStatus.parse(''), AlertStatus.unknown);
      expect(AlertStatus.parse(null), AlertStatus.unknown);
      expect(AlertStatus.parse(1), AlertStatus.unknown);
    });

    test('only active and partial statuses indicate an alert', () {
      expect(AlertStatus.active.hasAlert, isTrue);
      expect(AlertStatus.partial.hasAlert, isTrue);
      expect(AlertStatus.inactive.hasAlert, isFalse);
      expect(AlertStatus.unknown.hasAlert, isFalse);
    });
  });
}
