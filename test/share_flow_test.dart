import 'package:brandie_quick_share/core/app_theme.dart';
import 'package:brandie_quick_share/data/data.dart';
import 'package:brandie_quick_share/presentation/screens/quick_share_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('share flow shows progress, splash, then returns to feed', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const QuickShareScreen(
          repository: MockPostRepository(),
          productOverlayDelay: Duration(minutes: 1),
          shareStepDuration: Duration(milliseconds: 10),
          redirectDuration: Duration(milliseconds: 20),
        ),
      ),
    );
    await tester.pump();

    await tester.tap(find.bySemanticsLabel('Instagram Post'));
    await tester.pump();

    expect(find.text('Generating your sales link..'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 40));
    await tester.pump();

    expect(find.text('from'), findsOneWidget);
    expect(find.text('Meta'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 20));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Smart Post'), findsOneWidget);
    expect(find.text('Generating your sales link..'), findsNothing);
  });
}
