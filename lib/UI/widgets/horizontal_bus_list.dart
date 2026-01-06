import 'package:flutter/material.dart';
import '../../../controller/info_lines.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../pages/bus_route_page.dart';

class HorizontalBusList extends StatelessWidget {
  final List<String> lines;
  final bool isLoading;

  const HorizontalBusList({
    super.key,
    required this.lines,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return _buildHorizontalBusList(lines);
  }

  ListView _buildHorizontalBusList(List<String> lines) {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      itemCount: lines.length,
      itemBuilder: (context, i) {
        String lineId = lines[i];

        var details = InfoLines.getLineDetails(lineId);
        Color color = details != null
            ? InfoLines.hexToColor(details['color'])
            : Colors.grey.shade300;

        String shortName = details?['short_name']?.toString() ?? "BUS";

        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => BusRoutePage(routeName: shortName),
              ),
            );
          },
          child: Container(
            width: 120,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            alignment: Alignment.center,
            child: (shortName[0] == 'C')
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Image.asset(
                        'assets/icons/logo_circolare_veloce.png',
                        height: 20,
                      ),
                      Text(
                        shortName,
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                    ],
                  )
                : Text(
                    shortName,
                    style: Theme.of(context).textTheme.displaySmall,
                    textAlign: TextAlign.center,
                  ),
          ),
        );
      },
    );
  }
}
