import 'package:flutter/material.dart';
import '../../../controller/app_localization.dart';

class NearStopsPanel extends StatefulWidget {
  final Map<String, dynamic>? data;
  final ScrollController scrollController;

  const NearStopsPanel({
    super.key,
    required this.data,
    required this.scrollController,
  });

  @override
  State<NearStopsPanel> createState() => _NearStopsPanelState();
}

class _NearStopsPanelState extends State<NearStopsPanel> {
  @override
  Widget build(BuildContext context) {
    // la stringa da mostrare dipende se è "vicino a me" o "vicino a [nome luogo]"
    String _nearWho = (widget.data != null)
        ? (widget.data!['id'] == '0')
              ? 'me'
              : widget.data!['name']
        : '';

    return CustomScrollView(
      controller: widget.scrollController,
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        _buildAppBar(context, _nearWho),

        SliverFillRemaining(
          hasScrollBody: false,
          child: Container(color: Theme.of(context).canvasColor),
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
    );
  }
}
