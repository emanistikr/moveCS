import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class InfoStops {
  static BitmapDescriptor? _stopIcon;
  static BitmapDescriptor? _selectedStopIcon;
  static BitmapDescriptor? _selectedLocationIcon;
  static List<QueryDocumentSnapshot>? _cachedData;

  static List<QueryDocumentSnapshot> getCachedMarkers() {
    return _cachedData ?? [];
  }

  static Future<void> loadStopsData() async {
    await getStopMarkers();
  }

  //Metodo per otenere i marker di tutte le fermate
  static Future<List<Marker>> getStopMarkers({
    String? selectedStopId,
    Map<String, dynamic>? selectedStopData,

    Function(String id, Map<String, dynamic> data)? onMarkerTap,
  }) async {
    //scarico le icone solo una volta
    _stopIcon ??= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/stop_icon.png',
    );
    _selectedStopIcon ??= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/selected_stop_icon.png',
    );
    _selectedLocationIcon ??= await BitmapDescriptor.fromAssetImage(
      const ImageConfiguration(size: Size(48, 48)),
      'assets/icons/selected_location_icon.png',
    );

    //scarico i dati solo una volta
    _cachedData ??=
        (await FirebaseFirestore.instance.collection('stops').get()).docs;

    List<Marker> markers = [];

    for (var doc in _cachedData!) {
      var data = doc.data() as Map<String, dynamic>;
      String id = doc.id;
      double latitude = data['lat'];
      double longitude = data['lng'];
      LatLng position = LatLng(latitude, longitude);

      Marker marker = Marker(
        markerId: MarkerId(id),
        position: position,
        icon: selectedStopId == id ? _selectedStopIcon! : _stopIcon!,
        zIndexInt: selectedStopId == id ? 1 : 0,
        onTap: () {
          if (onMarkerTap != null) {
            onMarkerTap(id, data);
          }
          debugPrint('Marker $id, $data');
        },
      );
      markers.add(marker);
    }

    if (selectedStopId == '1' && selectedStopData != null) {
      // Aggiungo marker per la posizione ottenuta dalla ricerca tramite api places
      double selectedStopLat = selectedStopData['lat'];
      double selectedStopLng = selectedStopData['lng'];
      LatLng selectedStopPosition = LatLng(selectedStopLat, selectedStopLng);

      Marker placeMarker = Marker(
        markerId: const MarkerId('1'),
        position: selectedStopPosition,
        icon: _selectedLocationIcon!,
        zIndexInt: 2,
      );
      markers.add(placeMarker);
    }

    return markers;
  }

  static List<Marker> getMarkerList(List<Map<String, dynamic>> data) {
    List<Marker> markers = [];

    for (var doc in data) {
      double latitude = doc['lat'];
      double longitude = doc['lng'];
      LatLng position = LatLng(latitude, longitude);

      Marker marker = Marker(
        markerId: MarkerId(doc["code"].toString()),
        position: position,
        icon: _stopIcon!,
        infoWindow: InfoWindow(title: doc["name"]),
      );
      markers.add(marker);
    }

    return markers;
  }

  //metodo per ottenere i dettagli di una fermata tramite ID
  static Map<String, dynamic>? getStopDetails(String stopId) {
    if (_cachedData == null) return null;

    try {
      final doc = _cachedData!.firstWhere((doc) => doc.id == stopId);
      return doc.data() as Map<String, dynamic>;
    } catch (e) {
      return null;
    }
  }
}
