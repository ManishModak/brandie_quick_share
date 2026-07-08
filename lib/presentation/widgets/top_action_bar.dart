import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';

class TopActionBar extends StatelessWidget {
  const TopActionBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: AppDimens.topActionsHeight,
      child: Stack(
        children: const [
          Positioned(
            left: AppDimens.horizontalPadding,
            bottom: AppDimens.topActionBottom,
            child: _TopAction(
              iconAsset: 'assets/icons/profile.svg',
              label: 'Your Assistant',
              showAiBadge: true,
            ),
          ),
          Positioned(
            right: AppDimens.horizontalPadding,
            bottom: AppDimens.topActionBottom,
            child: _TopAction(
              iconAsset: 'assets/icons/camera.svg',
              label: 'Camera',
            ),
          ),
          Positioned.fill(child: _Wordmark()),
        ],
      ),
    );
  }
}

class _TopAction extends StatelessWidget {
  const _TopAction({
    required this.iconAsset,
    required this.label,
    this.showAiBadge = false,
  });

  final String iconAsset;
  final String label;
  final bool showAiBadge;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              width: AppDimens.topActionButton,
              height: AppDimens.topActionButton,
              decoration: const BoxDecoration(
                color: AppColors.darkButton,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: SvgPicture.asset(
                iconAsset,
                width: AppDimens.topActionIcon,
                height: AppDimens.topActionIcon,
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            if (showAiBadge)
              Positioned(
                right: AppDimens.badgeOffset,
                bottom: AppDimens.badgeOffset,
                child: Container(
                  width: AppDimens.topActionBadge,
                  height: AppDimens.topActionBadge,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.aiBadge,
                    shape: BoxShape.circle,
                  ),
                  child: const Text('AI', style: AppTypography.aiBadge),
                ),
              ),
          ],
        ),
        const SizedBox(height: AppDimens.topActionLabelTop),
        Text(label, style: AppTypography.topActionLabel),
      ],
    );
  }
}

class _Wordmark extends StatelessWidget {
  const _Wordmark();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(top: AppDimens.logoTop),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Text stand-in for the ORIFLAME logo asset, which is not provided.
          Text('ORIFLAME', style: AppTypography.wordmark),
          Text('S W E D E N', style: AppTypography.wordmarkCountry),
        ],
      ),
    );
  }
}
