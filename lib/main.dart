import 'package:flutter/material.dart';
import 'UI/pages/home_page.dart';
import 'config/app_theme.dart';
import './config/app_constants.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}
