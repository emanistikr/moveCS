import 'package:flutter/material.dart';

class NotifichePage extends StatelessWidget {
  final VoidCallback? onBack; // Aggiungi questo callback
  const NotifichePage({super.key, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Notifiche Page!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
