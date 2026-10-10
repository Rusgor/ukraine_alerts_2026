import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/core/settings/app_settings.dart';
import 'package:ua_air_alerts/features/alerts/data/constants.dart';
import 'package:ua_air_alerts/features/alerts/domain/alerts_gateway.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/api_error.dart';
import 'package:ua_air_alerts/features/alerts/data/service/background_alert_service.dart';
import 'package:ua_air_alerts/features/alerts/data/service/region_location_service.dart';
import 'package:ua_air_alerts/features/alerts/domain/alert_status.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/region_alerts_state.dart';

class RegionAlertsCubit extends Cubit<RegionAlertsState> {
  RegionAlertsCubit(this._repository, this._settings, this._locationService)
    : super(const RegionAlertsInitial());

  final AlertsGateway _repository;
  final AppSettings _settings;
  final RegionLocationService _locationService;
  DateTime? _lastRefresh;

  String? get currentUid => state.selectedUid;

  bool get isMyRegion => state.isMyRegion;

  bool get canRefresh {
    if (_lastRefresh == null) return true;
    return DateTime.now().difference(_lastRefresh!) >
        const Duration(seconds: 30);
  }

  Future<void> init() async {
    final myRegionUid = await _settings.getString(StorageKeys.myRegionUid);
    final selectedUid = await _settings.getString(StorageKeys.savedRegionUid);
    final monitoringEnabled = myRegionUid != null
        ? await startBackgroundMonitoring(requestPermission: false)
        : false;

    emit(
      RegionAlertsInitial(
        selectedUid: selectedUid,
        myRegionUid: myRegionUid,
        monitoringEnabled: monitoringEnabled,
      ),
    );
    if (selectedUid != null) await checkAlert(selectedUid);
  }

  Future<void> checkAlert(String uid, {bool forceRefresh = false}) async {
    final currentState = state;
    final previousAlert = switch (currentState) {
      RegionAlertsLoaded(:final isAlert) => isAlert,
      RegionAlertsLoading(:final previousAlert) => previousAlert,
      _ => null,
    };
    final monitoringEnabled = currentState.monitoringEnabled;
    final myRegionUid = currentState.myRegionUid;

    emit(
      RegionAlertsLoading(
        previousAlert: previousAlert,
        selectedUid: uid,
        myRegionUid: myRegionUid,
        monitoringEnabled: monitoringEnabled,
      ),
    );

    try {
      await _settings.setString(StorageKeys.savedRegionUid, uid);
      final status = await _repository.getRegionAlertStatus(
        uid,
        forceRefresh: forceRefresh,
      );

      final alertStatus = AlertStatus.parse(status);
      if (alertStatus == AlertStatus.unknown) {
        throw ApiError('Unable to determine the alert status');
      }

      if (alertStatus.hasAlert) {
        final alerts = await _repository.getActiveAlerts(
          forceRefresh: forceRefresh,
        );
        final match = alerts
            .where((alert) => alert.locationUid == uid)
            .firstOrNull;
        emit(
          RegionAlertsLoaded(
            isAlert: true,
            alertType: match?.alertType,
            selectedUid: uid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
      } else {
        emit(
          RegionAlertsLoaded(
            isAlert: false,
            selectedUid: uid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
      }
    } on ApiError {
      emit(
        RegionAlertsError(
          '',
          selectedUid: uid,
          myRegionUid: myRegionUid,
          monitoringEnabled: monitoringEnabled,
        ),
      );
    } on Exception {
      emit(
        RegionAlertsError(
          '',
          selectedUid: uid,
          myRegionUid: myRegionUid,
          monitoringEnabled: monitoringEnabled,
        ),
      );
    }
  }

  Future<void> refresh() async {
    final uid = state.selectedUid;
    if (uid != null && canRefresh) {
      _lastRefresh = DateTime.now();
      await checkAlert(uid, forceRefresh: true);
    }
  }

  void clearSelection() {
    final currentState = state;
    emit(
      RegionAlertsInitial(
        myRegionUid: currentState.myRegionUid,
        monitoringEnabled: currentState.monitoringEnabled,
      ),
    );
  }

  Future<bool> toggleMyRegion() async {
    final uid = state.selectedUid;
    if (uid == null) return false;

    try {
      if (state.isMyRegion) {
        if (!await stopBackgroundMonitoring()) return false;
        await _settings.remove(StorageKeys.myRegionUid);
        _emitWithMonitoring(myRegionUid: null, monitoringEnabled: false);
        return true;
      }

      await _settings.setString(StorageKeys.myRegionUid, uid);
      final started = await startBackgroundMonitoring();
      if (!started) {
        await _settings.remove(StorageKeys.myRegionUid);
        _emitWithMonitoring(myRegionUid: null, monitoringEnabled: false);
        return false;
      }
      _emitWithMonitoring(myRegionUid: uid, monitoringEnabled: true);
      return true;
    } on Exception {
      return false;
    }
  }

  Future<void> detectRegionFromLocation() async {
    try {
      final uid = await _locationService.detectRegionUid();
      if (uid == null) {
        _emitError();
        return;
      }
      await checkAlert(uid);
    } on Exception {
      _emitError();
    }
  }

  void _emitError() {
    final currentState = state;
    emit(
      RegionAlertsError(
        '',
        selectedUid: currentState.selectedUid,
        myRegionUid: currentState.myRegionUid,
        monitoringEnabled: currentState.monitoringEnabled,
      ),
    );
  }

  void _emitWithMonitoring({
    required String? myRegionUid,
    required bool monitoringEnabled,
  }) {
    final currentState = state;
    switch (currentState) {
      case RegionAlertsLoaded(:final isAlert, :final alertType):
        emit(
          RegionAlertsLoaded(
            isAlert: isAlert,
            alertType: alertType,
            selectedUid: currentState.selectedUid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
      case RegionAlertsLoading(:final previousAlert):
        emit(
          RegionAlertsLoading(
            previousAlert: previousAlert,
            selectedUid: currentState.selectedUid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
      case RegionAlertsError(:final message):
        emit(
          RegionAlertsError(
            message,
            selectedUid: currentState.selectedUid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
      case RegionAlertsInitial():
        emit(
          RegionAlertsInitial(
            selectedUid: currentState.selectedUid,
            myRegionUid: myRegionUid,
            monitoringEnabled: monitoringEnabled,
          ),
        );
    }
  }
}
