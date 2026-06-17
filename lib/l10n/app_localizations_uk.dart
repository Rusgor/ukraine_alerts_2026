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
}
