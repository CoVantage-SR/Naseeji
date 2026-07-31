class ValidationUtils {
  ValidationUtils._();

  // Egypt phone number formats (010, 011, 012, 015 followed by 8 digits)
  static final RegExp _egyptPhoneRegex = RegExp(r'^01[0125][0-9]{8}$');
  static final RegExp _emailRegex = RegExp(
    r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
  );

  static String? validatePhone(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رقم الهاتف';
    }
    if (!_egyptPhoneRegex.hasMatch(value)) {
      return 'يرجى إدخال رقم هاتف مصري صحيح (مثال: 01012345678)';
    }
    return null;
  }

  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }
    if (!_emailRegex.hasMatch(value)) {
      return 'يرجى إدخال بريد إلكتروني صحيح';
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال كلمة المرور';
    }
    if (value.length < 8) {
      return 'يجب أن لا تقل كلمة المرور عن 8 أحرف';
    }
    // Check for uppercase, lowercase, digits, symbols
    bool hasUppercase = value.contains(RegExp(r'[A-Z]'));
    bool hasLowercase = value.contains(RegExp(r'[a-z]'));
    bool hasDigits = value.contains(RegExp(r'[0-9]'));
    bool hasSpecialCharacters = value.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));

    if (!hasUppercase || !hasLowercase || !hasDigits || !hasSpecialCharacters) {
      return 'يجب أن تحتوي كلمة المرور على أحرف كبيرة وصغيرة وأرقام ورموز';
    }
    return null;
  }

  static double checkPasswordStrength(String password) {
    if (password.isEmpty) return 0.0;
    
    double score = 0.0;
    if (password.length >= 8) score += 0.25;
    if (password.contains(RegExp(r'[A-Z]'))) score += 0.25;
    if (password.contains(RegExp(r'[a-z]'))) score += 0.25;
    if (password.contains(RegExp(r'[0-9]'))) score += 0.125;
    if (password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) score += 0.125;
    
    return score; // returns double between 0.0 and 1.0
  }

  static String getPasswordStrengthText(double strength) {
    if (strength <= 0.25) return 'ضعيفة جداً';
    if (strength <= 0.5) return 'ضعيفة';
    if (strength <= 0.75) return 'متوسطة';
    return 'قوية جداً';
  }

  static String? validateOtp(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال رمز التحقق';
    }
    if (value.length != 4 || int.tryParse(value) == null) {
      return 'يجب إدخال رمز مكون من 4 أرقام';
    }
    return null;
  }
}
