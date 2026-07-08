import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';

class CategoryTabs extends StatelessWidget {
  const CategoryTabs({super.key});

  static const _tabs = ['Smart Post', 'Library', 'Communities', 'Share&Win'];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.headerHeight - AppDimens.topActionsHeight,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppDimens.tabsHorizontalPadding,
            vertical: AppDimens.tabsVerticalPadding,
          ),
          child: Row(
            children: [
              for (var i = 0; i < _tabs.length; i += 1) ...[
                Text(
                  _tabs[i],
                  style: AppTypography.categoryTabs.copyWith(
                    color: i == 0
                        ? AppColors.activeGreen
                        : AppColors.inactiveText,
                  ),
                ),
                if (i != _tabs.length - 1)
                  const SizedBox(width: AppDimens.tabsGap),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
