import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';

class CardHeader extends StatelessWidget {
  const CardHeader({super.key, required this.post});

  final SmartPost post;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: AppDimens.avatar,
          height: AppDimens.avatar,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.avatarBorder,
              width: AppDimens.avatarBorderWidth,
            ),
          ),
          child: ClipOval(
            child: Transform(
              alignment: Alignment.center,
              transform: Matrix4.diagonal3Values(1.5, 1.5, 1.0)
                ..setTranslationRaw(0.0, 3.0, 0.0),
              child: Image.asset(
                'assets/images/product_lipstick_thumb.png',
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        const SizedBox(width: AppDimens.cardHeaderGap),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 20,
              padding: const EdgeInsets.symmetric(horizontal: 8),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                image: const DecorationImage(
                  image: AssetImage('assets/images/brandie_logo_gradient.png'),
                  fit: BoxFit.cover,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.auto_awesome, size: 10, color: AppColors.white),
                  SizedBox(width: 4),
                  Text('Ready to share', style: AppTypography.readyPill),
                ],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              post.communityLabel,
              style: AppTypography.headerTag.copyWith(
                shadows: const [
                  Shadow(
                    offset: Offset(0, 1),
                    blurRadius: 3,
                    color: Color.fromRGBO(0, 0, 0, 0.4),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
