import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/core/services/moderation/content_moderation_service.dart';

final contentModerationServiceProvider = Provider<ContentModerationService>((ref) {
  return ContentModerationService();
});
