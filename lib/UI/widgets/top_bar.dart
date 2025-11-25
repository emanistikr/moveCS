import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';
import '../../../config/widget_decoration/app_button_decoration.dart';

class TopBar extends StatefulWidget {
  const TopBar({super.key});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [_searchButton(context), _gpsButton()],
        ),
      ),
    );
  }
}

Widget _searchButton(BuildContext context) => Container(
  width: MediaQuery.of(context).size.width - 115,
  height: 56,
  decoration: AppButtonDecoration.elevatedButtonDecoration,
  alignment: Alignment.centerLeft,
  padding: EdgeInsets.only(left: 14),
  child: Row(
    children: [
      const Icon(Icons.search, color: AppColors.darkElements, size: 30),
      const Padding(padding: EdgeInsets.only(right: 15)),
      Text(
        'Dove vuoi andare?',
        style: Theme.of(context).textTheme.bodyLarge,
      ), //TODO: Localizzazione
    ],
  ),
);

Widget _gpsButton() => Container(
  width: 56,
  height: 56,
  decoration: AppButtonDecoration.elevatedButtonDecoration,
  child: Center(
    child: Container(
      height: 30,
      width: 30,
      child: Icon(Icons.gps_fixed, color: AppColors.darkElements),
    ),
  ),
);
