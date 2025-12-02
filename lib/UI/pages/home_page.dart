import 'package:flutter/material.dart';
import '../widgets/movecs_sliding_panel.dart';
import '../widgets/top_bar.dart';
import '../widgets/geo_map.dart';
import '../../controller/map_controller.dart';

class HomePage extends StatelessWidget {
  HomePage({super.key});

  final MapController _mapController = MapController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(
        children: [
          GeoMap(mapController: _mapController),
          MovecsSlidingPanel(),
          TopBar(mapController: _mapController),
        ],
      ),
    );
  }
}
