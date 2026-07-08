import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';
import 'platform_icon.dart';

class QuickShareBar extends StatelessWidget {
  const QuickShareBar({
    super.key,
    required this.platforms,
    required this.onPlatformTap,
  });

  final List<SharePlatform> platforms;
  final ValueChanged<SharePlatform> onPlatformTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.quickShareHeight,
      child: Row(
        children: [
          Text(
            'Quick share to:',
            style: AppTypography.labels.copyWith(color: AppColors.white),
          ),
          const SizedBox(width: AppDimens.quickShareGap),
          Expanded(
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: platforms.length,
              separatorBuilder: (context, index) =>
                  const SizedBox(width: AppDimens.platformGap),
              itemBuilder: (context, index) {
                final platform = platforms[index];
                return PlatformIcon(
                  platform: platform,
                  onTap: () => onPlatformTap(platform),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
