import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../config/app_constants.dart';
import '../../../controller/controller.dart';

class GeoMap extends StatefulWidget {
  const GeoMap({super.key});
  @override
  State<GeoMap> createState() => _GeoMapState();
}

class _GeoMapState extends State<GeoMap> {

  //Controller di Maps

  //Posizione iniziale della mappa
  final LatLng _center = AppConstants.initialPosition;

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition:  CameraPosition(target: _center, zoom: 11.0),
      compassEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
    );
  }

  //Metodo chiamato alla creazione della mappa:
  // gli assegna il controller di Maps alla variabile
  void _onMapCreated(GoogleMapController controller) {
    Controller.mapController = controller;
  }


}
