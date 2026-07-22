import 'package:naseeji_supplier/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_result.dart';

class PhoneNumberAnalyzer implements ContentAnalyzer {
  static final RegExp _egyptianPhoneRegex = RegExp(
    r'(?:\+?20|0)?1[0125]\d{8}|01\d{9}|\b\d{10,14}\b',
    caseSensitive: false,
  );

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    if (_egyptianPhoneRegex.hasMatch(text)) {
      final match = _egyptianPhoneRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isAllowed: false,
        target: target,
        violationType: ViolationType.phone,
        matchedSnippet: match,
        timestamp: DateTime.now(),
      );
    }
    return null;
  }
}
