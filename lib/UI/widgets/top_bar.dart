import 'package:flutter/material.dart';
import '../../../config/app_colors.dart';

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
  decoration: BoxDecoration( //TODO: CREARE nuova classe
    borderRadius: BorderRadius.circular(50),
    color: Colors.white, //TODO: Cambiare colore se tema scuro
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 7,
        offset: const Offset(0, 3),
      ),
    ],
  ),
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
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.1),
        spreadRadius: 2,
        blurRadius: 5,
        offset: const Offset(0, 3),
      ),
    ],
  ),
  child: Center(
    child: Container(
      height: 30,
      width: 30,
      child: Icon(Icons.gps_fixed, color: AppColors.darkElements),
    ),
  ),
);
