import 'package:naseeji_factory/supplier/core/services/moderation/domain/entities/moderation_enums.dart';

class ViolationLog {
  final String id;
  final ModerationTarget target;
  final ViolationType violationType;
  final String matchedSnippet;
  final int attemptCount;
  final DateTime timestamp;

  const ViolationLog({
    required this.id,
    required this.target,
    required this.violationType,
    required this.matchedSnippet,
    required this.attemptCount,
    required this.timestamp,
  });
}
