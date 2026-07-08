import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../logic/share_flow_controller.dart';
import 'spinner_painter.dart';

class ShareProgressOverlay extends StatefulWidget {
  const ShareProgressOverlay({super.key, required this.controller});

  final ShareFlowController controller;

  @override
  State<ShareProgressOverlay> createState() => _ShareProgressOverlayState();
}

class _ShareProgressOverlayState extends State<ShareProgressOverlay>
    with SingleTickerProviderStateMixin {
  late final AnimationController _spinnerController;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: AppDimens.shareSpinnerSeconds),
    )..repeat();
  }

  @override
  void dispose() {
    _spinnerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final isGenerating =
            widget.controller.phase == ShareFlowPhase.generating;
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
                  controller: widget.controller,
                  spinnerController: _spinnerController,
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
    required this.spinnerController,
  });

  final ShareFlowController controller;
  final AnimationController spinnerController;

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
      child: Stack(
        children: [
          Positioned(
            left:
                AppDimens.shareDialogWidth * AppDimens.shareSpinnerLeftFraction,
            top:
                AppDimens.shareDialogHeight * AppDimens.shareSpinnerTopFraction,
            width: AppDimens.shareSpinnerSize,
            height: AppDimens.shareSpinnerSize,
            child: AnimatedBuilder(
              animation: spinnerController,
              builder: (context, child) {
                return Transform.rotate(
                  angle: spinnerController.value * 2 * math.pi,
                  child: child,
                );
              },
              child: const CustomPaint(painter: SpinnerPainter()),
            ),
          ),
          Positioned(
            left: AppDimens.shareDialogWidth * AppDimens.shareLabelSideFraction,
            top: AppDimens.shareDialogHeight * AppDimens.shareLabelTopFraction,
            right:
                AppDimens.shareDialogWidth * AppDimens.shareLabelSideFraction,
            child: AnimatedSwitcher(
              duration: const Duration(
                milliseconds: AppDimens.standardAnimationMs,
              ),
              child: Text(
                step?.label ?? '',
                key: ValueKey(step?.label),
                textAlign: TextAlign.center,
                style: AppTypography.loadingStatus,
              ),
            ),
          ),
          Positioned(
            left:
                AppDimens.shareDialogWidth *
                AppDimens.shareProgressLeftFraction,
            top:
                AppDimens.shareDialogHeight *
                AppDimens.shareProgressTopFraction,
            right:
                AppDimens.shareDialogWidth *
                AppDimens.shareProgressRightFraction,
            height:
                AppDimens.shareDialogHeight *
                AppDimens.shareProgressHeightFraction,
            child: DecoratedBox(
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
          ),
        ],
      ),
    );
  }
}
