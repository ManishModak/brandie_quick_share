import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';

class PageCounterPill extends StatelessWidget {
  const PageCounterPill({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.counterHorizontalPadding,
        vertical: AppDimens.counterVerticalPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOverlay,
        borderRadius: BorderRadius.circular(AppDimens.counterRadius),
      ),
      child: Text(label, style: AppTypography.counter),
    );
  }
}
