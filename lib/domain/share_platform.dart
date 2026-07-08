enum PlatformKind { post, story }

class SplashBranding {
  const SplashBranding({required this.appName, required this.showFromMeta});

  final String appName;
  final bool showFromMeta;
}

class SharePlatform {
  const SharePlatform({
    required this.id,
    required this.label,
    required this.kind,
    required this.brandColor,
    this.iconAsset,
    this.useEnvelopeIcon = false,
    this.businessBadge = false,
    this.storyBorderColor,
    required this.splash,
  });

  final String id;
  final String label;
  final PlatformKind kind;

  /// ARGB color value. Kept as an int so domain models stay Flutter-free.
  final int brandColor;
  final String? iconAsset;
  final bool useEnvelopeIcon;
  final bool businessBadge;
  final int? storyBorderColor;
  final SplashBranding splash;
}
