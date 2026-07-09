import '../domain/domain.dart';
import 'post_repository.dart';

class MockPostRepository implements PostRepository {
  const MockPostRepository();

  static const _referral = ReferralDetails(
    code: 'UK-AMANDA3012',
    link: 'www.oriflame.com/giordani/amada3012',
  );

  static const _product = ProductInfo(
    name: 'Giordani Gold Lipstick',
    price: '\$14.99',
    saleBadge: '30% off',
    subtitle: 'Trending right now and on sale',
    thumbnailAsset: 'assets/images/dbd_test.png',
    storeLink: 'www.oriflame.com/giordani/amada3012',
    isTrending: false,
  );

  static const _productTrending = ProductInfo(
    name: 'Giordani Gold Lipstick',
    price: '\$14.99',
    saleBadge: '30% off',
    subtitle: 'Trending right now and on sale',
    thumbnailAsset: 'assets/images/dbd_test.png',
    storeLink: 'www.oriflame.com/giordani/amada3012',
    isTrending: true,
  );

  @override
  Future<List<SmartPost>> fetchSmartPosts() async => const [
    SmartPost(
      id: 'post-1',
      backdropAsset: 'assets/images/post_1_lipstick.jpg',
      communityLabel: 'High-converting in Oriflame Community',
      isAiGenerated: true,
      music: MusicTrack(title: 'Bad Habits', artist: 'Ed Sheeran'),
      captionBody:
          "🍒 Elevate your beauty with the Giordani Gold - Eternal Glow Lipstick SPF 25! This luxurious creamy lipstick doesn't just promise rich pigments but brings you the benefits of hyaluronic acid and collagen-boosting peptides too. Pamper your lips with care while enjoying a long-lasting, luminous matte colour. 💄✨ #Oriflame #GiordaniGold #LipCareGoals",
      referral: _referral,
      product: _product,
    ),
    SmartPost(
      id: 'post-2',
      backdropAsset: 'assets/images/post_2_perfume.jpg',
      communityLabel: 'High-converting in Oriflame Community',
      isAiGenerated: true,
      music: MusicTrack(title: 'Unstoppable', artist: 'Sia'),
      captionBody:
          '✨ Experience the elegance of Eclat Amour—a fragrance that captures the essence of romance and sophistication. Let every spritz wrap you in timeless charm and effortless allure. #EclatAmour #TimelessElegance 💕',
      referral: _referral,
      product: _productTrending,
    ),
    SmartPost(
      id: 'post-3',
      backdropAsset: 'assets/images/post_3_cake.jpg',
      communityLabel: 'High-converting in Oriflame Community',
      isAiGenerated: true,
      music: MusicTrack(title: 'Vogue', artist: 'Madonna'),
      captionBody:
          'Unlock the power of bold, beautiful lashes! With WonderLash Mascara, get ultimate length, volume, and definition for a stunning, eye-catching look. One swipe is all it takes! 💖 #WonderLash #LashesForDays',
      referral: _referral,
      product: _product,
    ),
  ];

  @override
  Future<List<SharePlatform>> fetchSharePlatforms() async => [
    SharePlatform(
      id: 'instagram-post',
      label: 'Instagram Post',
      kind: PlatformKind.post,
      brandColor: 0xFFE4405F,
      iconAsset: 'assets/icons/brand_instagram.svg',
      splash: const SplashBranding(appName: 'Instagram', showFromMeta: true),
    ),
    SharePlatform(
      id: 'instagram-story',
      label: 'Instagram Story',
      kind: PlatformKind.story,
      brandColor: 0xFFE4405F,
      iconAsset: 'assets/icons/brand_instagram.svg',
      storyBorderColor: 0xFFFF64EE,
      splash: const SplashBranding(appName: 'Instagram', showFromMeta: true),
    ),
    SharePlatform(
      id: 'facebook-post',
      label: 'Facebook Post',
      kind: PlatformKind.post,
      brandColor: 0xFF1877F2,
      iconAsset: 'assets/icons/brand_facebook.svg',
      splash: const SplashBranding(appName: 'Facebook', showFromMeta: true),
    ),
    SharePlatform(
      id: 'facebook-story',
      label: 'Facebook Story',
      kind: PlatformKind.story,
      brandColor: 0xFF1877F2,
      iconAsset: 'assets/icons/brand_facebook.svg',
      storyBorderColor: 0xFF75A5FF,
      splash: const SplashBranding(appName: 'Facebook', showFromMeta: true),
    ),
    SharePlatform(
      id: 'messenger',
      label: 'Messenger',
      kind: PlatformKind.post,
      brandColor: 0xFF00B2FF,
      iconAsset: 'assets/icons/brand_messenger.svg',
      splash: const SplashBranding(appName: 'Messenger', showFromMeta: true),
    ),
    SharePlatform(
      id: 'tiktok',
      label: 'TikTok',
      kind: PlatformKind.post,
      brandColor: 0xFF111111,
      iconAsset: 'assets/icons/brand_tiktok.svg',
      splash: const SplashBranding(appName: 'TikTok', showFromMeta: false),
    ),
    SharePlatform(
      id: 'whatsapp',
      label: 'WhatsApp',
      kind: PlatformKind.post,
      brandColor: 0xFF25D366,
      iconAsset: 'assets/icons/brand_whatsapp.svg',
      splash: const SplashBranding(appName: 'WhatsApp', showFromMeta: false),
    ),
    SharePlatform(
      id: 'whatsapp-business',
      label: 'WhatsApp Business',
      kind: PlatformKind.post,
      brandColor: 0xFF128C7E,
      iconAsset: 'assets/icons/brand_whatsapp.svg',
      businessBadge: true,
      splash: const SplashBranding(
        appName: 'WhatsApp Business',
        showFromMeta: false,
      ),
    ),
    SharePlatform(
      id: 'telegram',
      label: 'Telegram',
      kind: PlatformKind.post,
      brandColor: 0xFF229ED9,
      iconAsset: 'assets/icons/brand_telegram.svg',
      splash: const SplashBranding(appName: 'Telegram', showFromMeta: false),
    ),
    SharePlatform(
      id: 'mail',
      label: 'Mail',
      kind: PlatformKind.post,
      brandColor: 0xFF5E6AD2,
      useEnvelopeIcon: true,
      splash: const SplashBranding(appName: 'Mail', showFromMeta: false),
    ),
  ];

  @override
  Future<List<ShareStep>> fetchShareSteps() async => const [
    ShareStep(label: 'Generating your sales link..', progress: 0.34),
    ShareStep(label: 'Copying the caption to clipboard', progress: 0.55),
    ShareStep(label: 'Saving the content to your profile', progress: 0.78),
    ShareStep(label: 'Preparing the content for social media', progress: 1.00),
  ];

  @override
  Future<List<ChecklistStep>> fetchChecklistSteps() async => const [
    ChecklistStep(label: 'Preparing popular content for you'),
    ChecklistStep(label: 'Crafting a caption to boost engagement'),
    ChecklistStep(label: 'Adding your personal referral link and code'),
    ChecklistStep(label: 'Finding trending songs on other social media'),
  ];
}
