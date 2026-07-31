import 'package:naseeji_factory/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_result.dart';

class ShortLinkAnalyzer implements ContentAnalyzer {
  static final RegExp _shortLinkRegex = RegExp(
    r'\b(bit\.ly|tinyurl\.com|t\.co|goo\.gl|ow\.ly|is\.gd|buff\.ly|rebrand\.ly|cutt\.ly|shorturl\.at)\/[a-zA-Z0-9_-]+\b',
    caseSensitive: false,
  );

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    if (_shortLinkRegex.hasMatch(text)) {
      final match = _shortLinkRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.shortLink,
        matchedSnippet: match,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}



