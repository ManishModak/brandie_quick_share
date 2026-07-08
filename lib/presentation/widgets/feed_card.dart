import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../domain/domain.dart';
import 'caption_card.dart';
import 'card_header.dart';
import 'music_bar.dart';
import 'page_counter_pill.dart';
import 'pagination_dots.dart';
import 'quick_share_bar.dart';

class FeedCard extends StatelessWidget {
  const FeedCard({
    super.key,
    required this.post,
    required this.platforms,
    required this.counterLabel,
    required this.activeIndex,
    required this.postCount,
  });

  final SmartPost post;
  final List<SharePlatform> platforms;
  final String counterLabel;
  final int activeIndex;
  final int postCount;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(post.backdropAsset, fit: BoxFit.cover),
        const _BottomGradient(),
        Positioned(
          left: AppDimens.cardHeaderLeft,
          top: AppDimens.cardHeaderTop,
          child: CardHeader(post: post),
        ),
        Positioned(
          right: AppDimens.horizontalPadding,
          top: AppDimens.counterTop,
          child: PageCounterPill(label: counterLabel),
        ),
        Positioned(
          right: AppDimens.horizontalPadding,
          top:
              AppDimens.cardHeight / 2 -
              AppDimens.dotsHeight / 2 -
              AppDimens.dotsVerticalOffset,
          child: PaginationDots(count: postCount, activeIndex: activeIndex),
        ),
        Positioned(
          left: AppDimens.bottomStackLeft,
          right: AppDimens.horizontalPadding,
          bottom: AppDimens.bottomStackBottom,
          child: Column(
            children: [
              MusicBar(music: post.music),
              const SizedBox(height: AppDimens.productCardGap),
              CaptionCard(caption: post.captionBody),
            ],
          ),
        ),
        Positioned(
          left: AppDimens.quickShareLeft,
          right: AppDimens.zero,
          bottom: AppDimens.quickShareBottom,
          child: QuickShareBar(platforms: platforms),
        ),
      ],
    );
  }
}

class _BottomGradient extends StatelessWidget {
  const _BottomGradient();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: FractionallySizedBox(
        heightFactor: AppDimens.cardGradientHeight / AppDimens.cardHeight,
        widthFactor: AppDimens.fullWidthFactor,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              stops: [
                AppDimens.zero,
                AppDimens.cardGradientMidStop,
                AppDimens.fullWidthFactor,
              ],
              colors: [
                AppColors.cardGradientStart,
                AppColors.cardGradientEnd,
                AppColors.cardGradientEnd,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
