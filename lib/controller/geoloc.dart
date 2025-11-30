import 'package:geolocator/geolocator.dart';
import './controller.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoLoc {

  static Future<Position> getCurrentLocation() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    return await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
  }

  static void goToUserLocation() async {
    try {
      Position pos = await getCurrentLocation();
      final newCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15,
      );
      Controller.mapController?.animateCamera(CameraUpdate.newCameraPosition(newCamera));

    } catch (e) {
      // Handle permission denied or location services off
      print('Error fetching location: $e');
    }
  }
}
