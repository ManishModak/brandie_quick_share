import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_dimens.dart';
import '../../core/app_typography.dart';
import '../../logic/caption_controller.dart';
import '../services/haptic_feedback_service.dart';

class EditCaptionScreen extends StatefulWidget {
  const EditCaptionScreen({super.key, required this.controller});

  final CaptionController controller;

  @override
  State<EditCaptionScreen> createState() => _EditCaptionScreenState();
}

class _EditCaptionScreenState extends State<EditCaptionScreen> {
  late final TextEditingController _textController;

  @override
  void initState() {
    super.initState();
    _textController = TextEditingController(text: widget.controller.draftText);
    _textController.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    _textController
      ..removeListener(_onTextChanged)
      ..dispose();
    super.dispose();
  }

  void _onTextChanged() {
    widget.controller.updateDraft(_textController.text);
  }

  void _discardAndClose() {
    widget.controller.discard();
    Navigator.of(context).pop();
  }

  void _saveAndClose() {
    widget.controller.save();
    HapticFeedbackService.mediumImpact();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: AppDimens.editHeaderHeight,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      width: AppDimens.closeButtonSize,
                      height: AppDimens.closeButtonSize,
                      child: IconButton(
                        icon: const Icon(Icons.close),
                        color: AppColors.wordmark,
                        onPressed: _discardAndClose,
                      ),
                    ),
                  ),
                  const Text(
                    'Edit Caption',
                    style: AppTypography.editCaptionTitle,
                  ),
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding: const EdgeInsets.only(
                        right: AppDimens.horizontalPadding,
                      ),
                      child: ListenableBuilder(
                        listenable: widget.controller,
                        builder: (context, child) {
                          final canSave = widget.controller.canSave;
                          return SizedBox(
                            width: AppDimens.saveButtonWidth,
                            height: AppDimens.saveButtonHeight,
                            child: TextButton(
                              onPressed: canSave ? _saveAndClose : null,
                              style: TextButton.styleFrom(
                                backgroundColor: canSave
                                    ? AppColors.activeGreen
                                    : AppColors.saveButtonDisabledBg,
                                foregroundColor: canSave
                                    ? AppColors.white
                                    : AppColors.saveButtonDisabledText,
                                disabledForegroundColor:
                                    AppColors.saveButtonDisabledText,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    AppDimens.counterRadius,
                                  ),
                                ),
                              ),
                              child: const Text('Save'),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppDimens.editBodyPadding),
                child: TextField(
                  controller: _textController,
                  autofocus: true,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    contentPadding: EdgeInsets.zero,
                  ),
                  style: AppTypography.body.copyWith(color: AppColors.wordmark),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Route<void> buildEditCaptionRoute(CaptionController controller) {
  return PageRouteBuilder<void>(
    transitionDuration: const Duration(
      milliseconds: AppDimens.standardAnimationMs,
    ),
    reverseTransitionDuration: const Duration(
      milliseconds: AppDimens.standardAnimationMs,
    ),
    pageBuilder: (context, animation, secondaryAnimation) {
      return EditCaptionScreen(controller: controller);
    },
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(parent: animation, curve: Curves.easeOut);
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 1),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
