import 'package:flutter/material.dart';
import 'UI/pages/App.dart';
import 'config/app_theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MoveCS',
      theme: AppTheme.light,
      debugShowCheckedModeBanner: false,
      home: const App(),
    );
  }
}
