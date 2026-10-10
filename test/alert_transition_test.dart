import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_status.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_transition.dart';

void main() {
  test('notifies on the first confirmed active or partial status', () {
    expect(shouldNotifyForStatus(AlertStatus.active, wasAlert: false), isTrue);
    expect(shouldNotifyForStatus(AlertStatus.partial, wasAlert: false), isTrue);
  });

  test('does not repeat notifications or notify for inactive/unknown', () {
    expect(shouldNotifyForStatus(AlertStatus.active, wasAlert: true), isFalse);
    expect(
      shouldNotifyForStatus(AlertStatus.inactive, wasAlert: true),
      isFalse,
    );
    expect(
      shouldNotifyForStatus(AlertStatus.unknown, wasAlert: false),
      isFalse,
    );
  });
}
