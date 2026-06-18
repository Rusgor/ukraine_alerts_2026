import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/alerts_repository.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/api_error.dart';
import 'package:ua_air_alerts/features/alerts/presentation/cubit/alerts_map_state.dart';

class AlertsMapCubit extends Cubit<AlertsMapState> {
  AlertsMapCubit(this._repository) : super(AlertsMapLoading());

  final AlertsRepository _repository;
  DateTime? _lastRefresh;

  bool get canRefresh {
    if (_lastRefresh == null) return true;
    return DateTime.now().difference(_lastRefresh!) >
        const Duration(seconds: 30);
  }

  Future<void> loadAlerts({bool forceRefresh = false}) async {
    emit(AlertsMapLoading());
    try {
      final alerts =
          await _repository.getActiveAlerts(forceRefresh: forceRefresh);
      final oblastAlerts =
          alerts.where((a) => a.locationType == 'oblast').toList();
      emit(AlertsMapLoaded(oblastAlerts));
    } on ApiError catch (e) {
      emit(AlertsMapError(e.message));
    } on Exception catch (e) {
      emit(AlertsMapError(e.toString()));
    }
  }

  Future<void> refresh() async {
    if (canRefresh) {
      _lastRefresh = DateTime.now();
      await loadAlerts(forceRefresh: true);
    }
  }
}
