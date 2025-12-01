import 'package:flutter/material.dart';

class WidgetStyles {
  static BoxShadow shadowDownStyle(BuildContext context) {
    return BoxShadow(
      color: Colors.black12,
      blurRadius: 12,
      offset: Offset(0, 3),
    );
  }

  static BoxShadow shadowUpStyle(BuildContext context) {
    return BoxShadow(
      color: Colors.black12,
      blurRadius: 12,
      offset: Offset(0, -3),
    );
  }

  static BoxDecoration elevatedButtonDecoration(BuildContext context) {
    return BoxDecoration(
      borderRadius: BorderRadius.circular(50),
      color: Theme.of(context).colorScheme.surface,
      boxShadow: [shadowDownStyle(context)],
    );
  }
}
