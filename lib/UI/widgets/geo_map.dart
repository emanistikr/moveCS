import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/app_constants.dart';
import '../../controller/map_controller.dart';

class GeoMap extends StatefulWidget {
  final MapController mapController;
  const GeoMap({super.key, required this.mapController});

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
    widget.mapController.attach(controller);
    _applyMapStyle();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyMapStyle();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Marker>>(
      future: MapController.getStopMarkers() ,
      builder: (context, snapshot) {
        // 1. Stato: In attesa (Loading)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        // 2. Stato: Errore
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        // 3. Stato: Dati Pronti
        // I dati effettivi (List<T>) sono disponibili in snapshot.data
        if (snapshot.hasData) {
          List<Marker> listaEffettiva = snapshot.data! ;

          return GoogleMap(
            markers: Set<Marker>.of(listaEffettiva),
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

        // Caso di fallback (es. lista vuota)
        return const Center(child: Text('Nessun dato trovato.'));
      },
    );
  }
}


