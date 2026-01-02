import 'package:geolocator/geolocator.dart';

class GeoLoc {
  static Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      // TODO gestire l'errore,
    }

    LocationSettings locationSettings;

    locationSettings = AndroidSettings(
      accuracy: LocationAccuracy.lowest,
      distanceFilter: 10,
      forceLocationManager: true,
      intervalDuration: const Duration(seconds: 2),
    );
    return await Geolocator.getCurrentPosition(
      locationSettings: locationSettings,
    );
  }
}
