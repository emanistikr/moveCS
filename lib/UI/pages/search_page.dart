import 'dart:async';
import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';
import '../../controller/app_localization.dart';
import '../../models/search_category.dart';
import '../../models/search_result.dart';
import '../../repositories/search_repository.dart';
import 'bus_route_page.dart';

class SearchPage extends StatefulWidget {
  final String? addressQuery;

  const SearchPage({this.addressQuery, super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();
  final TextEditingController _searchController = TextEditingController();
  final SearchRepository _searchRepository = SearchRepository();

  List<SearchResult> _searchResults = [];
  bool _isLoading = false;
  SearchCategory _selectedCategory = SearchCategory.places;

  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    if (widget.addressQuery != null) {
      _searchController.text = widget.addressQuery ?? "";
      _onSearchChanged(widget.addressQuery ?? "");
    }

    // Ritarda il focus per non far buggare la tastiera
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      _performSearch(query);
    });
  }

  Future<void> _performSearch(String query) async {
    setState(() {
      _isLoading = true;
    });

    final results = await _searchRepository.search(
      query: query,
      category: _selectedCategory,
    );

    setState(() {
      _searchResults = results;
      _isLoading = false;
    });
  }

  void _categoryChanged(SearchCategory category) {
    setState(() {
      _selectedCategory = category;
    });
    _performSearch(_searchController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Column(
          children: [_searchbar(), _searchSelector(), _showSearchResults()],
        ),
      ),
    );
  }

  Widget _searchbar() {
    //l'hero serve per animare la searchbar da una pagina all'altra
    return Hero(
      tag: 'searchBar',
      child: Material(
        color: Colors.transparent,
        child: Container(
          height: 66,
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            color: Theme.of(context).colorScheme.surface,
            boxShadow: [WidgetStyles.shadowDownStyle(context)],
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.only(top: 10, left: 20, right: 20),
          child: Row(
            children: [
              //pulsante indietro
              InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(
                  Icons.arrow_back_rounded,
                  color: Theme.of(context).colorScheme.onSurface,
                  size: 30,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  focusNode: _focusNode,
                  autofocus: false,
                  decoration: InputDecoration(
                    hintText:
                        AppLocalizations.of(context)?.translate("where?") ?? "",
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                  onChanged: (value) {
                    _onSearchChanged(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _searchSelector() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _selectorTabItem(
                "Places",
                Icons.location_on_outlined,
                SearchCategory.places,
              ),
              Container(
                height: 30,
                width: 1,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              _selectorTabItem(
                "Stops",
                Icons.push_pin_outlined,
                SearchCategory.stops,
              ),
              Container(
                height: 30,
                width: 1,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
              _selectorTabItem(
                "Lines",
                Icons.directions_bus_outlined,
                SearchCategory.lines,
              ),
            ],
          ),
        ),
        //linea di separazione
        Divider(
          height: 1,
          thickness: 1,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ],
    );
  }

  Widget _selectorTabItem(
    String label,
    IconData icon,
    SearchCategory category,
  ) {
    final isSelected = _selectedCategory == category;
    final color = isSelected
        ? Theme.of(context).colorScheme.onSurface
        : Theme.of(
            context,
          ).colorScheme.onSurfaceVariant; // Usa i tuoi AppColors

    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _categoryChanged(category);
        });
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Row(
          children: [
            Icon(icon, size: 25, color: color),
            const SizedBox(width: 6),
            Text(
              AppLocalizations.of(context)?.translate(label) ?? "",
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _showSearchResults() {
    return Expanded(
      child: _isLoading
          ? const Center(child: CircularProgressIndicator()) // Spinner
          : ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                final result = _searchResults[index];
                return Column(
                  children: [
                    ListTile(
                      leading: Icon(
                        result.type == SearchCategory.places
                            ? Icons.place
                            : Icons.directions_bus,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        size: 20,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                      title: Text(result.title),
                      subtitle: Text(result.subtitle),
                      onTap: () async {
                        if (result.type == SearchCategory.places) {
                          (String, String)? placePos = await SearchRepository()
                              .getPlaceDetails(result.id);

                          //aggiungo la posizione al result
                          SearchResult newResult = SearchResult(
                            id: result.id,
                            title: result.title,
                            subtitle: result.subtitle,
                            type: result.type,
                            lat: placePos?.$1,
                            lng: placePos?.$2,
                          );

                          Navigator.of(context).pop(newResult);
                        } else if (result.type == SearchCategory.lines) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  BusRoutePage(routeName: result.id),
                            ),
                          );
                        } else {
                          Navigator.of(context).pop(result);
                        }
                      },
                    ),
                    Divider(
                      height: 1,
                      thickness: 1,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                );
              },
            ),
    );
  }
}
