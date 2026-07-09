import 'package:brandie_quick_share/logic/product_overlay_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ProductOverlayController', () {
    test('stays hidden before delay and becomes visible after delay', () {
      fakeAsync((async) {
        final controller = ProductOverlayController(
          delay: const Duration(seconds: 3),
        );

        controller.arm();
        async.elapse(const Duration(seconds: 2));
        expect(controller.isVisible, isFalse);

        async.elapse(const Duration(seconds: 1));
        expect(controller.isVisible, isTrue);
      });
    });

    test('arm during countdown restarts the countdown', () {
      fakeAsync((async) {
        final controller = ProductOverlayController(
          delay: const Duration(seconds: 3),
        );

        controller.arm();
        async.elapse(const Duration(seconds: 2));
        controller.arm();
        async.elapse(const Duration(seconds: 2));
        expect(controller.isVisible, isFalse);

        async.elapse(const Duration(seconds: 1));
        expect(controller.isVisible, isTrue);
      });
    });

    test('reset cancels countdown and hides visible overlay', () {
      fakeAsync((async) {
        final controller = ProductOverlayController(
          delay: const Duration(seconds: 3),
        );

        controller.arm();
        async.elapse(const Duration(seconds: 1));
        controller.reset();
        async.elapse(const Duration(seconds: 3));
        expect(controller.isVisible, isFalse);

        controller.arm();
        async.elapse(const Duration(seconds: 3));
        expect(controller.isVisible, isTrue);

        controller.reset();
        expect(controller.isVisible, isFalse);
      });
    });

    test('dismiss hides visible overlay and notifies listeners', () {
      fakeAsync((async) {
        final controller = ProductOverlayController(
          delay: const Duration(seconds: 3),
        );

        controller.arm();
        async.elapse(const Duration(seconds: 3));
        expect(controller.isVisible, isTrue);

        var notifications = 0;
        controller.addListener(() => notifications += 1);
        controller.dismiss();

        expect(controller.isVisible, isFalse);
        expect(notifications, 1);
      });
    });

    test('does not fire callbacks after dispose', () {
      fakeAsync((async) {
        final controller = ProductOverlayController(
          delay: const Duration(seconds: 3),
        );

        controller.arm();
        controller.dispose();
        async.elapse(const Duration(seconds: 3));

        expect(controller.isVisible, isFalse);
      });
    });
  });
}
