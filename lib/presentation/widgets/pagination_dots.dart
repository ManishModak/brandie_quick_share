import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';

class PaginationDots extends StatelessWidget {
  const PaginationDots({
    super.key,
    required this.count,
    required this.activeIndex,
  });

  final int count;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppDimens.dotsPadding),
      decoration: BoxDecoration(
        color: AppColors.paginationDotBg,
        borderRadius: BorderRadius.circular(AppDimens.dotsContainerRadius),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < count; i += 1) ...[
            Container(
              width: AppDimens.dotSize,
              height: AppDimens.dotSize,
              decoration: BoxDecoration(
                color: i == activeIndex
                    ? AppColors.activeGreen
                    : AppColors.white,
                shape: BoxShape.circle,
              ),
            ),
            if (i != count - 1) const SizedBox(height: AppDimens.dotsGap),
          ],
        ],
      ),
    );
  }
}
