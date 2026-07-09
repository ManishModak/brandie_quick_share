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
    required this.repository,
    this.stepDuration = const Duration(seconds: 2),
  });

  final Duration stepDuration;
  final PostRepository repository;

  @override
  State<SmartPostChecklistScreen> createState() =>
      _SmartPostChecklistScreenState();
}

class _SmartPostChecklistScreenState extends State<SmartPostChecklistScreen>
    with TickerProviderStateMixin {
  ChecklistController? _controller;
  late final AnimationController _spinnerController;
  late final AnimationController _doneController;
  late final AnimationController _entryController;
  List<StepStatus> _previousStatuses = const [];
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _spinnerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.checklistSpinnerMs),
    )..repeat();
    _doneController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: AppDimens.checklistFooterFadeMs),
    );
    _entryController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _init();
    _entryController.forward();
  }

  Future<void> _init() async {
    final steps = await widget.repository.fetchChecklistSteps();
    if (!mounted) {
      return;
    }
    setState(() {
      _controller = ChecklistController(
        steps: steps,
        stepDuration: widget.stepDuration,
      );
      _previousStatuses = _controller!.statuses;
    });
    _controller!
      ..addListener(_onChecklistChanged)
      ..start();
  }

  @override
  void dispose() {
    _controller
      ?..removeListener(_onChecklistChanged)
      ..dispose();
    _spinnerController.dispose();
    _doneController.dispose();
    _entryController.dispose();
    super.dispose();
  }

  void _onChecklistChanged() {
    final controller = _controller!;
    final statuses = controller.statuses;
    for (var i = 0; i < statuses.length; i += 1) {
      if (statuses[i] == StepStatus.completed &&
          _previousStatuses[i] != StepStatus.completed) {
        HapticFeedbackService.lightImpact();
      }
    }
    _previousStatuses = statuses;

    if (controller.isAllDone && !_navigated) {
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.wordmark;
    final footerTextColor = isDark
        ? AppColors.checklistGreen
        : AppColors.inactiveText;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.checklistBackground
          : AppColors.background,
      body: Center(
        child: SizedBox(
          width: AppDimens.checklistCardWidth,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedBuilder(
                animation: _entryController,
                builder: (context, child) {
                  final curve = CurvedAnimation(
                    parent: _entryController,
                    curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
                  );
                  return Opacity(
                    opacity: curve.value,
                    child: Transform.translate(
                      offset: Offset(0, -10 * (1.0 - curve.value)),
                      child: child,
                    ),
                  );
                },
                child: Text(
                  'Building personalised\nSmart Posts for you!',
                  textAlign: TextAlign.center,
                  style: AppTypography.checklistTitle.copyWith(
                    color: textColor,
                  ),
                ),
              ),
              const SizedBox(height: AppDimens.checklistGap),
              SizedBox(
                width: AppDimens.checklistContainerWidth,
                child: _controller == null
                    ? const SizedBox()
                    : ListenableBuilder(
                        listenable: _controller!,
                        builder: (context, child) {
                          final controller = _controller!;
                          return Column(
                            children: [
                              for (
                                var i = 0;
                                i < controller.steps.length;
                                i += 1
                              )
                                Padding(
                                  padding: EdgeInsets.only(
                                    bottom: i == controller.steps.length - 1
                                        ? AppDimens.zero
                                        : AppDimens.checklistRowGap,
                                  ),
                                  child: AnimatedBuilder(
                                    animation: _entryController,
                                    builder: (context, child) {
                                      final start = i * 0.15;
                                      final end = (start + 0.4).clamp(0.0, 1.0);
                                      final curve = CurvedAnimation(
                                        parent: _entryController,
                                        curve: Interval(
                                          start,
                                          end,
                                          curve: Curves.easeOutCubic,
                                        ),
                                      );
                                      return Opacity(
                                        opacity: curve.value,
                                        child: Transform.translate(
                                          offset: Offset(
                                            0,
                                            15 * (1.0 - curve.value),
                                          ),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: _ChecklistRow(
                                      label: controller.steps[i].label,
                                      status: controller.statuses[i],
                                      spinnerController: _spinnerController,
                                    ),
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
                child: Text(
                  'All set! Get ready to share...',
                  style: AppTypography.checklistFooter.copyWith(
                    color: footerTextColor,
                  ),
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? AppColors.white : AppColors.wordmark;
    final isActiveOrDone = status != StepStatus.pending;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                  ? textColor
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final checkIconColor = isDark
        ? AppColors.checklistBackground
        : AppColors.white;

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 300),
      transitionBuilder: (child, animation) {
        final scale = Tween<double>(begin: 0.8, end: 1.0).animate(
          CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
        );
        final opacity = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));
        return ScaleTransition(
          scale: scale,
          child: FadeTransition(opacity: opacity, child: child),
        );
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
          child: const SizedBox(
            width: AppDimens.checklistMarker,
            height: AppDimens.checklistMarker,
            child: CustomPaint(
              painter: SpinnerPainter(
                color: AppColors.checklistGreen,
                trackColor: Colors.transparent,
                strokeWidth: 2.5,
              ),
            ),
          ),
        ),
        StepStatus.completed => Container(
          key: const ValueKey(StepStatus.completed),
          decoration: const BoxDecoration(
            color: AppColors.checklistGreen,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 400),
            curve: Curves.elasticOut,
            tween: Tween<double>(begin: 0.0, end: 1.0),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Icon(
              Icons.check_rounded,
              size: AppDimens.checklistCheckIcon,
              color: checkIconColor,
            ),
          ),
        ),
      },
    );
  }
}
