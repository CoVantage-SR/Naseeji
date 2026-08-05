class Validators {
  Validators._();

  /// Converts Eastern Arabic numerals (٠١٢٣٤٥٦٧٨٩) to standard ASCII digits (0-9).
  static String normalizeArabicNumerals(String input) {
    const arabicDigits = ['٠', '١', '٢', '٣', '٤', '٥', '٦', '٧', '٨', '٩'];
    var result = input;
    for (var i = 0; i < arabicDigits.length; i++) {
      result = result.replaceAll(arabicDigits[i], '$i');
    }
    return result;
  }

  /// Sanitizes phone number by normalizing numerals and stripping whitespace & special chars.
  static String sanitizePhone(String input) {
    final normalized = normalizeArabicNumerals(input);
    return normalized.replaceAll(RegExp(r'[\s\-\+\(\)]+'), '');
  }

  /// Checks if a string is a valid Egyptian mobile phone number.
  /// Valid Egyptian mobile networks: 010 (Vodafone), 011 (Etisalat), 012 (Orange), 015 (WE).
  static bool isEgyptianPhone(String input) {
    var clean = sanitizePhone(input);
    if (clean.startsWith('0020')) {
      clean = clean.substring(4);
    } else if (clean.startsWith('20')) {
      clean = clean.substring(2);
    }
    return RegExp(r'^01[0125][0-9]{8}$').hasMatch(clean);
  }

  static String? required(String? value, [String message = 'هذا الحقل مطلوب']) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    final trimmed = value.trim();
    final regex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    if (!regex.hasMatch(trimmed)) {
      return 'يرجى إدخال بريد إلكتروني صحيح (مثال: example@domain.com)';
    }
    return null;
  }

  /// Validates Egyptian mobile phone numbers (Vodafone, Orange, Etisalat, WE).
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف المصري';
    }
    if (!isEgyptianPhone(value)) {
      return 'يرجى إدخال رقم هاتف مصري صحيح (11 رقماً يبدأ بـ 010 أو 011 أو 012 أو 015)';
    }
    return null;
  }

  /// Validates input as either a valid email or a valid Egyptian phone number.
  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'أدخل بريدك الإلكتروني أو رقم هاتفك';
    }
    final input = value.trim();
    if (input.contains('@')) {
      return email(input);
    } else {
      if (!isEgyptianPhone(input)) {
        return 'يرجى إدخال بريد إلكتروني صحيح أو رقم هاتف مصري يبدأ بـ (010, 011, 012, 015)';
      }
    }
    return null;
  }

  /// Basic password validation.
  static String? password(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    final trimmed = value.trim();
    if (trimmed.length < 6) {
      return 'كلمة المرور يجب أن لا تقل عن 6 أحرف';
    }
    return null;
  }

  /// Strong password validation for registration (minimum 8 chars, letters and numbers).
  static String? strongPassword(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    final trimmed = value.trim();
    if (trimmed.length < 8) {
      return 'كلمة المرور يجب أن لا تقل عن 8 أحرف';
    }
    final hasLetter = RegExp(r'[a-zA-Z\u0600-\u06FF]').hasMatch(trimmed);
    final hasDigit = RegExp(r'[0-9\u0660-\u0669]').hasMatch(trimmed);
    if (!hasLetter || !hasDigit) {
      return 'كلمة المرور يجب أن تحتوي على أحرف وأرقام معاً لضمان الأمان';
    }
    return null;
  }
}
