import 'package:naseeji_factory/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_result.dart';

class EmailAnalyzer implements ContentAnalyzer {
  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    caseSensitive: false,
  );

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    if (_emailRegex.hasMatch(text)) {
      final match = _emailRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.email,
        matchedSnippet: match,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}


