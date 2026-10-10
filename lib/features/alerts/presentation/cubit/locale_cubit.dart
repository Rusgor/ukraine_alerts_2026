import 'dart:ui';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/core/settings/app_settings.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit(this._settings) : super(const Locale('uk'));

  static const _localeKey = 'app_locale';

  final AppSettings _settings;

  Future<void> load() async {
    try {
      final languageCode = await _settings.getString(_localeKey);
      if (languageCode == 'uk' || languageCode == 'en') {
        emit(Locale(languageCode!));
      }
    } on Exception {
      // Keep the default locale when preferences are unavailable.
    }
  }

  Future<void> setLocale(Locale locale) async {
    if (locale.languageCode != 'uk' && locale.languageCode != 'en') return;
    emit(locale);
    try {
      await _settings.setString(_localeKey, locale.languageCode);
    } on Exception {
      // The current session still uses the requested locale.
    }
  }

  Future<void> toggle() async {
    final locale = state.languageCode == 'uk'
        ? const Locale('en')
        : const Locale('uk');
    await setLocale(locale);
  }
}
