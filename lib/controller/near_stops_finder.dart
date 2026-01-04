import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geolocator/geolocator.dart';
import 'info_stops.dart';
import 'dart:math';

Future<List<Map<String, dynamic>>> nearStopsFinder(
  String id,
  double? lat,
  double? lng,
  double r,
) async {
  if (id == '0') {
    Position? pos = await Geolocator.getLastKnownPosition();
    lat = pos?.latitude;
    lng = pos?.longitude;
    print("Using last known position: $lat, $lng");
  }

  if (lat == null || lng == null) return [];

  // 2. Calcolo Bounding Box (per scremare grossolanamente ed evitare calcoli inutili)
  final double deltaLat = r / 111.32;
  final double deltaLng = deltaLat / cos(lat * (pi / 180));

  final minLat = lat - deltaLat;
  final maxLat = lat + deltaLat;
  final minLng = lng - deltaLng;
  final maxLng = lng + deltaLng;

  List<QueryDocumentSnapshot> stops = InfoStops.getCachedMarkers();
  List<Map<String, dynamic>> stopsInRange = [];

  for (var doc in stops) {
    var data = doc.data() as Map<String, dynamic>;
    double stopLat = data['lat']; // Assicurati che nel DB siano double
    double stopLng = data['lng'];

    // Filtro veloce col rettangolo (Bounding Box)
    if (stopLat >= minLat &&
        stopLat <= maxLat &&
        stopLng >= minLng &&
        stopLng <= maxLng) {
      // 3. Calcolo Distanza Precisa
      // Aggiungiamo un campo temporaneo 'distance' alla mappa per poter ordinare dopo
      double distanceInMeters = Geolocator.distanceBetween(
        lat,
        lng,
        stopLat,
        stopLng,
      );
      data['distance_meters'] = distanceInMeters;

      stopsInRange.add(data);
    }
  }

  // 4. Ordina per distanza (dal più vicino al più lontano)
  stopsInRange.sort(
    (a, b) => (a['distance_meters'] as double).compareTo(
      b['distance_meters'] as double,
    ),
  );

  // 5. Prendi solo i primi 10 (o meno se ce ne sono pochi)
  if (stopsInRange.length > 10) {
    stopsInRange = stopsInRange.sublist(0, 10);
  }

  return stopsInRange;
}
