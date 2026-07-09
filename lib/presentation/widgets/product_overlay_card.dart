import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';
import '../../logic/product_overlay_controller.dart';

class ProductOverlayCard extends StatefulWidget {
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
  State<ProductOverlayCard> createState() => _ProductOverlayCardState();
}

class _ProductOverlayCardState extends State<ProductOverlayCard> {
  Timer? _timer;
  bool _showTrending = false;

  @override
  void initState() {
    super.initState();
    _showTrending = widget.product.isTrending;

    if (widget.product.subtitle.isNotEmpty && widget.product.price.isNotEmpty) {
      _timer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (mounted) {
          setState(() {
            _showTrending = !_showTrending;
          });
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.controller,
      builder: (context, child) {
        final visible = widget.controller.isVisible;
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
        onTap: widget.onTap,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 3.0,
              sigmaY: 3.0,
            ),
            child: Container(
              width: 255,
              height: 52,
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color.fromRGBO(187, 187, 187, 0.29),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.12),
                  width: 0.5,
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: Image.asset(
                      widget.product.thumbnailAsset,
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTypography.productOverlayTitle.copyWith(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            height: 1.2,
                          ),
                        ),
                        const SizedBox(height: 2),
                        AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          transitionBuilder: (Widget child, Animation<double> animation) {
                            return FadeTransition(
                              opacity: animation,
                              child: SlideTransition(
                                position: Tween<Offset>(
                                  begin: const Offset(0.0, 0.15),
                                  end: Offset.zero,
                                ).animate(animation),
                                child: child,
                              ),
                            );
                          },
                          child: _showTrending
                              ? Row(
                                  key: const ValueKey('trending'),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.trending_up,
                                      size: 12,
                                      color: AppColors.white,
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                        widget.product.subtitle,
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: AppTypography.productOverlayBadge.copyWith(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w400,
                                          color: AppColors.white.withValues(alpha: 0.9),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00725B),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        widget.product.saleBadge,
                                        style: AppTypography.productOverlayBadge.copyWith(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              : Row(
                                  key: const ValueKey('price'),
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      widget.product.price,
                                      style: AppTypography.productOverlayPrice.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 1,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF00725B),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        widget.product.saleBadge,
                                        style: AppTypography.productOverlayBadge.copyWith(
                                          fontSize: 8,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
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
          ),
        ),
      ),
    );
  }
}
