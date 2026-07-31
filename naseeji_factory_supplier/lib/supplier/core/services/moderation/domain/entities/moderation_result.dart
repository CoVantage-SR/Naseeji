import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';

class ContentModerationResult {
  final bool isAllowed;
  final ModerationTarget target;
  final ViolationType? violationType;
  final String? matchedSnippet;
  final int attemptCount;
  final ModerationSeverity severity;
  final String userMessageTitle;
  final String userMessageBody;
  final DateTime timestamp;

  const ContentModerationResult({
    required this.isAllowed,
    required this.target,
    this.violationType,
    this.matchedSnippet,
    this.attemptCount = 0,
    this.severity = ModerationSeverity.low,
    this.userMessageTitle = 'لا يمكن إكمال العملية',
    this.userMessageBody =
        'تم اكتشاف وسيلة تواصل خارج منصة نسيجي.\nلضمان حماية جميع الأطراف، يجب أن تتم جميع المحادثات والاتفاقات داخل المنصة.',
    required this.timestamp,
  });

  static ContentModerationResult clean(ModerationTarget target) {
    return ContentModerationResult(
      isAllowed: true,
      target: target,
      timestamp: DateTime.now(),
    );
  }
}




