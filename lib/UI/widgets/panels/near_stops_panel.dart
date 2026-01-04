import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart'; // Import aggiunto
import '../../../controller/app_localization.dart';
import '../../../controller/near_stops_finder.dart';

class NearStopsPanel extends StatefulWidget {
  final Map<String, dynamic>? data;
  final ScrollController scrollController;
  final Function(Map<String, dynamic>)? onStopClick;

  const NearStopsPanel({
    super.key,
    required this.data,
    required this.scrollController,
    this.onStopClick,
  });

  @override
  State<NearStopsPanel> createState() => _NearStopsPanelState();
}

class _NearStopsPanelState extends State<NearStopsPanel> {
  late Future<List<Map<String, dynamic>>> _stops;
  bool isLoading = true; // Stato per lo skeletonizer

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  /// Metodo fondamentale per aggiornare la vista quando il genitore passa nuovi dati
  @override
  void didUpdateWidget(covariant NearStopsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.data?['id'] != widget.data?['id'] ||
        oldWidget.data != widget.data) {
      _loadData();
    }
  }

  void _loadData() {
    setState(() {
      isLoading = true; // Attiva lo scheletro
      _stops = _searchStops();
    });

    // Quando la ricerca finisce, disattiva lo scheletro
    _stops.then((_) {
      if (mounted) {
        setState(() => isLoading = false);
      }
    });
  }

  Future<List<Map<String, dynamic>>> _searchStops() async {
    // Piccolo ritardo artificiale per evitare flash troppo rapidi dello scheletro (opzionale, come nel tuo esempio)
    // await Future.delayed(const Duration(milliseconds: 500));

    if (widget.data == null) return [];

    try {
      String id = widget.data!['id']; // to String per sicurezza

      double? lat;
      if (widget.data!['lat'] != null) {
        lat = double.tryParse(widget.data!['lat'].toString());
      }

      double? lng;
      if (widget.data!['lng'] != null) {
        lng = double.tryParse(widget.data!['lng'].toString());
      }

      return await nearStopsFinder(id, lat, lng, 1);
    } catch (e) {
      debugPrint("Errore nel parsing dei dati fermata: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    String nearWho = '';
    if (widget.data != null) {
      // Gestione sicura del confronto ID
      final idStr = widget.data!['id'].toString();
      nearWho = (idStr == '0') ? 'me' : (widget.data!['name'] ?? '');
    }

    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(context, nearWho),
        _buildBody(context),
        // Spazio extra per evitare problemi di scroll su alcuni device
        SliverToBoxAdapter(
          child: SizedBox(height: MediaQuery.of(context).padding.bottom),
        ),
      ],
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, String nearWho) {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(
        "${AppLocalizations.of(context)?.translate("NearStops") ?? ""} $nearWho",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1.0),
        child: Divider(color: Colors.grey.shade200, height: 1.0),
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _stops,
      builder: (context, snapshot) {
        List<Map<String, dynamic>> stopsList = [];

        // Logica Skeletonizer: Genera dati finti se sta caricando
        if (isLoading) {
          stopsList = List.generate(
            6,
            (index) => {
              'name': 'Fermata Bus Caricamento',
              'lat': 0.0,
              'lng': 0.0,
              'distance_meters':
                  150.0, // Un valore fittizio per mostrare i metri
            },
          );
        } else if (snapshot.hasData) {
          stopsList = snapshot.data!;
        }

        return Skeletonizer.sliver(
          enabled: isLoading,
          child: (!isLoading && (snapshot.hasError || stopsList.isEmpty))
              ? SliverFillRemaining(
                  hasScrollBody: false,
                  child: Center(
                    child: snapshot.hasError
                        ? Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              AppLocalizations.of(
                                    context,
                                  )?.translate("Error") ??
                                  "Si è verificato un errore.\n${snapshot.error}",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.red),
                            ),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.location_off,
                                size: 48,
                                color: Colors.grey,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                AppLocalizations.of(
                                      context,
                                    )?.translate("NoStops") ??
                                    "Nessuna fermata trovata",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                  ),
                )
              : _buildStopsList(context, stopsList),
        );
      },
    );
  }

  Widget _buildStopsList(
    BuildContext context,
    List<Map<String, dynamic>> stops,
  ) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final stop = stops[index];
        return _buildStopItem(context, stop);
      }, childCount: stops.length),
    );
  }

  Widget _buildStopItem(BuildContext context, Map<String, dynamic> stop) {
    // Formattazione della distanza per renderla leggibile (es: "150 m" o "1.2 km")
    String distanceInfo = "";
    if (stop['distance_meters'] != null) {
      double dist = stop['distance_meters'] is int
          ? (stop['distance_meters'] as int).toDouble()
          : stop['distance_meters'];

      if (dist < 1000) {
        distanceInfo = "${dist.toStringAsFixed(0)} m";
      } else {
        distanceInfo = "${(dist / 1000).toStringAsFixed(1)} km";
      }
    }

    return Column(
      children: [
        ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(
              context,
            ).colorScheme.primary.withAlpha(100),
            child: Icon(
              Icons.directions_bus,
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
          title: Text(
            stop['name'] ?? 'Nome non disponibile',
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          subtitle: Row(
            children: [
              if (distanceInfo.isNotEmpty) ...[
                Icon(
                  Icons.directions_walk,
                  size: 14,
                  color: Theme.of(
                    context,
                  ).colorScheme.onSurfaceVariant.withAlpha(180),
                ),
                const SizedBox(width: 4),
                Text(
                  distanceInfo,
                  style: Theme.of(context).textTheme.bodySmall!.copyWith(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurfaceVariant.withAlpha(180),
                  ),
                ),
              ],
            ],
          ),
          trailing: Icon(
            Icons.arrow_forward_ios,
            size: 20,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          onTap: () {
            if (widget.onStopClick != null) {
              widget.onStopClick!(stop);
            }
          },
        ),
        Divider(color: Colors.grey.shade200, height: 1),
      ],
    );
  }
}
