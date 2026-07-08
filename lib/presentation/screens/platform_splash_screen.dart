import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';

class PlatformSplashScreen extends StatelessWidget {
  const PlatformSplashScreen({super.key, required this.platform});

  final SharePlatform platform;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          Center(
            child: platform.useEnvelopeIcon
                ? const Icon(
                    Icons.mail_outline,
                    color: AppColors.wordmark,
                    size: AppDimens.splashLogoSize,
                  )
                : SvgPicture.asset(
                    platform.iconAsset!,
                    width: AppDimens.splashLogoSize,
                    height: AppDimens.splashLogoSize,
                  ),
          ),
          Positioned(
            left: AppDimens.zero,
            right: AppDimens.zero,
            bottom: AppDimens.splashBottom,
            child: platform.splash.showFromMeta
                ? const _MetaBranding()
                : Text(
                    platform.label,
                    textAlign: TextAlign.center,
                    style: AppTypography.splashMeta,
                  ),
          ),
        ],
      ),
    );
  }
}

class _MetaBranding extends StatelessWidget {
  const _MetaBranding();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Text('from', style: AppTypography.splashMeta),
        const SizedBox(height: AppDimens.productOverlayBadgeVertical),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            SvgPicture.asset(
              'assets/icons/brand_meta.svg',
              width: AppDimens.metaLogoSize,
              height: AppDimens.metaLogoSize,
            ),
            const SizedBox(width: AppDimens.editCaptionIconGap),
            const Text('Meta', style: AppTypography.splashMeta),
          ],
        ),
      ],
    );
  }
}
