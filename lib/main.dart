import 'package:flutter/material.dart';

import 'core/app_theme.dart';
import 'data/data.dart';
import 'presentation/screens/smart_post_checklist_screen.dart';

void main() {
  final PostRepository repository = MockPostRepository();
  runApp(BrandieQuickShareApp(repository: repository));
}

class BrandieQuickShareApp extends StatelessWidget {
  const BrandieQuickShareApp({super.key, required this.repository});

  final PostRepository repository;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Brandie Quick Share',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,
      home: SmartPostChecklistScreen(repository: repository),
    );
  }
}
