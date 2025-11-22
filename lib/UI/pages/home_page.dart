import 'package:code/config/app_text_styles.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Cosenza!', style: AppTextStyles.title),
      ),
    );
  }
}
