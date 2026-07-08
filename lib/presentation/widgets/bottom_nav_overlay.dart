import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';

class BottomNavOverlay extends StatelessWidget {
  const BottomNavOverlay({super.key});

  static const _icons = [
    'assets/icons/arrow_back.svg',
    'assets/icons/search.svg',
    'assets/icons/home.svg',
    'assets/icons/chat.svg',
    'assets/icons/profile.svg',
  ];

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(
            left: AppDimens.bottomNavHorizontalPadding,
            right: AppDimens.bottomNavHorizontalPadding,
            bottom: AppDimens.bottomNavBottom,
          ),
          child: SizedBox(
            height: AppDimens.bottomNavHeight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                for (final icon in _icons)
                  SvgPicture.asset(
                    icon,
                    width: AppDimens.bottomNavIcon,
                    height: AppDimens.bottomNavIcon,
                    colorFilter: const ColorFilter.mode(
                      AppColors.white,
                      BlendMode.srcIn,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
