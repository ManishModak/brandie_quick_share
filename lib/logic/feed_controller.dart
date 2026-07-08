import 'package:flutter/foundation.dart';

/// Tracks the active Smart Post feed page and exposes a compact counter label.
class FeedController extends ChangeNotifier {
  FeedController({required this.postCount, int initialIndex = 0})
    : _activeIndex = _clampIndex(initialIndex, postCount);

  final int postCount;
  int _activeIndex;

  int get activeIndex => _activeIndex;

  String get counterLabel {
    if (postCount <= 0) {
      return '0 of 0';
    }
    return '${_activeIndex + 1} of $postCount';
  }

  void onPageChanged(int index) {
    final nextIndex = _clampIndex(index, postCount);
    if (nextIndex == _activeIndex) {
      return;
    }
    _activeIndex = nextIndex;
    notifyListeners();
  }

  static int _clampIndex(int index, int count) {
    if (count <= 0) {
      return 0;
    }
    return index.clamp(0, count - 1);
  }
}
