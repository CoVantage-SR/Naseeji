class CompanyValidator {
  static String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'اسم الشركة مطلوب';
    }
    if (value.trim().length < 2) {
      return 'اسم الشركة يجب أن يتكون من حرفين على الأقل';
    }
    return null;
  }

  static String? validateCategory(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'تخصص / تخصصات الشركة مطلوب';
    }
    return null;
  }

  static String? validateGovernorate(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى اختيار المحافظة';
    }
    return null;
  }

  static String? validateCity(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'يرجى اختيار المدينة';
    }
    return null;
  }

  static String? validateAddress(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'العنوان التفصيلي مطلوب';
    }
    if (value.trim().length < 5) {
      return 'العنوان التفصيلي يجب أن يكون 5 أحرف على الأقل';
    }
    return null;
  }

  static String? validateCommercialRegister(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'رقم السجل التجاري مطلوب';
    }
    final cleanVal = value.trim();
    if (!RegExp(r'^[0-9A-Za-z\s\-]{4,20}$').hasMatch(cleanVal)) {
      return 'رقم السجل التجاري غير صالحة صيغته';
    }
    return null;
  }

  static String? validateTaxNumber(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final cleanVal = value.trim();
    if (cleanVal.length < 5) {
      return 'رقم البطاقة الضريبية غير مكتمل';
    }
    return null;
  }

  static String? validateWebsite(String? value) {
    if (value == null || value.trim().isEmpty) {
      return null; // Optional
    }
    final cleanVal = value.trim();
    if (!cleanVal.startsWith('http://') &&
        !cleanVal.startsWith('https://') &&
        !cleanVal.contains('.')) {
      return 'صيغة موقع الويب غير صحيحة';
    }
    return null;
  }
}
