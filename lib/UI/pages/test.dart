import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _totti(),
            SizedBox(width: 20),
            _totti(),
            SizedBox(width: 20),
            _totti(),
          ],
        ),
      ),
    );
  }
}

Widget _totti() => Container(
  width: 100,
  height: 40,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(10),
    color: Colors.deepOrange,
  ),
  child: Row(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,

    children: [
      Icon(Icons.sports_soccer, color: Colors.white),
      Text("TOTTI", style: TextStyle(color: Colors.white)),
    ],
  ),
);
