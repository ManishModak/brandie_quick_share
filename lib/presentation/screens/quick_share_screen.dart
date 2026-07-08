import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../data/data.dart';
import '../../domain/domain.dart';
import '../../logic/feed_controller.dart';
import '../widgets/bottom_nav_overlay.dart';
import '../widgets/category_tabs.dart';
import '../widgets/feed_card.dart';
import '../widgets/top_action_bar.dart';

class QuickShareScreen extends StatefulWidget {
  const QuickShareScreen({super.key, PostRepository? repository})
    : repository = repository ?? const MockPostRepository();

  final PostRepository repository;

  @override
  State<QuickShareScreen> createState() => _QuickShareScreenState();
}

class _QuickShareScreenState extends State<QuickShareScreen> {
  late final List<SmartPost> _posts;
  late final List<SharePlatform> _platforms;
  late final FeedController _feedController;

  @override
  void initState() {
    super.initState();
    _posts = widget.repository.fetchSmartPosts();
    _platforms = widget.repository.fetchSharePlatforms();
    _feedController = FeedController(postCount: _posts.length);
  }

  @override
  void dispose() {
    _feedController.dispose();
    super.dispose();
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
            const SizedBox(
              height: AppDimens.headerHeight,
              child: Column(children: [TopActionBar(), CategoryTabs()]),
            ),
            Expanded(
              child: Stack(
                children: [
                  PageView.builder(
                    scrollDirection: Axis.vertical,
                    itemCount: _posts.length,
                    onPageChanged: _feedController.onPageChanged,
                    itemBuilder: (context, index) {
                      return ListenableBuilder(
                        listenable: _feedController,
                        builder: (context, child) {
                          return FeedCard(
                            post: _posts[index],
                            platforms: _platforms,
                            counterLabel: _feedController.counterLabel,
                            activeIndex: _feedController.activeIndex,
                            postCount: _posts.length,
                          );
                        },
                      );
                    },
                  ),
                  const BottomNavOverlay(),
                  const _HomeIndicator(),
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
