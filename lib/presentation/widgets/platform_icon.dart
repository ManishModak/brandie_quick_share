import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';

class PlatformIcon extends StatelessWidget {
  const PlatformIcon({super.key, required this.platform});

  final SharePlatform platform;

  @override
  Widget build(BuildContext context) {
    if (platform.kind == PlatformKind.story) {
      return Container(
        width: AppDimens.shareEllipse,
        height: AppDimens.shareEllipse,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color(platform.storyBorderColor!),
            width: AppDimens.storyBorderWidth,
          ),
        ),
        child: _IconCircle(
          platform: platform,
          size: AppDimens.shareInnerEllipse,
        ),
      );
    }

    return Stack(
      clipBehavior: Clip.none,
      children: [
        _IconCircle(platform: platform, size: AppDimens.shareEllipse),
        if (platform.businessBadge)
          Positioned(
            right: AppDimens.badgeOffset,
            bottom: AppDimens.badgeOffset,
            child: Container(
              width: AppDimens.businessBadge,
              height: AppDimens.businessBadge,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: AppColors.activeGreen,
                shape: BoxShape.circle,
              ),
              child: const Text('B', style: AppTypography.businessBadge),
            ),
          ),
      ],
    );
  }
}

class _IconCircle extends StatelessWidget {
  const _IconCircle({required this.platform, required this.size});

  final SharePlatform platform;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.quickShareInactive,
        shape: BoxShape.circle,
      ),
      child: platform.useEnvelopeIcon
          ? const Icon(
              Icons.mail_outline,
              color: AppColors.white,
              size: AppDimens.shareIcon,
            )
          : SvgPicture.asset(
              platform.iconAsset!,
              width: AppDimens.shareIcon,
              height: AppDimens.shareIcon,
            ),
    );
  }
}
