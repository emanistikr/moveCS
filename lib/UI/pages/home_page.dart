import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';
import '../widgets/geo_map.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [GeoMap(),TopBar()]));
    //Nello Stack il primo elemento è quello più in basso
  }
}
