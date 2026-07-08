import 'package:brandie_quick_share/domain/domain.dart';
import 'package:brandie_quick_share/logic/share_flow_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const steps = [
    ShareStep(label: 'Generating your sales link..', progress: 0.34),
    ShareStep(label: 'Copying the caption to clipboard', progress: 0.55),
    ShareStep(label: 'Saving the content to your profile', progress: 0.78),
    ShareStep(label: 'Preparing the content for social media', progress: 1),
  ];

  const platform = SharePlatform(
    id: 'instagram-post',
    label: 'Instagram Post',
    kind: PlatformKind.post,
    brandColor: 0xFFE4405F,
    splash: SplashBranding(appName: 'Instagram', showFromMeta: true),
  );

  group('ShareFlowController', () {
    test('runs all steps, redirects, then completes', () {
      fakeAsync((async) {
        final controller = ShareFlowController(
          steps: steps,
          stepDuration: const Duration(milliseconds: 10),
          redirectDuration: const Duration(milliseconds: 20),
        );

        controller.start(platform);
        expect(controller.phase, ShareFlowPhase.generating);
        expect(controller.activePlatform, platform);
        expect(controller.currentStep?.label, steps[0].label);
        expect(controller.progress, 0.34);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.currentStep?.label, steps[1].label);
        expect(controller.progress, 0.55);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.currentStep?.label, steps[2].label);
        expect(controller.progress, 0.78);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.currentStep?.label, steps[3].label);
        expect(controller.progress, 1);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.phase, ShareFlowPhase.redirecting);
        expect(controller.currentStep, isNull);
        expect(controller.progress, 0);

        async.elapse(const Duration(milliseconds: 20));
        expect(controller.phase, ShareFlowPhase.done);
      });
    });

    test('cancel mid-generation returns to idle and stops timers', () {
      fakeAsync((async) {
        final controller = ShareFlowController(
          steps: steps,
          stepDuration: const Duration(milliseconds: 10),
          redirectDuration: const Duration(milliseconds: 20),
        );

        controller.start(platform);
        async.elapse(const Duration(milliseconds: 10));
        controller.cancel();

        expect(controller.phase, ShareFlowPhase.idle);
        expect(controller.currentStep, isNull);
        expect(controller.activePlatform, isNull);

        async.elapse(const Duration(milliseconds: 100));
        expect(controller.phase, ShareFlowPhase.idle);
      });
    });

    test('double start is ignored while active', () {
      fakeAsync((async) {
        final controller = ShareFlowController(
          steps: steps,
          stepDuration: const Duration(milliseconds: 10),
          redirectDuration: const Duration(milliseconds: 20),
        );

        controller.start(platform);
        controller.start(
          const SharePlatform(
            id: 'facebook-post',
            label: 'Facebook Post',
            kind: PlatformKind.post,
            brandColor: 0xFF1877F2,
            splash: SplashBranding(appName: 'Facebook', showFromMeta: true),
          ),
        );

        expect(controller.activePlatform, platform);
        expect(controller.currentStep?.label, steps[0].label);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.currentStep?.label, steps[1].label);
      });
    });
  });
}
