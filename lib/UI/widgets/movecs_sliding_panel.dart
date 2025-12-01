import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';

class MovecsSlidingPanel extends StatefulWidget {
  const MovecsSlidingPanel({super.key});

  @override
  State<MovecsSlidingPanel> createState() => _MovecsSlidingPanelState();
}

class _MovecsSlidingPanelState extends State<MovecsSlidingPanel> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
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
                  children: const [],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
