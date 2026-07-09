import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        final text = controller.originalText;
        final referralIndex = text.indexOf('Use my referral code:');
        final String bodyText;
        final String referralText;
        if (referralIndex != -1) {
          bodyText = text.substring(0, referralIndex).trim();
          referralText = text.substring(referralIndex).trim();
        } else {
          bodyText = text;
          referralText = '';
        }

        final isLong = bodyText.length > 96;
        final truncatedText = isLong ? bodyText.substring(0, 96) : bodyText;

        final maxCaptionHeight = controller.isExpanded
            ? AppDimens.productTextHeight +
                  AppDimens.quickShareHeight +
                  AppDimens.productCardGap
            : AppDimens.productTextHeight;

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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SvgPicture.asset(
                            'assets/icons/caption_suggestion.svg',
                            width: 17,
                            height: 15,
                            colorFilter: const ColorFilter.mode(
                              AppColors.white,
                              BlendMode.srcIn,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Flexible(
                            child: Text(
                              'CAPTION SUGGESTION',
                              style: AppTypography.seeMore.copyWith(
                                color: AppColors.white.withValues(alpha: 0.9),
                                fontSize: 12,
                                letterSpacing: 0.5,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    GestureDetector(
                      onTap: onEdit,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.edit_outlined,
                            color: AppColors.white,
                            size: 14,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            'Edit Caption',
                            style: AppTypography.editCaptionAction.copyWith(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ConstrainedBox(
                  constraints: BoxConstraints(maxHeight: maxCaptionHeight),
                  child: controller.isExpanded
                      ? SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bodyText,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                              const SizedBox(height: 8),
                              GestureDetector(
                                onTap: controller.toggleExpanded,
                                child: Text(
                                  'see less',
                                  style: AppTypography.seeMore.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Expanded(
                              child: Text(
                                isLong ? '$truncatedText...' : truncatedText,
                                style: AppTypography.body.copyWith(
                                  color: AppColors.white,
                                ),
                              ),
                            ),
                            if (isLong) ...[
                              const SizedBox(width: 4),
                              GestureDetector(
                                onTap: controller.toggleExpanded,
                                child: Text(
                                  'see more',
                                  style: AppTypography.seeMore.copyWith(
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                ),
                if (referralText.isNotEmpty) ...[
                  const SizedBox(height: 12),
                  Text(
                    referralText,
                    style: AppTypography.body.copyWith(
                      color: AppColors.white.withValues(alpha: 0.8),
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}
