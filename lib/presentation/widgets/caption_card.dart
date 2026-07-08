import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../logic/caption_controller.dart';

class CaptionCard extends StatelessWidget {
  const CaptionCard({
    super.key,
    required this.controller,
    required this.onEdit,
  });

  final CaptionController controller;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        return AnimatedSize(
          duration: const Duration(milliseconds: AppDimens.fastAnimationMs),
          curve: Curves.easeInOut,
          alignment: Alignment.topCenter,
          child: Container(
            width: AppDimens.productCardWidth,
            padding: const EdgeInsets.all(AppDimens.productCardPadding),
            decoration: BoxDecoration(
              color: AppColors.cardOverlay,
              borderRadius: BorderRadius.circular(AppDimens.radius),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: onEdit,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: AppDimens.productTextHeight,
                    ),
                    child: Text(
                      controller.originalText,
                      maxLines: controller.isExpanded
                          ? null
                          : AppDimens.captionMaxLines,
                      overflow: controller.isExpanded
                          ? TextOverflow.visible
                          : TextOverflow.ellipsis,
                      style: AppTypography.body.copyWith(
                        color: AppColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: AppDimens.productCardGap),
                SizedBox(
                  width: AppDimens.footerActionsWidth,
                  height: AppDimens.footerActionsHeight,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: controller.toggleExpanded,
                        child: Text(
                          controller.isExpanded ? 'See Less' : 'See More',
                          style: AppTypography.seeMore,
                        ),
                      ),
                      GestureDetector(
                        onTap: onEdit,
                        child: Row(
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
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
