import 'package:flutter/material.dart';

import 'core/app_theme.dart';

void main() {
  runApp(const BrandieQuickShareApp());
}

class BrandieQuickShareApp extends StatelessWidget {
  const BrandieQuickShareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brandie Quick Share',
      theme: AppTheme.light,
      home: const Scaffold(
        body: Center(child: Text('Brandie Quick Share — scaffold')),
      ),
    );
  }
}
