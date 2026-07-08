import 'package:brandie_quick_share/data/data.dart';
import 'package:brandie_quick_share/domain/domain.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Domain models', () {
    test('ReferralDetails formats the referral block', () {
      const referral = ReferralDetails();

      expect(
        referral.formattedBlock,
        'Your referral and sales links:\n'
        'Use my referral code: UK-AMANDA3012\n'
        'Use my referral link: www.oriflame.com/giordani/amada3012',
      );
    });

    test('SmartPost composes full caption from body and referral block', () {
      const referral = ReferralDetails();
      const post = SmartPost(
        id: 'post-1',
        backdropAsset: 'assets/images/post_1_lipstick.jpg',
        communityLabel: 'High-converting in Oriflame Community',
        isAiGenerated: true,
        music: MusicTrack(title: 'Bad Habits', artist: 'Ed Sheeran'),
        captionBody: 'Caption body',
        referral: referral,
        product: ProductInfo(
          thumbnailAsset: 'assets/images/post_1_lipstick.jpg',
          storeLink: 'www.oriflame.com/giordani/amada3012',
        ),
      );

      expect(post.fullCaption, 'Caption body\n\n${referral.formattedBlock}');
    });
  });

  group('MockPostRepository', () {
    test('returns three posts', () {
      final repository = MockPostRepository();

      final posts = repository.fetchSmartPosts();

      expect(posts, hasLength(3));
      expect(posts[0].backdropAsset, 'assets/images/post_1_lipstick.jpg');
      expect(posts[1].music.title, 'Unstoppable');
      expect(posts[2].music.artist, 'Madonna');
    });

    test('returns ten platforms in the specified order', () {
      final repository = MockPostRepository();

      final platforms = repository.fetchSharePlatforms();

      expect(platforms, hasLength(10));
      expect(platforms.map((platform) => platform.label), [
        'Instagram Post',
        'Instagram Story',
        'Facebook Post',
        'Facebook Story',
        'TikTok',
        'WhatsApp',
        'WhatsApp Business',
        'Telegram',
        'Mail',
        'Messenger',
      ]);
      expect(platforms[1].storyBorderColor, isNotNull);
      expect(platforms[3].storyBorderColor, isNotNull);
      expect(platforms[0].splash.showFromMeta, isTrue);
      expect(platforms[9].splash.showFromMeta, isTrue);
      expect(platforms[4].splash.showFromMeta, isFalse);
    });
  });
}
