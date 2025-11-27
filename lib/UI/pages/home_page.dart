import 'package:flutter/material.dart';
import '../widgets/top_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Stack(children: [TopBar()]));
  }
}
