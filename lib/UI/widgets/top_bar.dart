import 'package:flutter/material.dart';
import '../../../config/widget_decoration/widget_styles.dart';
import '../pages/search_page.dart';
import '../../controller/map_controller.dart';

class TopBar extends StatefulWidget {
  final MapController mapController;

  const TopBar({super.key, required this.mapController});

  @override
  State<TopBar> createState() => _TopBarState();
}

class _TopBarState extends State<TopBar> {
  bool _isLoadingGps = false;

  void _onGpsPressed() async {
    if (_isLoadingGps) return;

    setState(() {
      _isLoadingGps = true;
    });

    if (widget.mapController.isReady) {
      await widget.mapController.goToUserLocation();
      setState(() {
        _isLoadingGps = false;
      });
    } else {
      debugPrint('MapController non pronto');
    }
    debugPrint('GPS premuto');
  }

  void _onSearchPressed() {
    //logica per aprire la pagina di ricerca
    Navigator.of(context).push(_searchRoute());
  }

  Route _searchRoute() {
    //animazione per aprire la pagina di ricerca
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      pageBuilder: (context, animation, secondaryAnimation) =>
          const SearchPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          //cubica
          parent: animation,
          curve: Curves.easeOutCubic,
          reverseCurve: Curves.easeInCubic,
        );

        final slideAnimation = Tween<Offset>(
          //scorrimento dall'alto al basso un poco
          begin: const Offset(0.0, -0.1),
          end: Offset.zero,
        ).animate(curved);

        final scaleAnimation = Tween<double>(
          //leggero ingrandimento
          begin: 0.98,
          end: 1.0,
        ).animate(curved);

        final fadeAnimation = Tween<double>(
          //dissolvenza
          begin: 0.0,
          end: 1.0,
        ).animate(curved);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: ScaleTransition(scale: scaleAnimation, child: child),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 50, left: 20, right: 20),
      child: SizedBox(
        width: double.infinity,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _searchButton(context, _onSearchPressed),
            _gpsButton(context, _onGpsPressed, _isLoadingGps),
          ],
        ),
      ),
    );
  }
}

Widget _searchButton(BuildContext context, VoidCallback onTap) => Hero(
  //hero per animare la barra da una pagina all’altra
  tag: 'searchBar',
  child: Material(
    color: Colors.transparent,
    child: InkWell(
      //inkwell per rendere cliccabile
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        width: MediaQuery.of(context).size.width - 115,
        height: 56,
        decoration: WidgetStyles.elevatedButtonDecoration(context),
        alignment: Alignment.centerLeft,
        padding: const EdgeInsets.only(left: 14),
        child: Row(
          children: [
            Icon(
              Icons.search,
              color: Theme.of(context).colorScheme.onSurface,
              size: 30,
            ),
            const SizedBox(width: 15),
            Text(
              'Dove vuoi andare?', //TODO: localizzare
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    ),
  ),
);

Widget _gpsButton(
  BuildContext context,
  VoidCallback onPressed,
  bool isLoading,
) => InkWell(
  //inkwell per rendere cliccabile
  onTap: isLoading ? null : onPressed,
  borderRadius: BorderRadius.circular(50),
  child: Container(
    width: 56,
    height: 56,
    decoration: WidgetStyles.elevatedButtonDecoration(context),
    child: Center(
      child: isLoading
          ? SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation(
                  Theme.of(context).colorScheme.onSurface,
                ),
              ),
            )
          : Icon(
              Icons.gps_fixed,
              color: Theme.of(context).colorScheme.onSurface,
              size: 25,
            ),
    ),
  ),
);
