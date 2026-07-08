import 'package:flutter/services.dart';

abstract final class HapticFeedbackService {
  static Future<void> selectionClick() => HapticFeedback.selectionClick();

  static Future<void> lightImpact() => HapticFeedback.lightImpact();

  static Future<void> mediumImpact() => HapticFeedback.mediumImpact();
}
