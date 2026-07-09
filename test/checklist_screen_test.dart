import 'package:brandie_quick_share/core/app_theme.dart';
import 'package:brandie_quick_share/data/data.dart';
import 'package:brandie_quick_share/presentation/screens/smart_post_checklist_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('checklist flow completes and lands on QuickShareScreen', (
    tester,
  ) async {
    // Pin the surface to the design viewport (375x812 portrait) so the
    // fixed-position overlays layout as designed.
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const SmartPostChecklistScreen(
          repository: MockPostRepository(),
          stepDuration: Duration(milliseconds: 10),
        ),
      ),
    );
    await tester.pump();

    expect(
      find.text('Building personalised\nSmart Posts for you!'),
      findsOneWidget,
    );

    await tester.pump(const Duration(milliseconds: 40));
    await tester.pump();
    expect(find.text('All set! Get ready to share...'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 900));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Smart Post'), findsOneWidget);
    expect(find.text('Quick share to:'), findsOneWidget);
  });
}
