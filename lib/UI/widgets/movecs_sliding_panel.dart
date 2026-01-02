import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';
import 'panels/main_panel.dart';
import 'panels/stop_info_panel.dart';
import 'panels/near_stops_panel.dart';

class MovecsSlidingPanel extends StatefulWidget {
  final Map<String, dynamic>? selectedStopData;

  const MovecsSlidingPanel({super.key, this.selectedStopData});

  @override
  State<MovecsSlidingPanel> createState() => _MovecsSlidingPanelState();
}

class _MovecsSlidingPanelState extends State<MovecsSlidingPanel> {
  //Controller per il pannello scorrevole
  final DraggableScrollableController _panelController =
      DraggableScrollableController();

  @override
  void dispose() {
    _panelController.dispose(); // Pulizia del controller
    super.dispose();
  }

  // Rileva cambiamenti nel widget tipo quando si seleziona una fermata
  @override
  void didUpdateWidget(covariant MovecsSlidingPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selectedStopData?['code'] !=
        oldWidget.selectedStopData?['code']) {
      if (_panelController.isAttached) {
        _panelController.animateTo(
          widget.selectedStopData?['code'] == null ? 0.50 : 0.25,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOutQuart,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double snapLow = (widget.selectedStopData?['code'] != null) ? 0.25 : 0.15;
    return DraggableScrollableSheet(
      controller: _panelController,
      initialChildSize: 0.50, // <- più alto per includere lo spazio trasparente
      minChildSize: snapLow,
      maxChildSize: 0.85,

      snap: true,
      snapSizes: [snapLow, 0.50, 0.85],

      builder: (context, scrollController) {
        return Column(
          children: [
            //maniglia fluttuante
            SizedBox(
              height: 20,
              child: Center(
                child: Container(
                  width: 65,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
              ),
            ),

            // PANNELLO
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(26),
                  ),
                  boxShadow: [WidgetStyles.shadowUpStyle(context)],
                ),
                child: ListView(
                  controller: scrollController,
                  padding: const EdgeInsets.all(16),
                  children: [
                    if (widget.selectedStopData?['code'] == null)
                      const MainPanel()
                    else if (widget.selectedStopData?['code'] == 'USER_LOC')
                      const NearStopsPanel()
                    else
                      const StopInfoPanel(),

                    Text(
                      '${widget.selectedStopData}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
