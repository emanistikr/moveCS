import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../config/app_constants.dart';
import '../../controller/map_controller.dart';
import '../../controller/info_stops.dart';

class GeoMap extends StatefulWidget {
  final MapController mapController;
  final String? selectedStopId;
  final Map<String, dynamic>? selectedStopData;
  final Function(String, Map<String, dynamic>) onMarkerTap;

  const GeoMap({
    super.key,
    required this.mapController,
    this.selectedStopId,
    this.selectedStopData,
    required this.onMarkerTap,
  });

  @override
  GeoMapState createState() => GeoMapState();
}

class GeoMapState extends State<GeoMap> {
  final LatLng _center = AppConstants.initialPosition;
  GoogleMapController? _mapController;

  Set<Marker> _markers = {};
  bool _isLoading = true;

  String? _lightStyle;
  String? _darkStyle;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // rileva cambiamenti nella fermata selezionata
  @override
  void didUpdateWidget(covariant GeoMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedStopData != widget.selectedStopData) {
      _loadData();
    }
  }

  // Funzione unica per caricare tutto all'avvio
  Future<void> _loadData() async {
    try {
      List<Marker> markersList = await InfoStops.getStopMarkers(
        selectedStopId: widget.selectedStopId,
        onMarkerTap: widget.onMarkerTap,
        selectedStopData: (widget.selectedStopId == '1')
            ? widget.selectedStopData
            : null,
      );

      if (mounted) {
        setState(() {
          _markers = markersList.toSet();
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint("Errore caricamento marker: $e");
      if (mounted) setState(() => _isLoading = false);
    }
    _loadStylesIfNeeded().then((_) => _applyMapStyle());
  }

  Future<void> _loadStylesIfNeeded() async {
    if (_lightStyle != null && _darkStyle != null) return;
    try {
      _lightStyle = await rootBundle.loadString(
        'assets/map_styles/map_style_light.json',
      );
      _darkStyle = await rootBundle.loadString(
        'assets/map_styles/map_style_dark.json',
      );
    } catch (e) {
      debugPrint('Errore stili: $e');
    }
  }

  Future<void> _applyMapStyle() async {
    if (!mounted || _mapController == null) return;
    await _loadStylesIfNeeded();
    final style = Theme.of(context).brightness == Brightness.dark
        ? _darkStyle
        : _lightStyle;
    try {
      await _mapController!.setMapStyle(style);
    } catch (e) {
      debugPrint('$e');
    }
  }

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
    // Se sta caricando, mostra lo spinner
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return GoogleMap(
      // Passiamo il Set già pronto. Nessun calcolo qui!
      markers: _markers,
      onMapCreated: _onMapCreated,
      initialCameraPosition: CameraPosition(target: _center, zoom: 15),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      compassEnabled: false,
      zoomControlsEnabled: false,
      mapToolbarEnabled: false,

      buildingsEnabled: false,
      trafficEnabled: false,

      mapType: MapType.normal,
    );
  }
}
