import 'package:brandie_quick_share/domain/domain.dart';
import 'package:brandie_quick_share/logic/checklist_controller.dart';
import 'package:fake_async/fake_async.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  const steps = [
    ChecklistStep(label: 'Preparing popular content for you'),
    ChecklistStep(label: 'Crafting a caption to boost engagement'),
    ChecklistStep(label: 'Adding your personal referral link and code'),
    ChecklistStep(label: 'Finding trending songs on other social media'),
  ];

  group('ChecklistController', () {
    test('progresses pending to loading to completed in order', () {
      fakeAsync((async) {
        final controller = ChecklistController(
          steps: steps,
          stepDuration: const Duration(milliseconds: 10),
        );
        final snapshots = <List<StepStatus>>[];
        controller.addListener(() => snapshots.add(controller.statuses));

        expect(controller.statuses, List.filled(4, StepStatus.pending));

        controller.start();
        expect(controller.statuses, [
          StepStatus.loading,
          StepStatus.pending,
          StepStatus.pending,
          StepStatus.pending,
        ]);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.statuses, [
          StepStatus.completed,
          StepStatus.loading,
          StepStatus.pending,
          StepStatus.pending,
        ]);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.statuses, [
          StepStatus.completed,
          StepStatus.completed,
          StepStatus.loading,
          StepStatus.pending,
        ]);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.statuses, [
          StepStatus.completed,
          StepStatus.completed,
          StepStatus.completed,
          StepStatus.loading,
        ]);

        async.elapse(const Duration(milliseconds: 10));
        expect(controller.statuses, [
          StepStatus.completed,
          StepStatus.completed,
          StepStatus.completed,
          StepStatus.completed,
        ]);
        expect(controller.isAllDone, isTrue);

        expect(snapshots, [
          [
            StepStatus.loading,
            StepStatus.pending,
            StepStatus.pending,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.pending,
            StepStatus.pending,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.loading,
            StepStatus.pending,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.pending,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.loading,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.pending,
          ],
          [
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.loading,
          ],
          [
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.completed,
            StepStatus.completed,
          ],
        ]);
      });
    });

    test('dispose mid-run cancels cleanly', () {
      fakeAsync((async) {
        final controller = ChecklistController(
          steps: steps,
          stepDuration: const Duration(milliseconds: 10),
        );

        controller.start();
        controller.dispose();
        async.elapse(const Duration(milliseconds: 100));

        expect(controller.statuses.first, StepStatus.loading);
        expect(controller.isAllDone, isFalse);
      });
    });

    test('empty list is all done after start', () {
      final controller = ChecklistController(steps: const []);

      expect(() => controller.start(), returnsNormally);
      expect(controller.isAllDone, isTrue);
    });
  });
}
