import 'package:brandie_quick_share/core/app_theme.dart';
import 'package:brandie_quick_share/data/data.dart';
import 'package:brandie_quick_share/presentation/screens/quick_share_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('QuickShareScreen renders the static feed chrome', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const QuickShareScreen(repository: MockPostRepository()),
      ),
    );
    await tester.pump();

    expect(find.text('Smart Post'), findsOneWidget);
    expect(find.text('Library'), findsOneWidget);
    expect(find.text('Communities'), findsOneWidget);
    expect(find.text('Share&Win'), findsOneWidget);
    expect(find.text('Quick share to:'), findsOneWidget);
    expect(find.text('1 of 3'), findsOneWidget);
    expect(find.text('Edit Caption'), findsOneWidget);
  });
}
