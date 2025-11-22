import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class WalletPage extends StatelessWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Wallet Page!', style: AppTextStyles.title),
      ),
    );
  }
}
