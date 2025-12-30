import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';

class NearStopsPanel extends StatelessWidget {
  const NearStopsPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Center(
        child: Text(
          AppLocalizations.of(context)?.translate("NearStops") ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
