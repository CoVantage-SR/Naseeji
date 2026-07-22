class ContentModerationResult {
  final bool isProhibited;
  final String? reason;
  final String? matchedSnippet;

  const ContentModerationResult({
    required this.isProhibited,
    this.reason,
    this.matchedSnippet,
  });

  static const clean = ContentModerationResult(isProhibited: false);
}

class ContentModerationService {
  static const String warningMessage =
      'تم اكتشاف وسيلة تواصل خارج منصة نسيجي.\nيرجى إتمام جميع المحادثات والمعاملات داخل المنصة لحماية حقوقك ومستحقاتك المالية.';

  // Phone numbers regex (Egyptian 11 digits & international formats)
  static final RegExp _phoneRegex = RegExp(
    r'(?:\+?20|0)?1[0125]\d{8}|01\d{9}|\b\d{10,14}\b',
    caseSensitive: false,
  );

  // Email regex
  static final RegExp _emailRegex = RegExp(
    r'[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}',
    caseSensitive: false,
  );

  // Web URLs regex
  static final RegExp _urlRegex = RegExp(
    r'(https?:\/\/|www\.)[^\s/$.?#].[^\s]*|\b[a-zA-Z0-9.-]+\.(com|net|org|io|eg|me|app)\b',
    caseSensitive: false,
  );

  // Social App Keywords in Arabic & English
  static final List<String> _prohibitedKeywords = [
    'واتس',
    'واتساب',
    'whatsapp',
    'whats',
    'تليجرام',
    'تلجرام',
    'telegram',
    'فيسبوك',
    'فيس',
    'facebook',
    'انستجرام',
    'انستا',
    'instagram',
    'فون',
    'موبايل',
    'اتصل بي',
    'اتصل على',
    'كلمني على',
    'رقمي هو',
    'ايميلي',
    'gmail',
    'yahoo',
    'hotmail',
    'كاش',
    'فودافون كاش',
    'تحويل خارجي',
  ];

  ContentModerationResult moderate(String text) {
    if (text.trim().isEmpty) return ContentModerationResult.clean;

    final lowerText = text.toLowerCase();

    // 1. Check Phone Numbers
    if (_phoneRegex.hasMatch(text)) {
      final match = _phoneRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isProhibited: true,
        reason: 'تم اكتشاف رقم هاتف في الرسالة',
        matchedSnippet: match,
      );
    }

    // 2. Check Email Addresses
    if (_emailRegex.hasMatch(text)) {
      final match = _emailRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isProhibited: true,
        reason: 'تم اكتشاف بريد إلكتروني في الرسالة',
        matchedSnippet: match,
      );
    }

    // 3. Check External Web URLs
    if (_urlRegex.hasMatch(text)) {
      final match = _urlRegex.firstMatch(text)?.group(0);
      return ContentModerationResult(
        isProhibited: true,
        reason: 'تم اكتشاف رابط خارجي في الرسالة',
        matchedSnippet: match,
      );
    }

    // 4. Check Prohibited External Contact Keywords
    for (final kw in _prohibitedKeywords) {
      if (lowerText.contains(kw)) {
        return ContentModerationResult(
          isProhibited: true,
          reason: 'تم اكتشاف محاولة تواصل خارج المنصة ($kw)',
          matchedSnippet: kw,
        );
      }
    }

    return ContentModerationResult.clean;
  }
}
