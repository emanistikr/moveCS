import 'package:flutter/material.dart';
import '../../config/widget_decoration/widget_styles.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    // Ritarda il focus per non far buggare la tastiera
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            //l'hero serve per animare la searchbar da una pagina all'altra
            Hero(
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
                          focusNode: _focusNode,
                          autofocus: false,
                          decoration: InputDecoration(
                            hintText: 'Dove vuoi andare?', //TODO: localizzare
                            border: InputBorder.none,
                            isCollapsed: true,
                          ),
                          onChanged: (value) {
                            // TODO: filtra risultati
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
