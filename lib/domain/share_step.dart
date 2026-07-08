class ShareStep {
  const ShareStep({required this.label, required this.progress})
    : assert(progress >= 0 && progress <= 1);

  final String label;
  final double progress;
}
