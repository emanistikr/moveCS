import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class ProfiloPage extends StatelessWidget {
  const ProfiloPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Profilo Page!', style: AppTextStyles.title),
      ),
    );
  }
}
