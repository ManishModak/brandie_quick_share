import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/domain.dart';

enum ShareFlowPhase { idle, generating, redirecting, done }

/// Coordinates the generated-share progress dialog and redirect phase.
class ShareFlowController extends ChangeNotifier {
  ShareFlowController({
    required List<ShareStep> steps,
    this.stepDuration = const Duration(milliseconds: 1200),
    this.redirectDuration = const Duration(seconds: 2),
  }) : _steps = List.unmodifiable(steps);

  final List<ShareStep> _steps;
  final Duration stepDuration;
  final Duration redirectDuration;

  Timer? _timer;
  ShareFlowPhase _phase = ShareFlowPhase.idle;
  SharePlatform? _activePlatform;
  int? _currentStepIndex;

  ShareFlowPhase get phase => _phase;
  SharePlatform? get activePlatform => _activePlatform;
  ShareStep? get currentStep =>
      _currentStepIndex == null ? null : _steps[_currentStepIndex!];
  double get progress => currentStep?.progress ?? 0;

  void start(SharePlatform platform) {
    if (_phase != ShareFlowPhase.idle || _steps.isEmpty) {
      return;
    }
    _activePlatform = platform;
    _phase = ShareFlowPhase.generating;
    _currentStepIndex = 0;
    notifyListeners();
    _scheduleNextStep();
  }

  void cancel() {
    _resetToIdle();
  }

  void finish() {
    _resetToIdle();
  }

  void _scheduleNextStep() {
    _timer?.cancel();
    _timer = Timer(stepDuration, _advanceStep);
  }

  void _advanceStep() {
    _timer = null;
    if (_phase != ShareFlowPhase.generating || _currentStepIndex == null) {
      return;
    }

    final nextIndex = _currentStepIndex! + 1;
    if (nextIndex < _steps.length) {
      _currentStepIndex = nextIndex;
      notifyListeners();
      _scheduleNextStep();
      return;
    }

    _phase = ShareFlowPhase.redirecting;
    _currentStepIndex = null;
    notifyListeners();
    _timer = Timer(redirectDuration, () {
      _timer = null;
      if (_phase != ShareFlowPhase.redirecting) {
        return;
      }
      _phase = ShareFlowPhase.done;
      notifyListeners();
    });
  }

  void _resetToIdle() {
    _timer?.cancel();
    _timer = null;
    final wasIdle =
        _phase == ShareFlowPhase.idle &&
        _activePlatform == null &&
        _currentStepIndex == null;
    _phase = ShareFlowPhase.idle;
    _activePlatform = null;
    _currentStepIndex = null;
    if (!wasIdle) {
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
