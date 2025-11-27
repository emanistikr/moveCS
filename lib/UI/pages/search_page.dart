import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/widget_decoration/app_button_decoration.dart';

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
      backgroundColor: Colors.red,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              //l'hero serve per animare la searchbar da una pagina all'altra
              Hero(
                tag: 'searchBar',
                child: Material(
                  color: Colors.transparent,
                  child: Container(
                    height: 56,
                    width: double.infinity,
                    decoration: AppButtonDecoration.elevatedButtonDecoration,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        //pulsante indietro
                        InkWell(
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                          child: const Icon(
                            Icons.arrow_back_rounded,
                            color: AppColors.darkElements,
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
      ),
    );
  }
}
