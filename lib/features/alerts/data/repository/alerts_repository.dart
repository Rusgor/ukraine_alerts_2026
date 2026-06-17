import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:ua_air_alerts/features/alerts/data/dto/alert_dto.dart';
import 'package:ua_air_alerts/features/alerts/data/entity/alert_entity.dart';
import 'package:ua_air_alerts/features/alerts/data/mapper/alert_mapper.dart';
import 'package:ua_air_alerts/features/alerts/data/repository/api_error.dart';

class AlertsRepository {
  AlertsRepository({CacheManager? cacheManager})
      : _cache = cacheManager ?? DefaultCacheManager();

  static const _baseUrl = 'https://api.alerts.in.ua';

  final CacheManager _cache;

  String get _token => dotenv.env['API_TOKEN'] ?? '';

  Future<List<AlertEntity>> getActiveAlerts() async {
    final data = await _fetchJson('/v1/alerts/active.json');
    final alerts = (data['alerts'] as List<dynamic>)
        .map((e) => AlertDto.fromJson(e as Map<String, dynamic>).toEntity())
        .toList();
    return alerts;
  }

  Future<String> getRegionAlertStatus(String uid) async {
    final url = '$_baseUrl/v1/iot/active_air_raid_alerts/$uid.json';
    final file = await _cache.getSingleFile(
      url,
      headers: _headers,
      key: 'region_$uid',
    );
    final body = await file.readAsString();
    final decoded = jsonDecode(body);
    if (decoded is String) return decoded;
    return decoded.toString();
  }

  Future<Map<String, dynamic>> _fetchJson(String path) async {
    final url = '$_baseUrl$path';
    final file = await _cache.getSingleFile(
      url,
      headers: _headers,
      key: path,
    );
    final body = await file.readAsString();
    final decoded = jsonDecode(body);
    if (decoded is Map<String, dynamic>) {
      if (decoded.containsKey('message') && !decoded.containsKey('alerts')) {
        throw ApiError(decoded['message'] as String);
      }
      return decoded;
    }
    throw ApiError('Unexpected response format');
  }

  Map<String, String> get _headers => {
        'Authorization': 'Bearer $_token',
      };
}
