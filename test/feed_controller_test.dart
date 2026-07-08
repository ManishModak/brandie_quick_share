import 'package:brandie_quick_share/logic/feed_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('FeedController', () {
    test('clamps page changes and formats counter label', () {
      final controller = FeedController(postCount: 3);

      expect(controller.activeIndex, 0);
      expect(controller.counterLabel, '1 of 3');

      controller.onPageChanged(2);
      expect(controller.activeIndex, 2);
      expect(controller.counterLabel, '3 of 3');

      controller.onPageChanged(99);
      expect(controller.activeIndex, 2);

      controller.onPageChanged(-4);
      expect(controller.activeIndex, 0);
      expect(controller.counterLabel, '1 of 3');
    });

    test('does not notify when clamped index is unchanged', () {
      final controller = FeedController(postCount: 3, initialIndex: 2);
      var notifications = 0;
      controller.addListener(() => notifications += 1);

      controller.onPageChanged(2);
      controller.onPageChanged(99);

      expect(notifications, 0);

      controller.onPageChanged(1);
      expect(notifications, 1);
    });

    test('handles empty feeds', () {
      final controller = FeedController(postCount: 0);

      expect(controller.activeIndex, 0);
      expect(controller.counterLabel, '0 of 0');
    });
  });
}
