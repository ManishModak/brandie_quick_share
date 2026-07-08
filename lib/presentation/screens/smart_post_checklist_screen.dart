import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../data/data.dart';
import '../../logic/checklist_controller.dart';
import '../services/haptic_feedback_service.dart';
import '../widgets/spinner_painter.dart';
import 'quick_share_screen.dart';

class SmartPostChecklistScreen extends StatefulWidget {
  const SmartPostChecklistScreen({
    super.key,
    this.stepDuration = const Duration(seconds: 2),
    PostRepository? repository,
  }) : repository = repository ?? const MockPostRepository();

  final Duration stepDuration;
  final PostRepository repository;

  @override
  State<SmartPostChecklistScreen> createState() =>
      _SmartPostChecklistScreenState();
}

class _SmartPostChecklistScreenState extends State<SmartPostChecklistScreen>
    with TickerProviderStateMixin {
  late final ChecklistController _controller;
  late final AnimationController _spinnerController;
  late final AnimationController _doneController;
  late List<StepStatus> _previousStatuses;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _controller = ChecklistController(
      steps: widget.repository.fetchChecklistSteps(),
      stepDuration: widget.stepDuration,
    );
    _previousStatuses = _controller.statuses;
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.checklistSpinnerMs),
    )..repeat();
    _doneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.checklistFooterFadeMs),
    );
    _controller.addListener(_onChecklistChanged);
    _controller.start();
  }

  @override
  void dispose() {
    _controller
      ..removeListener(_onChecklistChanged)
      ..dispose();
    _spinnerController.dispose();
    _doneController.dispose();
    super.dispose();
  }

  void _onChecklistChanged() {
    final statuses = _controller.statuses;
    for (var i = 0; i < statuses.length; i += 1) {
      if (statuses[i] == StepStatus.completed &&
          _previousStatuses[i] != StepStatus.completed) {
        HapticFeedbackService.lightImpact();
      }
    }
    _previousStatuses = statuses;

    if (_controller.isAllDone && !_navigated) {
      _navigated = true;
      _doneController.forward();
      Future<void>.delayed(
        const Duration(milliseconds: AppDimens.checklistCompletionHoldMs),
        () {
          if (!mounted) {
            return;
          }
          Navigator.of(context).pushReplacement(_buildQuickShareRoute());
        },
      );
    }
  }

  Route<void> _buildQuickShareRoute() {
    return PageRouteBuilder<void>(
      transitionDuration: const Duration(
        milliseconds: AppDimens.standardAnimationMs,
      ),
      pageBuilder: (context, animation, secondaryAnimation) {
        return QuickShareScreen(repository: widget.repository);
      },
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOut,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, AppDimens.checklistRouteSlideOffset),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.checklistBackground,
      body: Center(
        child: SizedBox(
          width: AppDimens.checklistCardWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Building personalised\nSmart Posts for you!',
                textAlign: TextAlign.center,
                style: AppTypography.checklistTitle,
              ),
              const SizedBox(height: AppDimens.checklistGap),
              SizedBox(
                width: AppDimens.checklistContainerWidth,
                child: ListenableBuilder(
                  listenable: _controller,
                  builder: (context, child) {
                    return Column(
                      children: [
                        for (var i = 0; i < _controller.steps.length; i += 1)
                          Padding(
                            padding: EdgeInsets.only(
                              bottom: i == _controller.steps.length - 1
                                  ? AppDimens.zero
                                  : AppDimens.checklistRowGap,
                            ),
                            child: _ChecklistRow(
                              label: _controller.steps[i].label,
                              status: _controller.statuses[i],
                              spinnerController: _spinnerController,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: AppDimens.checklistFooterTop),
              FadeTransition(
                opacity: _doneController,
                child: const Text(
                  'All set! Get ready to share...',
                  style: AppTypography.checklistFooter,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistRow extends StatelessWidget {
  const _ChecklistRow({
    required this.label,
    required this.status,
    required this.spinnerController,
  });

  final String label;
  final StepStatus status;
  final AnimationController spinnerController;

  @override
  Widget build(BuildContext context) {
    final isActiveOrDone = status != StepStatus.pending;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SizedBox(
          width: AppDimens.checklistMarker,
          height: AppDimens.checklistMarker,
          child: _ChecklistMarker(
            status: status,
            spinnerController: spinnerController,
          ),
        ),
        const SizedBox(width: AppDimens.checklistMarkerGap),
        Expanded(
          child: AnimatedDefaultTextStyle(
            duration: const Duration(
              milliseconds: AppDimens.standardAnimationMs,
            ),
            style: AppTypography.checklistRow.copyWith(
              color: isActiveOrDone
                  ? AppColors.white
                  : AppColors.checklistPendingText,
              fontWeight: isActiveOrDone ? FontWeight.w700 : FontWeight.w400,
            ),
            child: Text(label),
          ),
        ),
      ],
    );
  }
}

class _ChecklistMarker extends StatelessWidget {
  const _ChecklistMarker({
    required this.status,
    required this.spinnerController,
  });

  final StepStatus status;
  final AnimationController spinnerController;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: AppDimens.fastAnimationMs),
      transitionBuilder: (child, animation) {
        final scale = TweenSequence<double>([
          TweenSequenceItem(tween: Tween(begin: 1, end: 1.15), weight: 50),
          TweenSequenceItem(tween: Tween(begin: 1.15, end: 1), weight: 50),
        ]).animate(animation);
        return ScaleTransition(scale: scale, child: child);
      },
      child: switch (status) {
        StepStatus.pending => Container(
          key: const ValueKey(StepStatus.pending),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.checklistPendingOutline,
              width: 2,
            ),
          ),
        ),
        StepStatus.loading => AnimatedBuilder(
          key: const ValueKey(StepStatus.loading),
          animation: spinnerController,
          builder: (context, child) {
            return Transform.rotate(
              angle: spinnerController.value * 2 * math.pi,
              child: child,
            );
          },
          child: const CustomPaint(
            painter: SpinnerPainter(
              color: AppColors.checklistGreen,
              trackColor: Colors.transparent,
              strokeWidth: 2.5,
            ),
          ),
        ),
        StepStatus.completed => Container(
          key: const ValueKey(StepStatus.completed),
          decoration: const BoxDecoration(
            color: AppColors.checklistGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check,
            size: AppDimens.checklistCheckIcon,
            color: AppColors.checklistBackground,
          ),
        ),
      },
    );
  }
}
