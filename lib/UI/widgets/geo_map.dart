import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

import '../../config/app_constants.dart';
import '../../controller/geoloc.dart';

class GeoMap extends StatefulWidget {
  const GeoMap({super.key});

  @override
  GeoMapState createState() => GeoMapState();
}

class GeoMapState extends State<GeoMap> {
  final LatLng _center = AppConstants.initialPosition;

  GoogleMapController? _mapController;

  String? _lightStyle;
  String? _darkStyle;

  Future<void> _loadStylesIfNeeded() async {
    if (_lightStyle != null && _darkStyle != null) return;

    try {
      _lightStyle = await rootBundle.loadString(
        'assets/map_styles/map_style_light.json',
      );
      _darkStyle = await rootBundle.loadString(
        'assets/map_styles/map_style_dark.json',
      );
    } catch (e, s) {
      debugPrint('Errore nel caricamento degli stili della mappa: $e');
      debugPrint('$s');
    }
  }

  Future<void> _applyMapStyle() async {
    if (!mounted) return;
    if (_mapController == null) return;

    await _loadStylesIfNeeded();
    final style = Theme.of(context).brightness == Brightness.dark
        ? _darkStyle
        : _lightStyle;

    try {
      await _mapController!.setMapStyle(style);
    } catch (e, s) {
      debugPrint('Errore nell\'applicazione dello stile della mappa: $e');
      debugPrint('$s');
    }
  }

  //inizializzazione della mappa
  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
    _applyMapStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyMapStyle();
  }

  // ---------- GPS ----------
  Future<void> goToUserLocation() async {
    if (_mapController == null) return;

    try {
      Position pos = await GeoLoc.getCurrentLocation();

      final newCamera = CameraPosition(
        target: LatLng(pos.latitude, pos.longitude),
        zoom: 15,
      );

      _mapController!.animateCamera(CameraUpdate.newCameraPosition(newCamera));
    } catch (e) {
      debugPrint('Errore nel prendere la posizione: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 15),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,
      mapType: MapType.normal,
    );
  }
}
