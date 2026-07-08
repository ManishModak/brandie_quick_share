import 'package:flutter/foundation.dart';

/// Owns caption editing state independently from any text field widget.
class CaptionController extends ChangeNotifier {
  CaptionController({required String initialText})
    : _originalText = initialText,
      _draftText = initialText;

  String _originalText;
  String _draftText;
  bool _isExpanded = false;

  String get originalText => _originalText;
  String get draftText => _draftText;
  bool get isExpanded => _isExpanded;

  bool get canSave {
    final trimmedDraft = _draftText.trim();
    return trimmedDraft.isNotEmpty && trimmedDraft != _originalText;
  }

  void toggleExpanded() {
    _isExpanded = !_isExpanded;
    notifyListeners();
  }

  void updateDraft(String text) {
    if (text == _draftText) {
      return;
    }
    _draftText = text;
    notifyListeners();
  }

  void save() {
    if (!canSave) {
      return;
    }
    _originalText = _draftText.trim();
    _draftText = _originalText;
    notifyListeners();
  }

  void discard() {
    if (_draftText == _originalText) {
      return;
    }
    _draftText = _originalText;
    notifyListeners();
  }
}
