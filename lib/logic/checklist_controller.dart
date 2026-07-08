import 'dart:async';

import 'package:flutter/foundation.dart';

import '../domain/domain.dart';
import 'timer_factory.dart';

enum StepStatus { pending, loading, completed }

/// Runs the Smart Post preparation checklist as a deterministic state machine.
class ChecklistController extends ChangeNotifier {
  ChecklistController({
    required List<ChecklistStep> steps,
    this.stepDuration = const Duration(seconds: 2),
    this.timerFactory = createTimer,
  }) : steps = List.unmodifiable(steps),
       _statuses = List.filled(steps.length, StepStatus.pending);

  final List<ChecklistStep> steps;
  final Duration stepDuration;
  final TimerFactory timerFactory;

  final List<StepStatus> _statuses;
  Timer? _timer;
  int? _activeIndex;
  bool _isDisposed = false;

  List<StepStatus> get statuses => List.unmodifiable(_statuses);
  bool get isAllDone =>
      _statuses.isNotEmpty &&
      _statuses.every((status) => status == StepStatus.completed);

  void start() {
    _timer?.cancel();
    for (var i = 0; i < _statuses.length; i += 1) {
      _statuses[i] = StepStatus.pending;
    }
    _activeIndex = null;
    if (_statuses.isEmpty) {
      notifyListeners();
      return;
    }
    _beginStep(0);
  }

  void _beginStep(int index) {
    if (_isDisposed) {
      return;
    }
    _activeIndex = index;
    _statuses[index] = StepStatus.loading;
    notifyListeners();
    _timer = timerFactory(stepDuration, _completeActiveStep);
  }

  void _completeActiveStep() {
    _timer = null;
    if (_isDisposed || _activeIndex == null) {
      return;
    }
    final completedIndex = _activeIndex!;
    _statuses[completedIndex] = StepStatus.completed;
    _activeIndex = null;
    notifyListeners();

    final nextIndex = completedIndex + 1;
    if (nextIndex < _statuses.length) {
      _beginStep(nextIndex);
    }
  }

  @override
  void dispose() {
    _isDisposed = true;
    _timer?.cancel();
    _timer = null;
    super.dispose();
  }
}
