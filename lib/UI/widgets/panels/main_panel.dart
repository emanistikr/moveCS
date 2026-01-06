import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';
import '../../../controller/favorites_manager.dart';
import '../../../controller/address_manager.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../controller/info_lines.dart';
import '../horizontal_bus_list.dart';
import '../../pages/search_page.dart';
import '../../../models/search_result.dart';

class MainPanel extends StatefulWidget {
  final ScrollController scrollController;
  final Function(String, Map<String, dynamic>)? onMarkerTap;

  const MainPanel({
    super.key,
    required this.scrollController,
    required this.onMarkerTap,
  });

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  bool isLoading = true;
  String homeAddress = "";
  String workAddress = "";

  List<String> favoriteStops = [];

  @override
  void initState() {
    super.initState();
    _loadAddresses();
    _loadFavorites();
  }

  void _loadFavorites() async {
    await InfoLines.getBusLines(); // Preload linee bus

    setState(() {
      isLoading = true;
    });

    favoriteStops = await FavoritesManager().getFavorites();

    if (mounted) {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _loadAddresses() async {
    homeAddress = await AddressManager().getHomeAddress() ?? "";
    workAddress = await AddressManager().getWorkAddress() ?? "";

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(),
        _buidBody(),
        SliverFillRemaining(hasScrollBody: false, child: Container()),
      ],
    );
  }

  SliverAppBar _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 80,
      pinned: true,
      automaticallyImplyLeading: false,
      backgroundColor: Theme.of(context).canvasColor,
      title: Text(
        AppLocalizations.of(context)?.translate("StartNavigating") ?? "",
        style: Theme.of(context).textTheme.titleLarge,
      ),
      centerTitle: true,
    );
  }

  Widget _buidBody() {
    final List<String> displayStops = isLoading
        ? ['L1', 'L2', 'L3', 'L4']
        : favoriteStops;

    return Skeletonizer.sliver(
      effect: ShimmerEffect(
        baseColor: Theme.of(
          context,
        ).colorScheme.onPrimaryContainer.withAlpha(50),
        highlightColor: Theme.of(context).colorScheme.onPrimaryContainer,
        duration: Duration(seconds: 1),
      ),
      enabled: isLoading,
      child: SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate("favoriteLines") ??
                        "Favorite Lines",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 70,
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 10),
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(100),
                    width: 2,
                  ),
                ),
                child: displayStops.isEmpty
                    ? Center(
                        child: Text(
                          AppLocalizations.of(
                                context,
                              )?.translate("noFavorites") ??
                              "No favorite lines yet!",
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : HorizontalBusList(
                        lines: displayStops,
                        onFavoritesUpdated: () {
                          _loadFavorites();
                        },
                      ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)?.translate("myAddresses") ??
                        "My addresses",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  InkWell(
                    onTap: () {
                      _showAddressDialog(context);
                    },
                    child: Text(
                      AppLocalizations.of(context)?.translate("edit") ?? "edit",
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(
                    color: Theme.of(
                      context,
                    ).colorScheme.onSurface.withAlpha(100),
                    width: 2,
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        _onAddressPressed(homeAddress);
                      },
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.home_outlined,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)?.translate("house") ??
                              "House",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        subtitle: Text(
                          homeAddress == ""
                              ? AppLocalizations.of(
                                      context,
                                    )?.translate("noAddresses") ??
                                    "No address set"
                              : homeAddress,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(fontSize: 15),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                          size: 20,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _onAddressPressed(workAddress);
                      },
                      child: ListTile(
                        leading: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                          ),
                          child: Icon(
                            Icons.work_outline,
                            color: Theme.of(
                              context,
                            ).colorScheme.onPrimaryContainer,
                            size: 28,
                          ),
                        ),
                        title: Text(
                          AppLocalizations.of(context)?.translate("work") ??
                              "Work",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                        subtitle: Text(
                          workAddress == ""
                              ? AppLocalizations.of(
                                      context,
                                    )?.translate("noAddresses") ??
                                    "No address set"
                              : workAddress,
                          style: Theme.of(
                            context,
                          ).textTheme.bodySmall!.copyWith(fontSize: 15),
                        ),
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Theme.of(
                            context,
                          ).colorScheme.onSurface.withAlpha(150),
                          size: 20,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _onAddressPressed(String address) async {
    //logica per aprire la pagina di ricerca e gestire il risultato
    final searchPageResult = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SearchPage(addressQuery: address),
      ),
    );
    if (searchPageResult != null && searchPageResult is SearchResult) {
      onSearchResultSelected(searchPageResult);
    }
  }

  Future<void> onSearchResultSelected(SearchResult searchPageResult) async {
    if (searchPageResult.data == null) {
      double? lat = double.tryParse(searchPageResult.lat ?? "");
      double? lng = double.tryParse(searchPageResult.lng ?? "");

      final selectedPositionData = {
        'id': '1',
        'code': searchPageResult.id,
        'name': searchPageResult.title,
        'lat': lat,
        'lng': lng,
      };
      await widget.onMarkerTap!('1', selectedPositionData);
      if (mounted) {
        setState(() {});
      }
    } else {
      await widget.onMarkerTap!(searchPageResult.id, searchPageResult.data!);
    }
  }

  Future<void> _showAddressDialog(BuildContext context) async {
    // Crea i controller per catturare il testo
    final TextEditingController _homeController = TextEditingController();
    final TextEditingController _workController = TextEditingController();

    _homeController.text = homeAddress;
    _workController.text = workAddress;

    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            AppLocalizations.of(context)?.translate("myAddresses") ??
                "My addresses",
            style: Theme.of(context).textTheme.titleMedium,
          ),

          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                autofocus: true,
                controller: _homeController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.translate("home") ?? 'Home',
                  hintText: 'Es. Via Roma, 10',
                  prefixIcon: Icon(Icons.home_outlined),
                  border: OutlineInputBorder(),
                ),
                textInputAction:
                    TextInputAction.next, //tasto Avanti sulla tastiera
              ),

              const SizedBox(height: 15),
              TextField(
                controller: _workController,
                decoration: InputDecoration(
                  labelText:
                      AppLocalizations.of(context)?.translate("work") ?? 'Work',
                  hintText: 'Es. Via Milano, 20',
                  prefixIcon: Icon(Icons.work_outline), // Icona carina
                  border: OutlineInputBorder(),
                ),
                textInputAction: TextInputAction.done,
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)?.translate("cancel") ?? "CANCEL",
              ),
              onPressed: () => Navigator.pop(context),
            ),
            TextButton(
              child: Text(
                AppLocalizations.of(context)?.translate("save") ?? "SAVE",
              ),
              onPressed: () async {
                await AddressManager().saveAddresses(
                  home: _homeController.text,
                  work: _workController.text,
                );

                if (context.mounted) {
                  Navigator.pop(context);
                }

                _loadAddresses();
              },
            ),
          ],
        );
      },
    );
  }
}
