import 'package:flutter/material.dart';

abstract final class AppColors {
  /// Device default background and redirection splash background.
  static const Color background = Color(0xFFFFFFFF);

  /// Text/White used on image overlays, indicators, and completed checklist rows.
  static const Color white = Color(0xFFFFFFFF);

  /// Active Green / Theme Accent used for Smart Post tab, dots, progress, and active save.
  static const Color activeGreen = Color(0xFF73BF98);

  /// Active Tag/Text purple used for active tag text.
  static const Color tagPurple = Color(0xFF6834AC);

  /// End color for the ready-to-share gradient pill.
  static const Color tagPink = Color(0xFFE45AA8);

  /// Inactive Category Text used by inactive navigation tabs.
  static const Color inactiveText = Color(0xFF595959);

  /// Card Container Overlay used for music and product description cards.
  static const Color cardOverlay = Color.fromRGBO(49, 49, 49, 0.39);

  /// Right Pagination Dot Background used behind vertical dot indicators.
  static const Color paginationDotBg = Color.fromRGBO(70, 70, 70, 0.56);

  /// Quick Share Inactive Ellipse used behind inactive platform icons.
  static const Color quickShareInactive = Color.fromRGBO(254, 254, 254, 0.25);

  /// Quick Share Active Border used for Instagram Story.
  static const Color instagramStoryBorder = Color(0xFFFF64EE);

  /// Quick Share Active Border used for Facebook Story.
  static const Color facebookStoryBorder = Color(0xFF75A5FF);

  /// Blurred Background Rectangle used over the active card during generation.
  static const Color blurredOverlay = Color.fromRGBO(77, 75, 62, 0.64);

  /// Checklist dark theme background.
  static const Color checklistBackground = Color(0xFF121315);

  /// Checklist loading/completed marker and completion footer text.
  static const Color checklistGreen = Color(0xFF9CDABC);

  /// Checklist pending circular outline.
  static const Color checklistPendingOutline = Color(0xFFD0D3DA);

  /// Checklist pending text.
  static const Color checklistPendingText = Color(0xFF8A909A);

  /// Disabled save button background on Edit Caption screen.
  static const Color saveButtonDisabledBg = Color(0xFFE2E6E3);

  /// Disabled save button text on Edit Caption screen.
  static const Color saveButtonDisabledText = Color(0xFFA2A6A3);

  /// Loading modal horizontal progress track.
  static const Color progressTrack = Color(0xFFE8E8E8);

  /// Dark circular action button background in the top bar.
  static const Color darkButton = Color(0xFF262928);

  /// Text color used for small top action labels.
  static const Color topActionLabel = Color(0xFF8A909A);

  /// Dark text used by the ORIFLAME wordmark stand-in.
  static const Color wordmark = Color(0xFF2F343B);

  /// Assistant AI badge background.
  static const Color aiBadge = Color(0xFF7EC086);

  /// Feed card avatar border.
  static const Color avatarBorder = Color(0xFFF4F4F4);

  /// Bottom card gradient start.
  static const Color cardGradientStart = Color.fromRGBO(47, 47, 47, 0);

  /// Bottom card gradient end at 54% and 100%.
  static const Color cardGradientEnd = Color.fromRGBO(47, 47, 47, 0.6);

  /// See More footer text in product description cards.
  static const Color seeMoreText = Color(0xFF9E9E9E);
}
