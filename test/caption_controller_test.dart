import 'package:brandie_quick_share/logic/caption_controller.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CaptionController', () {
    test('canSave follows draft validation rules', () {
      final controller = CaptionController(initialText: 'Original caption');

      expect(controller.canSave, isFalse);

      controller.updateDraft('Updated caption');
      expect(controller.canSave, isTrue);

      controller.updateDraft('Original caption');
      expect(controller.canSave, isFalse);

      controller.updateDraft('');
      expect(controller.canSave, isFalse);

      controller.updateDraft('   ');
      expect(controller.canSave, isFalse);
    });

    test('save commits trimmed draft as new original', () {
      final controller = CaptionController(initialText: 'Original caption');

      controller.updateDraft('  New caption  ');
      controller.save();

      expect(controller.originalText, 'New caption');
      expect(controller.draftText, 'New caption');
      expect(controller.canSave, isFalse);
    });

    test('discard reverts draft to original', () {
      final controller = CaptionController(initialText: 'Original caption');

      controller.updateDraft('Temporary edit');
      controller.discard();

      expect(controller.draftText, 'Original caption');
      expect(controller.canSave, isFalse);
    });

    test('toggleExpanded flips see-more state', () {
      final controller = CaptionController(initialText: 'Original caption');

      expect(controller.isExpanded, isFalse);
      controller.toggleExpanded();
      expect(controller.isExpanded, isTrue);
      controller.toggleExpanded();
      expect(controller.isExpanded, isFalse);
    });
  });
}
