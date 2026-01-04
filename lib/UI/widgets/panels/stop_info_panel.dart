import 'package:flutter/material.dart';
import 'package:movecs/controller/app_localization.dart';
import '../../../controller/info_lines.dart';
import 'package:skeletonizer/skeletonizer.dart';

class StopInfoPanel extends StatefulWidget {
  final Map<String, dynamic>? data;
  final ScrollController scrollController;

  const StopInfoPanel({
    super.key,
    required this.data,
    required this.scrollController,
  });

  @override
  State<StopInfoPanel> createState() => _StopInfoPanelState();
}

class _StopInfoPanelState extends State<StopInfoPanel> {
  late Future<List<Map<String, dynamic>>> _departuresFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _departuresFuture = _fetchData();
    InfoLines.getBusLines(); // Preload linee bus
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  @override
  void didUpdateWidget(covariant StopInfoPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.data?['code'] != oldWidget.data?['code']) {
      setState(() {
        isLoading = true;
        _departuresFuture = _fetchData();
      });
      _departuresFuture.then((_) => setState(() => isLoading = false));
    }
  }

  // creo una funzione che restituisce dati fittizi per non avere problemi con firebase
  Future<List<Map<String, dynamic>>> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final now = DateTime.now();
    String formatTime(DateTime dt) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
    }

    return [
      {
        'line_id': 'CVR',
        'departure_time': formatTime(now.add(const Duration(minutes: 3))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVA',
        'trip_id': 'Piazza Roma',
        'departure_time': formatTime(now.add(const Duration(minutes: 12))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVRO',
        'trip_id': 'Stazione Centrale',
        'departure_time': formatTime(now.add(const Duration(minutes: 25))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVC',
        'trip_id': 'Deposito',
        'departure_time': formatTime(now.add(const Duration(minutes: 55))),
        'stop_id': '5100',
      },
      {
        'line_id': 'L26',
        'trip_id': 'sexo',
        'departure_time': formatTime(now.add(const Duration(minutes: 59))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVR',
        'trip_id': 'Stazione Centrale',
        'departure_time': formatTime(now.add(const Duration(minutes: 63))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVA',
        'trip_id': 'Piazza Roma',
        'departure_time': formatTime(now.add(const Duration(minutes: 72))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVRO',
        'trip_id': 'Stazione Centrale',
        'departure_time': formatTime(now.add(const Duration(minutes: 85))),
        'stop_id': '5100',
      },
      {
        'line_id': 'CVC',
        'trip_id': 'Deposito',
        'departure_time': formatTime(now.add(const Duration(minutes: 115))),
        'stop_id': '5100',
      },
      {
        'line_id': 'L26',
        'trip_id': 'sexo',
        'departure_time': formatTime(now.add(const Duration(minutes: 119))),
        'stop_id': '5100',
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    String stopName = (widget.data != null)
        ? "${widget.data?['name']}"
        : "Unknown Stop";

    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _departuresFuture,
      builder: (context, snapshot) {
        // Calcolo delle linee uniche (per la lista orizzontale)
        List<String> uniqueLines = [];
        if (snapshot.hasData) {
          uniqueLines = snapshot.data!
              .map((d) => d['line_id'] as String)
              .toSet()
              .toList();
        }

        return CustomScrollView(
          controller: widget.scrollController,
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [_buildAppBar(stopName, uniqueLines), _buildBody(snapshot)],
        );
      },
    );
  }

  SliverAppBar _buildAppBar(String stopName, List<String> uniqueLines) {
    const double expandedHeight = 120.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      pinned: true,
      floating: false,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).colorScheme.surface,
      elevation: 0,

      title: Text(stopName, style: Theme.of(context).textTheme.titleLarge),
      centerTitle: true,

      // LA PARTE CHE SCOMPARE SCORRENDO
      flexibleSpace: FlexibleSpaceBar(
        background: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // lista orizzontale
            _buildHorizontalBusList(uniqueLines),
            const SizedBox(height: 15),
          ],
        ),
      ),

      // Linea divisoria che rimane attaccata al fondo della AppBar
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Divider(color: Colors.grey.shade200, height: 1.0),
      ),
    );
  }

  Widget _buildBody(AsyncSnapshot<List<Map<String, dynamic>>> snapshot) {
    List<Map<String, dynamic>> departures = [];

    if (isLoading) {
      // Generiamo dati finti per lo scheletro (caricamento)
      departures = List.generate(
        6,
        (index) => {
          'line_id': '00',
          'departure_time': '00:00:00',
          'trip_id': 'fake_trip',
        },
      );
    } else if (snapshot.hasData) {
      departures = snapshot.data!;
    }

    return Skeletonizer.sliver(
      enabled: isLoading,
      child: (!isLoading && (snapshot.hasError || departures.isEmpty))
          ? SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                child: Text(
                  snapshot.hasError
                      ? AppLocalizations.of(context)?.translate("Error") ??
                            "An error has occurred"
                      : AppLocalizations.of(
                              context,
                            )?.translate("NoDepartures") ??
                            "No upcoming departures",
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            )
          : SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (index >= departures.length) return null;

                var data = departures[index];
                String lineId = data['line_id']?.toString() ?? "";
                var lineDetails = InfoLines.getLineDetails(lineId);

                Color busColor = lineDetails != null
                    ? InfoLines.hexToColor(lineDetails['color'])
                    : Colors.grey.shade300;

                String busShortName =
                    lineDetails?['short_name']?.toString() ?? "BUS";
                String destination =
                    lineDetails?['destination']?.toString() ??
                    "Destinazione...";

                String timeString =
                    data['departure_time']?.toString() ?? "--:--";
                if (timeString.length > 5) {
                  timeString = timeString.substring(0, 5);
                }

                return Column(
                  children: [
                    _buildDepartureTile(
                      lineId,
                      lineDetails,
                      busColor,
                      busShortName,
                      destination,
                      timeString,
                    ),
                    Divider(color: Colors.grey.shade200, height: 1),
                  ],
                );
              }, childCount: departures.length),
            ),
    );
  }

  ListTile _buildDepartureTile(
    String lineId,
    Map<String, dynamic>? lineDetails,
    Color busColor,
    String busShortName,
    String destination,
    String timeString,
  ) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
      leading: Container(
        width: 75,
        height: 60,
        decoration: BoxDecoration(
          color: busColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            busShortName,
            style: Theme.of(context).textTheme.displaySmall,
            textAlign: TextAlign.center,
          ),
        ),
      ),
      title: Text(
        lineDetails?['long_name'] ?? lineId,
        style: Theme.of(context).textTheme.labelMedium,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      subtitle: Text(
        "Per $destination",
        style: Theme.of(context).textTheme.labelSmall,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            timeString,
            style: Theme.of(
              context,
            ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          Text(
            "${getMinutesFromNow(timeString)} min",
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontSize: 13),
          ),
        ],
      ),
    );
  }

  SizedBox _buildHorizontalBusList(List<String> lines) {
    // Se sta caricando, ignoriamo la lista vuota 'lines' e ne creiamo una finta con 4 elementi per mostrare 4 "card" grigie che pulsano.
    final effectiveLines = isLoading
        ? ['fake_1', 'fake_2', 'fake_3', 'fake_4']
        : lines;

    return SizedBox(
      height: 50,
      child: Skeletonizer(
        enabled: isLoading,
        child: effectiveLines.isEmpty
            ? const SizedBox()
            : ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: effectiveLines.length,
                itemBuilder: (context, i) {
                  String lineId = effectiveLines[i];

                  var details = InfoLines.getLineDetails(lineId);
                  Color color = details != null
                      ? InfoLines.hexToColor(details['color'])
                      : Colors.grey.shade300;

                  String shortName =
                      details?['short_name']?.toString() ?? "BUS";

                  return Container(
                    width: 120,
                    margin: const EdgeInsets.only(right: 10),
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    alignment: Alignment.center,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Icon(
                          Icons.loop_rounded,
                          size: 40,
                          color: Colors.white,
                        ),
                        Text(
                          shortName,
                          style: Theme.of(context).textTheme.displaySmall,
                        ),
                      ],
                    ),
                  );
                },
              ),
      ),
    );
  }

  int getMinutesFromNow(String busTimeString) {
    DateTime now = DateTime.now();
    try {
      DateTime busTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(busTimeString.split(':')[0]),
        int.parse(busTimeString.split(':')[1]),
      );
      if (busTime.isBefore(now)) busTime = busTime.add(const Duration(days: 1));
      return busTime.difference(now).inMinutes;
    } catch (e) {
      return 0;
    }
  }
}
