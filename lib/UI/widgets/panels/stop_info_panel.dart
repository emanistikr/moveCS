import 'package:flutter/material.dart';
import 'package:movecs/UI/widgets/horizontal_bus_list.dart';
import 'package:movecs/controller/app_localization.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../controller/info_lines.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../pages/bus_route_page.dart';

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
    InfoLines.getBusLines(); // Preload linee bus
    _loadData();
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

  void _loadData() {
    setState(() {
      isLoading = true;
    });

    _departuresFuture = _fetchData();

    _departuresFuture.whenComplete(() {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    });
  }

  Future<List<Map<String, dynamic>>> _fetchData() async {
    await Future.delayed(const Duration(milliseconds: 1000));
    final now = DateTime.now();
    String formatTime(DateTime dt) {
      return "${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}:${dt.second.toString().padLeft(2, '0')}";
    }

    final stopId = widget.data?['code'];

    if (stopId == null) return [];

    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('stop_departures')
          .where('stop_id', isEqualTo: stopId)
          .where('departure_time', isGreaterThanOrEqualTo: formatTime(now))
          .orderBy('departure_time')
          .limit(10)
          .get();

      // Convertiamo i documenti Firebase in una lista di Map
      return querySnapshot.docs.map((doc) => doc.data()).toList();
    } catch (e) {
      debugPrint("Errore nel recupero partenze: $e");
      // In caso di errore ritorniamo una lista vuota o gestiamo l'errore diversamente
      return [];
    }
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
      effect: ShimmerEffect(
        baseColor: Theme.of(
          context,
        ).colorScheme.onPrimaryContainer.withAlpha(50),
        highlightColor: Theme.of(context).colorScheme.onPrimaryContainer,
        duration: Duration(seconds: 1),
      ),
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

  InkWell _buildDepartureTile(
    String lineId,
    Map<String, dynamic>? lineDetails,
    Color busColor,
    String busShortName,
    String destination,
    String timeString,
  ) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => BusRoutePage(routeName: lineId),
          ),
        );
      },
      child: ListTile(
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
      ),
    );
  }

  SizedBox _buildHorizontalBusList(List<String> lines) {
    // Se sta caricando, ignoriamo la lista vuota 'lines' e ne creiamo una finta con 4 elementi per mostrare 4 "card" grigie che pulsano.
    final effectiveLines = isLoading ? ['L1', 'L2', 'L3', 'L4'] : lines;

    return SizedBox(
      height: 50,
      child: Skeletonizer(
        effect: ShimmerEffect(
          baseColor: Theme.of(
            context,
          ).colorScheme.onPrimaryContainer.withAlpha(50),
          highlightColor: Theme.of(context).colorScheme.onPrimaryContainer,
          duration: Duration(seconds: 1),
        ),
        enabled: isLoading,
        child: effectiveLines.isEmpty
            ? const SizedBox()
            : HorizontalBusList(lines: effectiveLines),
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
