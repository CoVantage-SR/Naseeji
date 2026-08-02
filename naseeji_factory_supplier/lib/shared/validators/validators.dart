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
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!regex.hasMatch(trimmed)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    final normalized = normalizeArabicNumerals(value);
    final clean = normalized.replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 10) {
      return 'رقم الهاتف يجب أن يتكون من 10 أرقام على الأقل';
    }
    return null;
  }

  static String? emailOrPhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'أدخل بريدك الإلكتروني أو رقم هاتفك';
    }
    final input = value.trim();
    if (input.contains('@')) {
      return email(input);
    } else {
      final normalized = normalizeArabicNumerals(input);
      final clean = normalized.replaceAll(RegExp(r'[\s\-\+]+'), '');
      if (clean.length < 8) {
        return 'يرجى إدخال بريد إلكتروني أو رقم هاتف صحيح';
      }
    }
    return null;
  }

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
}
