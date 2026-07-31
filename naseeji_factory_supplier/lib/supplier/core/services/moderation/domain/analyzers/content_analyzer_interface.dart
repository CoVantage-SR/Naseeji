import 'package:naseeji_factory/supplier/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/supplier/core/services/moderation/domain/entities/moderation_result.dart';

abstract class ContentAnalyzer {
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  });
}
