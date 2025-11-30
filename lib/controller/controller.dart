import 'package:google_maps_flutter/google_maps_flutter.dart';
import './geoloc.dart';
import 'package:geolocator/geolocator.dart';

class Controller {
  static late GoogleMapController mapController;

  static Future<Position> getCurrentLocation() async {
    return await GeoLoc.getCurrentLocation();
  }

  static void goToUserLocation() {
    GeoLoc.goToUserLocation();
  }
}