import 'package:flutter/material.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(
          'Welcome to Wallet Page!',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
    );
  }
}
