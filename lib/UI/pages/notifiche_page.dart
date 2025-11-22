import 'package:flutter/material.dart';
import '../../config/app_text_styles.dart';

class NotifichePage extends StatelessWidget {
  const NotifichePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Welcome to Notifiche Page!', style: AppTextStyles.title),
      ),
    );
  }
}
