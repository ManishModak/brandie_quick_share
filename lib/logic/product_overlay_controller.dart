import 'dart:async';

import 'package:flutter/foundation.dart';

/// Delays product overlay visibility so page changes do not flash the card.
class ProductOverlayController extends ChangeNotifier {
  ProductOverlayController({this.delay = const Duration(seconds: 3)});

  final Duration delay;

  Timer? _timer;
  bool _isVisible = false;
  bool _isDisposed = false;

  bool get isVisible => _isVisible;

  void arm() {
    _timer?.cancel();
    if (_isVisible) {
      _isVisible = false;
      notifyListeners();
    }
    _timer = Timer(delay, () {
      if (_isDisposed) {
        return;
      }
      _timer = null;
      if (_isVisible) {
        return;
      }
      _isVisible = true;
      notifyListeners();
    });
  }

  void reset() {
    _timer?.cancel();
    _timer = null;
    if (!_isVisible) {
      return;
    }
    _isVisible = false;
    notifyListeners();
  }

  void dismiss() {
    reset();
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
