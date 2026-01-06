import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:movecs/controller/info_stops.dart';
import '../widgets/geo_map.dart';
import '../../controller/map_controller.dart';
import '../../controller/info_lines.dart';
import '../widgets/bus_route_sliding_panel.dart';

class BusRoutePage extends StatelessWidget {
  final String routeName;

  BusRoutePage({Key? key, required this.routeName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> routeStops = InfoLines.getLineStops(routeName);
    final MapController _mapController = MapController();
    final Color lineColor = InfoLines.hexToColor(
      InfoLines.getLineDetails(routeName)!["color"],
    );

    List<Marker> lineStopsMarkers = InfoStops.getMarkerList(routeStops);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(toolbarHeight: 0),
      body: Stack(
        children: [
          GeoMap(
            customMarkers: lineStopsMarkers,
            mapController: _mapController,
            routePolyline: _convertToLatLngList(routeStops),

            onMarkerTap: (id, data) {}, // Non usiamo il tap in questa pagina
            selectedStopId: null,
            routeColor: lineColor,
          ),
          BusRouteSlidingPanel(
            lineDetails: InfoLines.getLineDetails(routeName)!,
            lineColor: lineColor,
            routeStops: routeStops,
          ),
        ],
      ),
    );
  }

  List<LatLng> _convertToLatLngList(List<Map<String, dynamic>> points) {
    return points.map((point) {
      double lat = point['lat'] ?? 0.0;
      double lng = point['lng'] ?? 0.0;
      return LatLng(lat, lng);
    }).toList();
  }
}
