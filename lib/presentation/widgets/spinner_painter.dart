import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';

class SpinnerPainter extends CustomPainter {
  const SpinnerPainter({
    this.color = AppColors.activeGreen,
    this.trackColor,
    this.strokeWidth = AppDimens.shareSpinnerStroke,
  });

  final Color color;
  final Color? trackColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final radius = math.min(size.width, size.height) / 2;
    final center = Offset(size.width / 2, size.height / 2);
    final rect = Rect.fromCircle(center: center, radius: radius - 2);

    final trackPaint = Paint()
      ..color = trackColor ?? AppColors.wordmark.withValues(alpha: 0.1)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    final activePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius - 2, trackPaint);
    canvas.drawArc(rect, -math.pi / 2, 1.33 * math.pi, false, activePaint);
  }

  @override
  bool shouldRepaint(covariant SpinnerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
