// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get alertsMap => 'Alerts Map';

  @override
  String get regionAlerts => 'Region Alerts';

  @override
  String get selectRegion => 'Select city or region';

  @override
  String get noAlert => 'No alert';

  @override
  String get alertActive => 'Air raid alert!\nPlease proceed to shelter';

  @override
  String get refresh => 'Refresh';

  @override
  String get errorLoading => 'Loading error';

  @override
  String get retry => 'Try again';

  @override
  String get myRegion => 'My region';
}
