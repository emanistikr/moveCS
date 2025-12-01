import 'package:flutter/material.dart';
import '../widgets/movecs_sliding_panel.dart';
import '../widgets/top_bar.dart';
import '../widgets/geo_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      body: Stack(children: [GeoMap(), MovecsSlidingPanel(), TopBar()]),
    );
  }
}
