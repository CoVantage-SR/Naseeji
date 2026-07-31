import 'package:naseeji_factory/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_result.dart';

class UrlAnalyzer implements ContentAnalyzer {
  static final RegExp _urlRegex = RegExp(
    r'(https?:\/\/|www\.)[^\s/$.?#].[^\s]*|\b[a-zA-Z0-9.-]+\.(com|net|org|io|eg|me|app|site|online)\b',
    caseSensitive: false,
  );

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    if (_urlRegex.hasMatch(text)) {
      final match = _urlRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.url,
        matchedSnippet: match,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}



