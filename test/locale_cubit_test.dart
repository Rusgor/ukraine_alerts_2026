import 'dart:ui';

import 'package:flutter_test/flutter_test.dart';
import 'package:ua_air_alerts/core/settings/app_settings.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/locale_cubit.dart';

void main() {
  late _FakeAppSettings settings;
  late LocaleCubit cubit;

  setUp(() {
    settings = _FakeAppSettings();
    cubit = LocaleCubit(settings);
  });

  tearDown(() async => cubit.close());

  test('restores the previously selected supported locale', () async {
    settings.values['app_locale'] = 'en';

    await cubit.load();

    expect(cubit.state, const Locale('en'));
  });

  test('persists a supported locale change', () async {
    await cubit.setLocale(const Locale('uk'));

    expect(cubit.state, const Locale('uk'));
    expect(settings.values['app_locale'], 'uk');
  });

  test('ignores unsupported locale changes', () async {
    await cubit.setLocale(const Locale('fr'));

    expect(cubit.state, const Locale('uk'));
    expect(settings.values, isEmpty);
  });
}

class _FakeAppSettings implements AppSettings {
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
