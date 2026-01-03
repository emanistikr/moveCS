import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';

class MainPanel extends StatefulWidget {
  final ScrollController scrollController;

  const MainPanel({super.key, required this.scrollController});

  @override
  State<MainPanel> createState() => _MainPanelState();
}

class _MainPanelState extends State<MainPanel> {
  @override
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(),
        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(), // o un messaggio "Nessuna info"
        ),
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
}
