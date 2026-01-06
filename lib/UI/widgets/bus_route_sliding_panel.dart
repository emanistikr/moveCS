import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/favorites_manager.dart';
//import '../../controller/info_lines.dart';
import '../../controller/app_localization.dart';

class BusRouteSlidingPanel extends StatefulWidget {

  void onBack (BuildContext context){
    Navigator.pop(context);
  }

  final Map<String, dynamic> lineDetails;
  final Color lineColor;
  final List<Map<String, dynamic>> routeStops;

  const BusRouteSlidingPanel({
    super.key,
    required this.lineColor,
    required this.lineDetails,
    required this.routeStops,
  });

  @override
  State<BusRouteSlidingPanel> createState() => _BusRouteSlidingPanelState();
}

class _BusRouteSlidingPanelState extends State<BusRouteSlidingPanel> {
  bool isFavorite = false;

  // Variabili per l'animazione del pannello
  final double _snapMin = 0.15;
  final double _snapMid = 0.50;
  final double _snapMax = 0.85;
  double? _currentHeight;
  Duration _animationDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _loadFavoriteState();
  }

  //carica lo stato iniziale della stella
  Future<void> _loadFavoriteState() async {
    final lineId = widget.lineDetails["short_name"];
    if (lineId != null) {
      bool fav = await FavoritesManager().isFavorite(lineId);

      if (mounted) {
        setState(() {
          isFavorite = fav;
        });
      }
    }
  }

  Future<void> _toggleFavorite() async {
    final lineId = widget.lineDetails["short_name"];
    if (lineId == null) return;

    setState(() {
      isFavorite = !isFavorite;
    });

    await FavoritesManager().toggleFavorite(lineId);
  }

  @override
  Widget build(BuildContext context) {

    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxHeightPixels = constraints.maxHeight;
        final double minH = maxHeightPixels * _snapMin;
        final double midH = maxHeightPixels * _snapMid;
        final double maxH = maxHeightPixels * _snapMax;

        _currentHeight ??= minH;

        return Column(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: AnimatedContainer(
                duration: _animationDuration,
                curve: Curves.easeOutQuart,
                height: _currentHeight,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    bottom: Radius.circular(20),
                  ),
                  boxShadow: [WidgetStyles.shadowDownStyle(context)],
                ),
                child: Column(
                  children: [
                    // Lista delle fermate
                    Expanded(
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        itemCount: widget.routeStops.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Text(
                              widget.routeStops[index]["name"].toString(),
                            ),
                            leading: const Icon(Icons.directions_bus),
                          );
                        },
                      ),
                    ),

                    // HEADER / CONTROLLO PANNELLO
                    GestureDetector(
                      onVerticalDragStart: (_) {
                        setState(() => _animationDuration = Duration.zero);
                      },
                      onVerticalDragUpdate: (details) {
                        setState(() {
                          double newHeight = _currentHeight! + details.delta.dy;
                          _currentHeight = newHeight.clamp(minH, maxH);
                        });
                      },
                      onVerticalDragEnd: (details) {
                        double velocity = details.primaryVelocity ?? 0;
                        setState(() {
                          _animationDuration = const Duration(
                            milliseconds: 300,
                          );
                          // Logica di snapping
                          if (velocity > 500) {
                            if (_currentHeight! < midH)
                              _currentHeight = midH;
                            else
                              _currentHeight = maxH;
                          } else if (velocity < -500) {
                            if (_currentHeight! > midH)
                              _currentHeight = midH;
                            else
                              _currentHeight = minH;
                          } else {
                            double distMin = (_currentHeight! - minH).abs();
                            double distMid = (_currentHeight! - midH).abs();
                            double distMax = (_currentHeight! - maxH).abs();
                            if (distMin < distMid && distMin < distMax)
                              _currentHeight = minH;
                            else if (distMid < distMin && distMid < distMax)
                              _currentHeight = midH;
                            else
                              _currentHeight = maxH;
                          }
                        });
                      },

                      // TESTA DEL PANNELLO
                      child: Container(
                        width: double.infinity,
                        height: 120,
                        decoration: BoxDecoration(
                          color: widget.lineColor,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(20),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () => widget.onBack(context),
                              child: Icon(
                                Icons.arrow_back_ios,
                                color: colorScheme.primary,
                                size: 22,
                              ),
                            ),
                            Image.asset(
                              'assets/icons/logo_circolare_veloce.png',
                              height: 50,
                            ),
                            Text(
                              widget.lineDetails["short_name"] ?? "LINEA",
                              style: Theme.of(
                                context,
                              ).textTheme.displaySmall?.copyWith(fontSize: 65),
                            ),

                            InkWell(
                              onTap: _toggleFavorite,
                              child: isFavorite
                                  ? const Icon(
                                      Icons.star,
                                      size: 30,
                                      color: Colors.white,
                                    )
                                  : const Icon(
                                      Icons.star_border,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                            ),
                            // ----------------------------------
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Maniglia fluttuante
            SizedBox(
              height: 20,
              child: Center(
                child: Container(
                  width: 65,
                  height: 5,
                  decoration: BoxDecoration(
                    color: widget.lineColor,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
