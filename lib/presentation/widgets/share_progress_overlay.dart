import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../logic/share_flow_controller.dart';

class ShareProgressOverlay extends StatelessWidget {
  const ShareProgressOverlay({super.key, required this.controller});

  final ShareFlowController controller;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final isGenerating =
            controller.phase == ShareFlowPhase.generating;
        return IgnorePointer(
          ignoring: !isGenerating,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: AppDimens.fastAnimationMs),
            opacity: isGenerating ? 1 : 0,
            child: TweenAnimationBuilder<double>(
              tween: Tween<double>(end: isGenerating ? AppDimens.blurSigma : 0),
              duration: const Duration(milliseconds: AppDimens.fastAnimationMs),
              builder: (context, sigma, child) {
                return BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: sigma, sigmaY: sigma),
                  child: ColoredBox(
                    color: AppColors.blurredOverlay,
                    child: child,
                  ),
                );
              },
              child: Center(
                child: _ShareProgressDialog(
                  controller: controller,
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _ShareProgressDialog extends StatelessWidget {
  const _ShareProgressDialog({
    required this.controller,
  });

  final ShareFlowController controller;

  @override
  Widget build(BuildContext context) {
    final step = controller.currentStep;
    return Container(
      width: AppDimens.shareDialogWidth,
      height: AppDimens.shareDialogHeight,
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppDimens.radius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: AppDimens.shareDialogShadowBlur,
            offset: const Offset(
              AppDimens.shareDialogShadowOffset,
              AppDimens.shareDialogShadowOffset,
            ),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: AppDimens.shareSpinnerSize,
              height: AppDimens.shareSpinnerSize,
              decoration: const BoxDecoration(
                color: AppColors.activeGreen,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              padding: const EdgeInsets.all(10),
              child: SvgPicture.asset(
                'assets/icons/brand_icon.svg',
                colorFilter: const ColorFilter.mode(
                  AppColors.white,
                  BlendMode.srcIn,
                ),
              ),
            ),
            const SizedBox(height: 12),
            AnimatedSwitcher(
              duration: const Duration(
                milliseconds: AppDimens.standardAnimationMs,
              ),
              child: SizedBox(
                key: ValueKey(step?.label),
                width: double.infinity,
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      step?.label ?? '',
                      textAlign: TextAlign.center,
                      style: AppTypography.loadingStatus,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Container(
              height: AppDimens.shareDialogHeight * AppDimens.shareProgressHeightFraction,
              width: double.infinity,
              margin: const EdgeInsets.only(left: 32, right: 33),
              decoration: BoxDecoration(
                color: AppColors.progressTrack,
                borderRadius: BorderRadius.circular(
                  AppDimens.shareProgressRadius,
                ),
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: AnimatedFractionallySizedBox(
                  duration: const Duration(
                    milliseconds: AppDimens.progressAnimationMs,
                  ),
                  curve: Curves.easeInOut,
                  widthFactor: controller.progress,
                  heightFactor: 1.0,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: AppColors.activeGreen,
                      borderRadius: BorderRadius.circular(
                        AppDimens.shareProgressRadius,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


