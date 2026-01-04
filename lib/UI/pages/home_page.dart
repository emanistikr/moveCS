import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../widgets/movecs_sliding_panel.dart';
import '../widgets/top_bar.dart';
import '../widgets/geo_map.dart';
import '../../controller/map_controller.dart';
import '../../controller/info_lines.dart';
import '../../controller/info_stops.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    InfoLines.loadLinesData();
    InfoStops.loadStopsData();
  }

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
        _clearSelectedStop();
        debugPrint("$e");
      }
    }
  }

  void _clearSelectedStop() {
    setState(() {
      _selectedStopId = null;
      _selectedStopData = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      //se c'è una fermata selezionat, il tasto indietro la chiude invece di uscire
      canPop: _selectedStopId == null,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_selectedStopId != null) {
          _clearSelectedStop();
        }
      },

      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            GeoMap(
              mapController: _mapController,
              selectedStopId: _selectedStopId,
              selectedStopData: _selectedStopData,
              onMarkerTap: _onStopTapped,
            ),
            MovecsSlidingPanel(
              selectedStopData: _selectedStopData,
              onStopSelected: _onStopTapped,
            ),
            TopBar(mapController: _mapController, onMarkerTap: _onStopTapped),
          ],
        ),
      ),
    );
  }
}
