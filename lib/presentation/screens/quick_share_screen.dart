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
    required this.repository,
    this.productOverlayDelay = const Duration(
      seconds: AppDimens.productOverlayDelaySeconds,
    ),
    this.shareStepDuration = const Duration(
      milliseconds: AppDimens.defaultShareStepMs,
    ),
    this.redirectDuration = const Duration(
      seconds: AppDimens.defaultRedirectSeconds,
    ),
  });

  final PostRepository repository;
  final Duration productOverlayDelay;
  final Duration shareStepDuration;
  final Duration redirectDuration;

  @override
  State<QuickShareScreen> createState() => _QuickShareScreenState();
}

class _QuickShareScreenState extends State<QuickShareScreen> {
  List<SmartPost> _posts = [];
  List<SharePlatform> _platforms = [];
  FeedController? _feedController;
  ProductOverlayController? _productOverlayController;
  ShareFlowController? _shareFlowController;
  Map<String, CaptionController> _captionControllers = {};

  bool _ready = false;
  bool _splashRoutePushed = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final posts = await widget.repository.fetchSmartPosts();
    final platforms = await widget.repository.fetchSharePlatforms();
    final shareSteps = await widget.repository.fetchShareSteps();

    if (!mounted) {
      return;
    }

    setState(() {
      _posts = posts;
      _platforms = platforms;
      _feedController = FeedController(postCount: posts.length);
      _productOverlayController = ProductOverlayController(
        delay: widget.productOverlayDelay,
      )..arm();
      _shareFlowController = ShareFlowController(
        steps: shareSteps,
        stepDuration: widget.shareStepDuration,
        redirectDuration: widget.redirectDuration,
      )..addListener(_onShareFlowChanged);
      _captionControllers = {
        for (final post in posts)
          post.id: CaptionController(initialText: post.fullCaption),
      };
      _ready = true;
    });
  }

  @override
  void dispose() {
    _shareFlowController
      ?..removeListener(_onShareFlowChanged)
      ..dispose();
    _productOverlayController?.dispose();
    _feedController?.dispose();
    for (final controller in _captionControllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  void _onPageChanged(int index) {
    final feedController = _feedController;
    final productOverlayController = _productOverlayController;
    if (feedController == null || productOverlayController == null) {
      return;
    }
    feedController.onPageChanged(index);
    HapticFeedbackService.selectionClick();
    productOverlayController
      ..reset()
      ..arm();
  }

  void _openEditCaption(CaptionController controller) {
    Navigator.of(context).push(buildEditCaptionRoute(controller));
  }

  void _startShare(SharePlatform platform) {
    _shareFlowController?.start(platform);
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
    final shareFlowController = _shareFlowController;
    if (shareFlowController == null) {
      return;
    }

    final phase = shareFlowController.phase;
    if (phase == ShareFlowPhase.redirecting && !_splashRoutePushed) {
      final platform = shareFlowController.activePlatform;
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
      shareFlowController.finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!_ready) {
      return const Scaffold(
        backgroundColor: AppColors.background,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    final feedController = _feedController!;
    final productOverlayController = _productOverlayController!;
    final shareFlowController = _shareFlowController!;

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
                        listenable: feedController,
                        builder: (context, child) {
                          final post = _posts[index];
                          final captionController =
                              _captionControllers[post.id]!;
                          return FeedCard(
                            post: post,
                            platforms: _platforms,
                            counterLabel: feedController.counterLabel,
                            activeIndex: feedController.activeIndex,
                            postCount: _posts.length,
                            captionController: captionController,
                            productOverlayController: productOverlayController,
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
                  ShareProgressOverlay(controller: shareFlowController),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
