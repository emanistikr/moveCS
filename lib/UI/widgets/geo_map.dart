import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GeoMap extends StatefulWidget {
  const GeoMap({super.key});
  @override
  State<GeoMap> createState() => _GeoMapState();
}

class _GeoMapState extends State<GeoMap> {

  //Controller di Maps
  late GoogleMapController mapController;

  //Posizione iniziale della mappa
  final LatLng _center = const LatLng(
    39.304627,
    16.262382,
  ); //Cosenza

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:  CameraPosition(target: _center, zoom: 11.0),
    );
  }

  //Metodo chiamato alla creazione della mappa:
  // gli assegna il controller di Maps alla variabile
  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }
}
