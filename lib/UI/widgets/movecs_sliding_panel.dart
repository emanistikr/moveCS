import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';

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
            oldWidget.selectedStopData?['code'] &&
        widget.selectedStopData != null) {
      if (_panelController.isAttached) {
        _panelController.animateTo(
          0.25,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      controller: _panelController,
      initialChildSize: 0.50, // <- più alto per includere lo spazio trasparente
      minChildSize: 0.15,
      maxChildSize: 0.85,

      snap: true,
      snapSizes: const [0.15, 0.50, 0.85],

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
                    Text(
                      'Dettagli Fermata: ${widget.selectedStopData}',
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
