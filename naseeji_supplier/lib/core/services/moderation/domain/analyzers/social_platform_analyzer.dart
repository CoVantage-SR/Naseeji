import 'package:naseeji_supplier/core/services/moderation/domain/analyzers/content_analyzer_interface.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_supplier/core/services/moderation/domain/entities/moderation_result.dart';

class SocialPlatformAnalyzer implements ContentAnalyzer {
  static const List<String> _socialKeywords = [
    'whatsapp',
    'واتساب',
    'واتس',
    'telegram',
    'تليجرام',
    'تلجرام',
    'facebook',
    'فيسبوك',
    'فيس',
    'messenger',
    'ماسينجر',
    'مسنجر',
    'instagram',
    'انستجرام',
    'انستا',
    'tiktok',
    'تيكتوك',
    'تيك توك',
    'linkedin',
    'لينكدإن',
    'snapchat',
    'سناب شات',
    'سناب',
    'twitter',
    'تويتر',
    'youtube',
    'يوتيوب',
    'discord',
    'ديسكورد',
    'skype',
    'سكايب',
    'zoom',
    'زوم',
    'google meet',
    'جوجل ميت',
    'teams',
    'تيمز',
  ];

  @override
  Future<ContentModerationResult?> analyze({
    required String text,
    required ModerationTarget target,
  }) async {
    final lowerText = text.toLowerCase();

    for (final kw in _socialKeywords) {
      if (lowerText.contains(kw)) {
        return ContentModerationResult(
          isAllowed: false,
          target: target,
          violationType: ViolationType.socialPlatform,
          matchedSnippet: kw,
          timestamp: DateTime.now(),
        );
      }
    }
    return null;
  }
}
