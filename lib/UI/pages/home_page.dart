import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/movecs_sliding_panel.dart';
import '../widgets/top_bar.dart';
import '../widgets/geo_map.dart';
import '../../controller/map_controller.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final MapController _mapController = MapController();

  Map<String, dynamic>? _selectedStopData;
  String? _selectedStopId;

  Future<void> _onStopTapped(String id, Map<String, dynamic> data) async {
    setState(() {
      _selectedStopId = id;
      _selectedStopData = data;
    });
    if (id == '0') {
      await _mapController.goToUserLocation();
    } else {
      try {
        _mapController.goToPosition(LatLng(data['lat'], data['lng']));
      } catch (e) {
        debugPrint("$e");
      }
    }
  }

  //TODO: quando premo pulsante indietro o tocco un pulsante apposito, resetta la fermata selezionata
  /* void _clearSelectedStop() {
    setState(() {
      _selectedStopId = null;
      _selectedStopData = null;
    });
  } */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // TODO non funzina, sistemare
      body: Stack(
        children: [
          GeoMap(
            mapController: _mapController,
            selectedStopId: _selectedStopId,
            onMarkerTap: _onStopTapped,
          ),
          MovecsSlidingPanel(selectedStopData: _selectedStopData),
          TopBar(mapController: _mapController, onMarkerTap: _onStopTapped),
        ],
      ),
    );
  }
}
