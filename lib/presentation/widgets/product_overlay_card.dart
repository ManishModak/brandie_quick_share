import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';
import '../../logic/product_overlay_controller.dart';

class ProductOverlayCard extends StatelessWidget {
  const ProductOverlayCard({
    super.key,
    required this.controller,
    required this.product,
    required this.onTap,
  });

  final ProductOverlayController controller;
  final ProductInfo product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, child) {
        final visible = controller.isVisible;
        return AnimatedSlide(
          duration: const Duration(milliseconds: AppDimens.standardAnimationMs),
          curve: Curves.easeOut,
          offset: visible
              ? Offset.zero
              : const Offset(0, AppDimens.productOverlaySlideOffset / 100),
          child: AnimatedOpacity(
            duration: const Duration(
              milliseconds: AppDimens.standardAnimationMs,
            ),
            curve: Curves.easeOut,
            opacity: visible ? 1 : 0,
            child: IgnorePointer(ignoring: !visible, child: child),
          ),
        );
      },
      child: GestureDetector(
        onTap: onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDimens.radius),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: AppDimens.blurSigma,
              sigmaY: AppDimens.blurSigma,
            ),
            child: Container(
              width: AppDimens.productOverlayWidth,
              height: AppDimens.productOverlayHeight,
              padding: const EdgeInsets.all(AppDimens.productOverlayPadding),
              decoration: BoxDecoration(
                color: AppColors.productOverlay,
                borderRadius: BorderRadius.circular(AppDimens.radius),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppDimens.radius),
                    child: Image.asset(
                      product.thumbnailAsset,
                      width: AppDimens.productOverlayThumbnail,
                      height: AppDimens.productOverlayThumbnail,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: AppDimens.productOverlayGap),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.productOverlayTitle,
                        ),
                        const SizedBox(
                          height: AppDimens.productOverlayBadgeVertical,
                        ),
                        Row(
                          children: [
                            Text(
                              '\$14.99',
                              style: AppTypography.productOverlayPrice,
                            ),
                            const SizedBox(width: AppDimens.productOverlayGap),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal:
                                    AppDimens.productOverlayBadgeHorizontal,
                                vertical: AppDimens.productOverlayBadgeVertical,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.activeGreen,
                                borderRadius: BorderRadius.circular(
                                  AppDimens.productOverlayBadgeRadius,
                                ),
                              ),
                              child: Text(
                                product.saleBadge,
                                style: AppTypography.productOverlayBadge,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
