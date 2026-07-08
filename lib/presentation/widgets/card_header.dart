import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({super.key, required this.post});

  final SmartPost post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppDimens.avatar,
          height: AppDimens.avatar,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.avatarBorder,
              width: AppDimens.avatarBorderWidth,
            ),
          ),
          child: const CircleAvatar(
            backgroundColor: AppColors.activeGreen,
            // Placeholder because no avatar asset is provided in Phase 3.
            child: Text(
              'A',
              style: TextStyle(
                fontFamily: AppTypography.fontFamily,
                fontWeight: FontWeight.w700,
                color: AppColors.white,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimens.cardHeaderGap),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: AppDimens.readyPillHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppDimens.readyPillHorizontalPadding,
              ),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.tagPurple, AppColors.tagPink],
                ),
                borderRadius: BorderRadius.circular(AppDimens.headerTagRadius),
              ),
              child: const Text(
                '✦ Ready to share',
                style: AppTypography.readyPill,
              ),
            ),
            const SizedBox(height: AppDimens.cardInfoGap),
            Text(post.communityLabel, style: AppTypography.headerTag),
          ],
        ),
      ],
    );
  }
}
