// Oriflame Sans 2.0 is proprietary and not redistributable, so Satoshi
// (also specified in the design for the AI tag) stands in for it - documented
// in README later.
import 'package:flutter/material.dart';

import 'app_colors.dart';

abstract final class AppTypography {
  static const String fontFamily = 'Satoshi';

  static const TextStyle categoryTabs = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 21 / 14,
  );

  static const TextStyle headerTag = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 12 / 12,
    color: AppColors.white,
  );

  static const TextStyle body = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w400,
    height: 17 / 12,
  );

  static const TextStyle labels = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    height: 18 / 12,
  );

  static const TextStyle topActionLabel = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w500,
    height: 15 / 10,
    color: AppColors.topActionLabel,
  );

  static const TextStyle aiBadge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 8,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    height: 1,
    color: AppColors.white,
  );

  static const TextStyle readyPill = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w700,
    fontStyle: FontStyle.italic,
    height: 1,
    color: AppColors.white,
  );

  static const TextStyle wordmark = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
    height: 18 / 16,
    letterSpacing: 4,
    color: AppColors.wordmark,
  );

  static const TextStyle wordmarkCountry = TextStyle(
    fontFamily: fontFamily,
    fontSize: 6,
    fontWeight: FontWeight.w500,
    height: 8 / 6,
    letterSpacing: 3,
    color: AppColors.wordmark,
  );

  static const TextStyle seeMore = TextStyle(
    fontFamily: fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w500,
    height: 17 / 12,
    color: AppColors.seeMoreText,
  );

  static const TextStyle editCaptionAction = TextStyle(
    fontFamily: fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w700,
    height: 21 / 14,
    color: AppColors.white,
  );

  static const TextStyle businessBadge = TextStyle(
    fontFamily: fontFamily,
    fontSize: 8,
    fontWeight: FontWeight.w700,
    height: 1,
    color: AppColors.white,
  );

  static const TextStyle counter = TextStyle(
    fontFamily: fontFamily,
    fontSize: 10,
    fontWeight: FontWeight.w700,
    height: 15 / 10,
    color: AppColors.white,
  );

  static const TextStyle checklistTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w700,
    height: 30 / 20,
    color: AppColors.white,
  );

  static const TextStyle editCaptionTitle = TextStyle(
    fontFamily: fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w700,
  );
}
