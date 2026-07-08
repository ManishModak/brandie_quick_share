import 'music_track.dart';
import 'product_info.dart';
import 'referral_details.dart';

class SmartPost {
  const SmartPost({
    required this.id,
    required this.backdropAsset,
    required this.communityLabel,
    required this.isAiGenerated,
    required this.music,
    required this.captionBody,
    required this.referral,
    required this.product,
  });

  final String id;
  final String backdropAsset;
  final String communityLabel;
  final bool isAiGenerated;
  final MusicTrack music;
  final String captionBody;
  final ReferralDetails referral;
  final ProductInfo product;

  String get fullCaption => '$captionBody\n\n${referral.formattedBlock}';
}
