class QuotationValidator {
  static String? validateUnitPrice(double? unitPrice) {
    if (unitPrice == null || unitPrice <= 0) {
      return 'سعر الوحدة يجب أن يكون أكبر من الصفر';
    }
    return null;
  }

  static String? validateQuotedQuantity({
    required double? quotedQuantity,
    required double availableQuantity,
  }) {
    if (quotedQuantity == null || quotedQuantity <= 0) {
      return 'الكمية المطلوبة يجب أن تكون أكبر من الصفر';
    }
    if (quotedQuantity > availableQuantity) {
      return 'الكمية المتاحة لا تكفي (المتاح: $availableQuantity)';
    }
    return null;
  }

  static String? validateExpirationDate(DateTime? expirationDate) {
    if (expirationDate == null) {
      return 'يرجى تحديد تاريخ انتهاء العرض';
    }
    if (expirationDate.isBefore(DateTime.now())) {
      return 'تاريخ انتهاء صلاحية العرض يجب أن يكون في المستقبل';
    }
    return null;
  }
}

