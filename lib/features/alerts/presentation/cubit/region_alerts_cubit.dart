import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/oblast_assets.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/api_error.dart';
import 'package:ua_air_alerts/features/alerts/data/service/background_alert_service.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';

class RegionAlertsCubit extends Cubit<RegionAlertsState> {
  RegionAlertsCubit(this._repository) : super(RegionAlertsInitial());

  final AlertsRepository _repository;

  String? _currentUid;
  String? _myRegionUid;
  DateTime? _lastRefresh;

  String? get currentUid => _currentUid;

  bool get isMyRegion => _currentUid != null && _currentUid == _myRegionUid;

  bool get canRefresh {
    if (_lastRefresh == null) return true;
    return DateTime.now().difference(_lastRefresh!) >
        const Duration(seconds: 30);
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _myRegionUid = prefs.getString(StorageKeys.myRegionUid);
    if (_myRegionUid != null) {
      startBackgroundMonitoring();
    }
    final savedUid = prefs.getString(StorageKeys.savedRegionUid);
    if (savedUid != null) {
      _currentUid = savedUid;
      await checkAlert(savedUid);
    } else {
      await _tryAutoDetectRegion();
    }
  }

  Future<void> checkAlert(String uid, {bool forceRefresh = false}) async {
    final bool? prevAlert = state is RegionAlertsLoaded
        ? (state as RegionAlertsLoaded).isAlert
        : null;

    emit(RegionAlertsLoading(previousAlert: prevAlert));
    _currentUid = uid;
    await _saveSelectedRegion(uid);

    try {
      final status = await _repository.getRegionAlertStatus(
        uid,
        forceRefresh: forceRefresh,
      );

      if (status.contains('A')) {
        final alerts = await _repository.getActiveAlerts(
          forceRefresh: forceRefresh,
        );
        final match = alerts.where((a) => a.locationUid == uid).firstOrNull;
        emit(RegionAlertsLoaded(isAlert: true, alertType: match?.alertType));
      } else {
        emit(RegionAlertsLoaded(isAlert: false));
      }
    } on ApiError catch (e) {
      emit(RegionAlertsError(e.message));
    } on Exception catch (e) {
      emit(RegionAlertsError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (_currentUid != null && canRefresh) {
      _lastRefresh = DateTime.now();
      await checkAlert(_currentUid!, forceRefresh: true);
    }
  }

  void clearSelection() {
    _currentUid = null;
    emit(RegionAlertsInitial());
  }

  Future<void> toggleMyRegion() async {
    if (_currentUid == null) return;
    final prefs = await SharedPreferences.getInstance();
    if (isMyRegion) {
      _myRegionUid = null;
      await prefs.remove(StorageKeys.myRegionUid);
      stopBackgroundMonitoring();
    } else {
      _myRegionUid = _currentUid;
      await prefs.setString(StorageKeys.myRegionUid, _currentUid!);
      startBackgroundMonitoring();
    }
    // Re-emit current state to trigger UI rebuild
    final current = state;
    if (current is RegionAlertsLoaded) {
      emit(
        RegionAlertsLoaded(
          isAlert: current.isAlert,
          alertType: current.alertType,
        ),
      );
    }
  }

  Future<void> _saveSelectedRegion(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(StorageKeys.savedRegionUid, uid);
  }

  Future<void> _tryAutoDetectRegion() async {
    try {
      final permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        final requested = await Geolocator.requestPermission();

        if (requested == LocationPermission.denied ||
            requested == LocationPermission.deniedForever) {
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.low,
          timeLimit: Duration(seconds: 5),
        ),
      );

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isEmpty) return;

      final region = placemarks.first.administrativeArea ?? '';
      final uid = _matchRegionToUid(region);

      if (uid != null) {
        _currentUid = uid;
        await checkAlert(uid);
      }
    } on Exception {
      // GPS/РЕБ issues — silently fallback to manual selection
    }
  }

  String? _matchRegionToUid(String region) {
    final lower = region.toLowerCase();
    for (final entry in oblastAssetMap.entries) {
      final oblastName = _uidToUkrainianName[entry.key]?.toLowerCase() ?? '';
      if (oblastName.isNotEmpty &&
          lower.contains(oblastName.split(' ').first)) {
        return entry.key;
      }
    }
    return null;
  }
}

const _uidToUkrainianName = <String, String>{
  '3': 'Хмельницька',
  '4': 'Вінницька',
  '5': 'Рівненська',
  '8': 'Волинська',
  '9': 'Дніпропетровська',
  '10': 'Житомирська',
  '11': 'Закарпатська',
  '12': 'Запорізька',
  '13': 'Івано-Франківська',
  '14': 'Київська',
  '15': 'Кіровоградська',
  '16': 'Луганська',
  '17': 'Миколаївська',
  '18': 'Одеська',
  '19': 'Полтавська',
  '20': 'Сумська',
  '21': 'Тернопільська',
  '22': 'Харківська',
  '23': 'Херсонська',
  '24': 'Черкаська',
  '25': 'Чернігівська',
  '26': 'Чернівецька',
  '27': 'Львівська',
  '28': 'Донецька',
  '29': 'Крим',
  '30': 'Севастополь',
  '31': 'Київ',
};
