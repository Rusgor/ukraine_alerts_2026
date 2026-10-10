// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Ukrainian (`uk`).
class AppLocalizationsUk extends AppLocalizations {
  AppLocalizationsUk([String locale = 'uk']) : super(locale);

  @override
  String get alertsMap => 'Карта тривог';

  @override
  String get regionAlerts => 'Тривоги регіону';

  @override
  String get selectRegion => 'Оберіть місто або регіон';

  @override
  String get noAlert => 'Немає тривоги';

  @override
  String get alertActive =>
      'Повітряна тривога!\nБудь ласка, пройдіть до укриття';

  @override
  String get refresh => 'Оновити';

  @override
  String get errorLoading => 'Помилка завантаження';

  @override
  String get retry => 'Спробувати знову';

  @override
  String get myRegion => 'Моя область';

  @override
  String get detectMyRegion => 'Визначити область за місцезнаходженням';

  @override
  String get backgroundMonitoringActive =>
      'Фоновий моніторинг увімкнено. Доставка залежить від планувальника операційної системи.';

  @override
  String get backgroundMonitoringUnavailable =>
      'Фоновий моніторинг недоступний на цьому пристрої.';

  @override
  String get myRegionSaved => 'Слідкую за цією областю';

  @override
  String get myRegionRemoved => 'Більше не слідкую';

  @override
  String get alertTypeAirRaid => 'Повітряна тривога';

  @override
  String get alertTypeArtillery => 'Загроза артилерійського обстрілу';

  @override
  String get alertTypeUrbanFights => 'Вуличні бої';

  @override
  String get alertTypeChemical => 'Хімічна загроза';

  @override
  String get alertTypeNuclear => 'Ядерна загроза';

  @override
  String get alertTypeUnknown => 'Загроза';

  @override
  String get alertShelter => 'Будь ласка, пройдіть до укриття';

  @override
  String get alertChemicalShelter => 'Герметизуйте приміщення!';

  @override
  String get alertNuclearShelter => 'Негайно до укриття!';

  @override
  String get starTooltip =>
      'Натисніть ★ щоб слідкувати за тривогами у цьому регіоні навіть коли додаток згорнутий';
}
