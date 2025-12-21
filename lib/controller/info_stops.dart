import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class infoStops {
  static BitmapDescriptor? _stopIcon;
  static BitmapDescriptor? _selectedStopIcon;
  static List<QueryDocumentSnapshot>? _cachedData;

  //Metodo per otenere i marker di tutte le fermate
  static Future<List<Marker>> getStopMarkers({
    String? selectedStopId,
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
        onTap: () {
          if (onMarkerTap != null) {
            onMarkerTap(id, data);
          }
          debugPrint('Marker $id, $data');
        },
      );
      markers.add(marker);
    }

    return markers;
  }
}
