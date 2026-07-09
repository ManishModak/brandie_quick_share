class ReferralDetails {
  const ReferralDetails({required this.code, required this.link});

  final String code;
  final String link;

  String get formattedBlock =>
      'Your referral and sales links:\n'
      'Use my referral code: $code\n'
      'Use my referral link: $link';
}
