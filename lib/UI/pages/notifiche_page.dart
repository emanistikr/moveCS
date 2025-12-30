import 'package:flutter/material.dart';

class NotifichePage extends StatelessWidget {
  const NotifichePage({super.key});

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
