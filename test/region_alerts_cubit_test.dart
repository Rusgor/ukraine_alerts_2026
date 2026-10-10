import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/core/settings/app_settings.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/data/service/region_location_service.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_cubit.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';

void main() {
  late _FakeRepository repository;
  late _FakeSettings settings;
  late RegionAlertsCubit cubit;

  setUp(() {
    repository = _FakeRepository();
    settings = _FakeSettings();
    cubit = RegionAlertsCubit(repository, settings, const _FakeLocation());
  });

  tearDown(() async => cubit.close());

  test('emits loading then success for an active status', () async {
    repository.status = 'A';
    repository.alerts = [_alert('14')];
    final emitted = <RegionAlertsState>[];
    final subscription = cubit.stream.listen(emitted.add);

    await cubit.checkAlert('14');
    await Future<void>.delayed(Duration.zero);

    expect(emitted, hasLength(2));
    expect(emitted.first, isA<RegionAlertsLoading>());
    expect(emitted.last, isA<RegionAlertsLoaded>());
    final loaded = emitted.last as RegionAlertsLoaded;
    expect(loaded.isAlert, isTrue);
    expect(loaded.alertType, 'air_raid');
    expect(loaded.selectedUid, '14');
    expect(settings.values['saved_region_uid'], '14');
    await subscription.cancel();
  });

  test('unknown status is an error, not a confirmed all-clear', () async {
    repository.status = 'unexpected';

    await cubit.checkAlert('14');

    expect(cubit.state, isA<RegionAlertsError>());
    expect(repository.activeAlertsRequests, 0);
  });

  test('inactive status emits a confirmed no-alert state', () async {
    repository.status = 'N';

    await cubit.checkAlert('14');

    expect(cubit.state, isA<RegionAlertsLoaded>());
    expect((cubit.state as RegionAlertsLoaded).isAlert, isFalse);
  });
}

class _FakeRepository implements AlertsRepository {
  String status = 'N';
  List<AlertEntity> alerts = const [];
  int activeAlertsRequests = 0;

  @override
  Future<List<AlertEntity>> getActiveAlerts({bool forceRefresh = false}) async {
    activeAlertsRequests++;
    return alerts;
  }

  @override
  Future<String> getRegionAlertStatus(
    String uid, {
    bool forceRefresh = false,
  }) async => status;
}

class _FakeSettings implements AppSettings {
  final values = <String, String>{};

  @override
  Future<String?> getString(String key) async => values[key];

  @override
  Future<void> remove(String key) async => values.remove(key);

  @override
  Future<void> setString(String key, String value) async {
    values[key] = value;
  }
}

class _FakeLocation implements RegionLocationService {
  const _FakeLocation();

  @override
  Future<String?> detectRegionUid() async => null;
}

AlertEntity _alert(String uid) => AlertEntity(
  id: 1,
  locationTitle: 'Київська область',
  locationType: 'oblast',
  locationUid: uid,
  alertType: 'air_raid',
  startedAt: DateTime.utc(2026),
);
