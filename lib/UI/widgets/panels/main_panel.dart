import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';

class MainPanel extends StatelessWidget {
  const MainPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: Center(
        child: Text(
          AppLocalizations.of(context)?.translate("StartNavigating") ?? "",
          style: Theme.of(context).textTheme.titleLarge,
        ),
      ),
    );
  }
}
