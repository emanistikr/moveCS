import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class infoStops {

  //Metodo per otenere i marker di tutte le fermate
  static Future<List<Marker>> getStopMarkers() async {
    List<Marker> markers = [];
    QuerySnapshot snapshot =
        await FirebaseFirestore.instance.collection('stops').get();

    for (var doc in snapshot.docs) {
      var data = doc.data() as Map<String, dynamic>;
      double latitude = data['lat'];
      double longitude = data['lng'];
      LatLng position = LatLng( latitude, longitude);

      Marker marker = Marker(
        markerId: MarkerId(doc.id),
        position: position,
        infoWindow: InfoWindow(
          title: data['name'] ?? 'Fermata senza nome',
          snippet: data['description'] ?? '',
        ),
      );

      markers.add(marker);
    }

    return markers;
  }

}