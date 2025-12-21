import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'geoloc.dart';

class MapController {
  GoogleMapController? _mapController;

  void attach(GoogleMapController controller) {
    _mapController = controller;
  }

  bool get isReady => _mapController != null;

  Future<void> goToUserLocation() async {
    try {
      final Position pos = await GeoLoc.getCurrentLocation();
      goToPosition(LatLng(pos.latitude, pos.longitude));
    } catch (e) {
      debugPrint('Error in goToUserLocation: $e');
    }
  }

  Future<void> goToPosition(LatLng position) async {
    if (_mapController == null) return;

    try {
      final camera = CameraPosition(
        target: position,
        zoom: 17, // Zoom più alto per vedere bene la fermata
      );

      await _mapController!.animateCamera(
        CameraUpdate.newCameraPosition(camera),
      );
    } catch (e) {
      debugPrint('Error in goToPosition: $e');
    }
  }
}
