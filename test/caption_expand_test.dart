import 'package:brandie_quick_share/core/app_theme.dart';
import 'package:brandie_quick_share/presentation/screens/quick_share_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('expanded caption keeps edit footer tappable', (tester) async {
    tester.view.physicalSize = const Size(375, 812);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light,
        home: const QuickShareScreen(productOverlayDelay: Duration(minutes: 1)),
      ),
    );

    await tester.tap(find.text('See More'));
    await tester.pumpAndSettle();

    final editCaption = find.text('Edit Caption');
    expect(editCaption, findsOneWidget);
    expect(tester.getCenter(editCaption).dy, lessThan(700));

    await tester.tap(editCaption);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Save'), findsOneWidget);
  });
}
