class ReferralDetails {
  const ReferralDetails({
    this.code = 'UK-AMANDA3012',
    this.link = 'www.oriflame.com/giordani/amada3012',
  });

  final String code;
  final String link;

  String get formattedBlock =>
      'Your referral and sales links:\n'
      'Use my referral code: $code\n'
      'Use my referral link: $link';
}
