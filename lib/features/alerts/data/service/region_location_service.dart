import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:ua_air_alerts/features/alerts/domain/region_matcher.dart';

abstract interface class RegionLocationService {
  Future<String?> detectRegionUid();
}

class GeolocatorRegionLocationService implements RegionLocationService {
  const GeolocatorRegionLocationService();

  @override
  Future<String?> detectRegionUid() async {
    if (!await Geolocator.isLocationServiceEnabled()) return null;

    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever ||
        permission == LocationPermission.unableToDetermine) {
      return null;
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
    if (placemarks.isEmpty) return null;

    return RegionMatcher.match(placemarks.first.administrativeArea ?? '');
  }
}
