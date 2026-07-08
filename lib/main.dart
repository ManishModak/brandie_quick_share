import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'presentation/screens/quick_share_screen.dart';

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
      home: const QuickShareScreen(),
    );
  }
}
