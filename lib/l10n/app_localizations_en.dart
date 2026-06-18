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

  @override
  String get myRegionSaved => 'Tracking this region';

  @override
  String get myRegionRemoved => 'No longer tracking';

  @override
  String get alertTypeAirRaid => 'Air raid alert';

  @override
  String get alertTypeArtillery => 'Artillery shelling threat';

  @override
  String get alertTypeUrbanFights => 'Urban fights';

  @override
  String get alertTypeChemical => 'Chemical threat';

  @override
  String get alertTypeNuclear => 'Nuclear threat';

  @override
  String get alertTypeUnknown => 'Threat';

  @override
  String get alertShelter => 'Please proceed to shelter';

  @override
  String get alertChemicalShelter => 'Seal the premises!';

  @override
  String get alertNuclearShelter => 'Immediately to shelter!';

  @override
  String get starTooltip =>
      'Tap ★ to track alerts in this region even when the app is minimized';
}
