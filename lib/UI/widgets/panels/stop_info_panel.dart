import 'package:flutter/material.dart';
//import '../../../controller/app_localization.dart';

class StopInfoPanel extends StatelessWidget {
  const StopInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Center(
        child: Text(
          "Stop Info Panel",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
