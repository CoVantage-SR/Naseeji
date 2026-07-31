import 'domain/entities/moderation_enums.dart';
import 'domain/entities/moderation_result.dart';
import 'domain/entities/violation_log.dart';
import 'domain/analyzers/content_analyzer_interface.dart';
import 'domain/analyzers/phone_number_analyzer.dart';
import 'domain/analyzers/email_analyzer.dart';
import 'domain/analyzers/url_analyzer.dart';
import 'domain/analyzers/short_link_analyzer.dart';
import 'domain/analyzers/social_platform_analyzer.dart';
import 'domain/analyzers/ocr_scanner_stub.dart';
import 'domain/analyzers/pdf_scanner_stub.dart';
import 'domain/analyzers/qr_scanner_stub.dart';

class ContentModerationService {
  final List<ContentAnalyzer> _analyzers;
  final List<ViolationLog> _violationLogs = [];
  final Map<ModerationTarget, int> _targetAttemptCounts = {};

  ContentModerationService({List<ContentAnalyzer>? analyzers})
      : _analyzers = analyzers ??
            [
              PhoneNumberAnalyzer(),
              EmailAnalyzer(),
              UrlAnalyzer(),
              ShortLinkAnalyzer(),
              SocialPlatformAnalyzer(),
              ImageOcrAnalyzer(),
              PdfContentAnalyzer(),
              QrCodeAnalyzer(),
            ];

  List<ViolationLog> get violationLogs => List.unmodifiable(_violationLogs);

  Future<ContentModerationResult> moderateContent({
    required String text,
    required ModerationTarget target,
  }) async {
    if (text.trim().isEmpty) {
      return ContentModerationResult.clean(target);
    }

    // Run Pipeline Analyzers sequentially
    for (final analyzer in _analyzers) {
      final result = await analyzer.analyze(text: text, target: target);
      if (result != null && !result.isAllowed) {
        // Increment Attempt Count for Target
        final attempts = (_targetAttemptCounts[target] ?? 0) + 1;
        _targetAttemptCounts[target] = attempts;

        // Determine Escalation Severity Level
        ModerationSeverity severity;
        if (attempts == 1) {
          severity = ModerationSeverity.low;
        } else if (attempts == 2) {
          severity = ModerationSeverity.medium;
        } else {
          severity = ModerationSeverity.high; // 3+ attempts: flag for support review
        }

        // Record Violation Log silently
        _violationLogs.add(
          ViolationLog(
            id: 'viol-${DateTime.now().millisecondsSinceEpoch}',
            target: target,
            violationType: result.violationType ?? ViolationType.phone,
            matchedSnippet: result.matchedSnippet ?? '',
            attemptCount: attempts,
            timestamp: DateTime.now(),
          ),
        );

        return ContentModerationResult(
          isAllowed: false,
          target: target,
          violationType: result.violationType,
          matchedSnippet: result.matchedSnippet,
          attemptCount: attempts,
          severity: severity,
          userMessageTitle: 'لا يمكن إكمال العملية',
          userMessageBody:
              'تم اكتشاف وسيلة تواصل خارج منصة نسيجي.\nلضمان حماية جميع الأطراف، يجب أن تتم جميع المحادثات والاتفاقات داخل المنصة.',
          timestamp: DateTime.now(),
        );
      }
    }

    return ContentModerationResult.clean(target);
  }

  void resetAttemptCount(ModerationTarget target) {
    _targetAttemptCounts[target] = 0;
  }
}

