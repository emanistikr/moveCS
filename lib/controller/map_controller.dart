import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'geoloc.dart';
import 'info_stops.dart';

class MapController {
  GoogleMapController? _mapController;

  void attach(GoogleMapController controller) {
    _mapController = controller;
  }

  bool get isReady => _mapController != null;

  Future<void> goToUserLocation() async {
    if (_mapController == null) return;

    try {
      final Position pos = await GeoLoc.getCurrentLocation();

      final camera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15,
      );

      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(camera),
      );
    } catch (e) {
      print('Error in goToUserLocation: $e');
    }
  }

  static Future<List<Marker>> getStopMarkers() async {
    return await infoStops.getStopMarkers();
  }
}
