import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';

class CaptionCard extends StatelessWidget {
  const CaptionCard({super.key, required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.productCardWidth,
      height: AppDimens.productCardHeight,
      padding: const EdgeInsets.all(AppDimens.productCardPadding),
      decoration: BoxDecoration(
        color: AppColors.cardOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radius),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: AppDimens.productTextWidth,
            height: AppDimens.productTextHeight,
            child: Text(
              caption,
              maxLines: AppDimens.captionMaxLines,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body.copyWith(color: AppColors.white),
            ),
          ),
          const SizedBox(height: AppDimens.productCardGap),
          SizedBox(
            width: AppDimens.footerActionsWidth,
            height: AppDimens.footerActionsHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('See More', style: AppTypography.seeMore),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(
                      Icons.edit_outlined,
                      color: AppColors.white,
                      size: AppDimens.editCaptionIcon,
                    ),
                    SizedBox(width: AppDimens.editCaptionIconGap),
                    Text(
                      'Edit Caption',
                      style: AppTypography.editCaptionAction,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
