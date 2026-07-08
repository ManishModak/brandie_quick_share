import 'package:brandie_quick_share/core/app_theme.dart';
import 'package:brandie_quick_share/presentation/screens/quick_share_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('edit caption save updates the feed card', (tester) async {
    // Pin the surface to the design viewport (375x812 portrait); on shorter
    // surfaces the bottom nav overlay sits over the caption card footer and
    // intercepts the "Edit Caption" tap.
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const QuickShareScreen(productOverlayDelay: Duration(minutes: 1)),
      ),
    );

    await tester.tap(find.text('Edit Caption'));
    // Two pumps: the pushed route's overlay entry is built offstage on the
    // first frame and only comes onstage once the transition starts.
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    final saveButton = find.widgetWithText(TextButton, 'Save');
    expect(tester.widget<TextButton>(saveButton).onPressed, isNull);

    const updatedCaption = 'Updated caption from widget test';
    await tester.enterText(find.byType(TextField), updatedCaption);
    await tester.pump();
    expect(tester.widget<TextButton>(saveButton).onPressed, isNotNull);

    await tester.tap(saveButton);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text(updatedCaption), findsOneWidget);
    expect(find.text('Edit Caption'), findsOneWidget);
  });
}
