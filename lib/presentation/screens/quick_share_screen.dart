import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';
import '../../logic/caption_controller.dart';
import '../../logic/feed_controller.dart';
import '../../logic/product_overlay_controller.dart';
import '../../logic/share_flow_controller.dart';
import '../services/haptic_feedback_service.dart';
import '../widgets/bottom_nav_overlay.dart';
import '../widgets/category_tabs.dart';
import '../widgets/feed_card.dart';
import '../widgets/share_progress_overlay.dart';
import '../widgets/top_action_bar.dart';
import 'edit_caption_screen.dart';
import 'platform_splash_screen.dart';
import 'smart_post_checklist_screen.dart';

class QuickShareScreen extends StatefulWidget {
  const QuickShareScreen({
    super.key,
    PostRepository? repository,
    this.productOverlayDelay = const Duration(
      seconds: AppDimens.productOverlayDelaySeconds,
    ),
    this.shareStepDuration = const Duration(
      milliseconds: AppDimens.defaultShareStepMs,
    ),
    this.redirectDuration = const Duration(
      seconds: AppDimens.defaultRedirectSeconds,
    ),
  }) : repository = repository ?? const MockPostRepository();

  final PostRepository repository;
  final Duration productOverlayDelay;
  final Duration shareStepDuration;
  final Duration redirectDuration;

  @override
  State<QuickShareScreen> createState() => _QuickShareScreenState();
}

class _QuickShareScreenState extends State<QuickShareScreen> {
  late final List<SmartPost> _posts;
  late final List<SharePlatform> _platforms;
  late final FeedController _feedController;
  late final ProductOverlayController _productOverlayController;
  late final ShareFlowController _shareFlowController;
  late final Map<String, CaptionController> _captionControllers;

  bool _splashRoutePushed = false;

  @override
  void initState() {
    super.initState();
    _posts = widget.repository.fetchSmartPosts();
    _platforms = widget.repository.fetchSharePlatforms();
    _feedController = FeedController(postCount: _posts.length);
    _productOverlayController = ProductOverlayController(
      delay: widget.productOverlayDelay,
    )..arm();
    _shareFlowController = ShareFlowController(
      steps: widget.repository.fetchShareSteps(),
      stepDuration: widget.shareStepDuration,
      redirectDuration: widget.redirectDuration,
    )..addListener(_onShareFlowChanged);
    _captionControllers = {
      for (final post in _posts)
        post.id: CaptionController(initialText: post.captionBody),
    };
  }

  @override
  void dispose() {
    _shareFlowController
      ..removeListener(_onShareFlowChanged)
      ..dispose();
    _productOverlayController.dispose();
    _feedController.dispose();
    for (final controller in _captionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    _feedController.onPageChanged(index);
    HapticFeedbackService.selectionClick();
    _productOverlayController
      ..reset()
      ..arm();
  }

  void _openEditCaption(CaptionController controller) {
    Navigator.of(context).push(buildEditCaptionRoute(controller));
  }

  void _startShare(SharePlatform platform) {
    _shareFlowController.start(platform);
  }

  void _showStoreSnackBar() {
    // Store launch is intentionally mocked for Phase 4; no external URL opens.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Opening your personal beauty store…')),
    );
  }

  void _rerunChecklist() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (context) {
          return SmartPostChecklistScreen(repository: widget.repository);
        },
      ),
    );
  }

  void _onShareFlowChanged() {
    final phase = _shareFlowController.phase;
    if (phase == ShareFlowPhase.redirecting && !_splashRoutePushed) {
      final platform = _shareFlowController.activePlatform;
      if (platform == null) {
        return;
      }
      _splashRoutePushed = true;
      HapticFeedbackService.mediumImpact();
      // Redirect is simulated by design for this assignment.
      Navigator.of(context).push(
        MaterialPageRoute<void>(
          builder: (context) => PlatformSplashScreen(platform: platform),
        ),
      );
      return;
    }

    if (phase == ShareFlowPhase.done) {
      if (_splashRoutePushed && Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
      _splashRoutePushed = false;
      _shareFlowController.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            SizedBox(
              height: AppDimens.headerHeight,
              child: Column(
                children: [
                  TopActionBar(onAssistantTap: _rerunChecklist),
                  const CategoryTabs(),
                ],
              ),
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _posts.length,
                    onPageChanged: _onPageChanged,
                    itemBuilder: (context, index) {
                      return ListenableBuilder(
                        listenable: _feedController,
                        builder: (context, child) {
                          final post = _posts[index];
                          final captionController =
                              _captionControllers[post.id]!;
                          return FeedCard(
                            post: post,
                            platforms: _platforms,
                            counterLabel: _feedController.counterLabel,
                            activeIndex: _feedController.activeIndex,
                            postCount: _posts.length,
                            captionController: captionController,
                            productOverlayController: _productOverlayController,
                            onEditCaption: () {
                              _openEditCaption(captionController);
                            },
                            onPlatformTap: _startShare,
                            onProductTap: _showStoreSnackBar,
                          );
                        },
                      );
                    },
                  ),
                  const BottomNavOverlay(),
                  const _HomeIndicator(),
                  ShareProgressOverlay(controller: _shareFlowController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HomeIndicator extends StatelessWidget {
  const _HomeIndicator();

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: AppDimens.homeIndicatorBottom),
        child: Container(
          width: AppDimens.homeIndicatorWidth,
          height: AppDimens.homeIndicatorHeight,
          decoration: BoxDecoration(
            color: AppColors.white,
            borderRadius: BorderRadius.circular(AppDimens.homeIndicatorHeight),
          ),
        ),
      ),
    );
  }
}
