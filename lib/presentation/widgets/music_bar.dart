import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../domain/domain.dart';

class MusicBar extends StatelessWidget {
  const MusicBar({super.key, required this.music});

  final MusicTrack music;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: AppDimens.musicBarWidth,
      height: AppDimens.musicBarHeight,
      padding: const EdgeInsets.symmetric(
        horizontal: AppDimens.productCardPadding,
      ),
      decoration: BoxDecoration(
        color: AppColors.cardOverlay,
        borderRadius: BorderRadius.circular(AppDimens.radius),
      ),
      child: Row(
        children: [
          const Icon(
            Icons.music_note,
            color: AppColors.white,
            size: AppDimens.musicIcon,
          ),
          const SizedBox(width: AppDimens.productCardPadding),
          Expanded(
            child: RichText(
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              text: TextSpan(
                style: AppTypography.body.copyWith(color: AppColors.white),
                children: [
                  const TextSpan(text: 'Recommended: '),
                  TextSpan(
                    text: music.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                  TextSpan(text: ' by ${music.artist}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
