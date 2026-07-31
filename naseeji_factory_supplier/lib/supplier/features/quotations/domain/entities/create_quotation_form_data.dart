enum PaymentMethodType {
  bankTransfer, // تحويل بنكي
  instaPay, // إنستاباي
  eWallet, // محفظة إلكترونية (فودافون كاش)
  advanceAndBalance, // دفعة مقدمة + باقي عند التسليم
  deferredCredit, // دفع آجل
}

extension PaymentMethodTypeExtension on PaymentMethodType {
  String get arabicLabel {
    switch (this) {
      case PaymentMethodType.bankTransfer:
        return 'تحويل بنكي مباشر';
      case PaymentMethodType.instaPay:
        return 'إنستاباي (InstaPay)';
      case PaymentMethodType.eWallet:
        return 'محفظة إلكترونية (فودافون كاش / غيرها)';
      case PaymentMethodType.advanceAndBalance:
        return 'دفعة مقدمة + تسديد الباقي عند الاستلام';
      case PaymentMethodType.deferredCredit:
        return 'دفع آجل بتسهيلات كبار العملاء';
    }
  }
}

class CreateQuotationFormData {
  final int currentStep; // 1 to 7
  final bool isDraftSaved;
  final String quotationId;

  // Step 1: Product & RFQ Info
  final String productName;
  final String productImage;
  final String category;
  final String rfqId;
  final String factoryName;

  // Step 2: Pricing & Discounts
  final double unitPrice;
  final String currency;
  final int quantity;
  final double discountValue; // Discount percentage or fixed amount
  final bool isDiscountPercentage;

  // Step 3: Production & Capacity
  final String productionLeadTime; // e.g. 7 أيام عمل
  final String preparationTime; // e.g. 24 ساعة
  final String targetDeliveryDate;
  final String dailyCapacity;

  // Step 4: Payment Terms
  final PaymentMethodType paymentMethod;
  final double advancePaymentPercentage; // e.g. 50%
  final String balanceDueDate; // e.g. عند اعتماد التسليم بالضمين Escrow

  // Step 5: Delivery & Warehouse Location
  final String pickupLocation;
  final int readyForPickupHours;
  final String deliveryNotes;

  // Step 6: Terms & Validity
  final String validityPeriod; // e.g. 15 يوم من تاريخ العرض
  final String specialTerms;
  final String additionalNotes;

  const CreateQuotationFormData({
    this.currentStep = 1,
    this.isDraftSaved = true,
    this.quotationId = 'QUO-8840',
    this.productName = 'خيوط قطن غزل دائرية 30/1 ممشط',
    this.productImage = 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
    this.category = 'خيوط ونُسُج',
    this.rfqId = 'RFQ-1025',
    this.factoryName = 'شركة النسيج الحديثة للملابس',
    this.unitPrice = 45.0,
    this.currency = 'ج.م',
    this.quantity = 1000,
    this.discountValue = 5.0, // 5% discount
    this.isDiscountPercentage = true,
    this.productionLeadTime = '٧ أيام عمل',
    this.preparationTime = '٢٤ ساعة',
    this.targetDeliveryDate = '٢٨ يوليو ٢٠٢٦',
    this.dailyCapacity = '٥,٠٠٠ كجم / يوم',
    this.paymentMethod = PaymentMethodType.advanceAndBalance,
    this.advancePaymentPercentage = 50.0,
    this.balanceDueDate = 'عند تسليم الشحنة وحيازة الإيصال',
    this.pickupLocation = 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى',
    this.readyForPickupHours = 48,
    this.deliveryNotes = 'النقل والتسليم يتم عبر شركة الشحن المعتمدة في منصة نسيجي.',
    this.validityPeriod = '١٥ يوم من تاريخ الإصدار',
    this.specialTerms = 'الأسعار شاملة ضريبة القيمة المضافة وموثقة بالضمان القانوني بالمنصة.',
    this.additionalNotes = 'الخامة مفحوصة ومطابقة لمعايير الجودة المصرية.',
  });

  // Calculated Total Price before discount
  double get subtotalPrice => unitPrice * quantity;

  // Calculated Discount Amount
  double get calculatedDiscountAmount {
    if (isDiscountPercentage) {
      return subtotalPrice * (discountValue / 100.0);
    } else {
      return discountValue;
    }
  }

  // Final Net Price after discount
  double get netFinalPrice => (subtotalPrice - calculatedDiscountAmount).clamp(0.0, double.infinity);

  // Calculated Advance Payment Amount
  double get advancePaymentAmount => netFinalPrice * (advancePaymentPercentage / 100.0);

  // Calculated Remaining Balance Amount
  double get remainingBalanceAmount => netFinalPrice - advancePaymentAmount;

  // Form Completion Percentage
  double get completionPercentage => (currentStep / 7.0) * 100.0;

  CreateQuotationFormData copyWith({
    int? currentStep,
    bool? isDraftSaved,
    String? quotationId,
    String? productName,
    String? productImage,
    String? category,
    String? rfqId,
    String? factoryName,
    double? unitPrice,
    String? currency,
    int? quantity,
    double? discountValue,
    bool? isDiscountPercentage,
    String? productionLeadTime,
    String? preparationTime,
    String? targetDeliveryDate,
    String? dailyCapacity,
    PaymentMethodType? paymentMethod,
    double? advancePaymentPercentage,
    String? balanceDueDate,
    String? pickupLocation,
    int? readyForPickupHours,
    String? deliveryNotes,
    String? validityPeriod,
    String? specialTerms,
    String? additionalNotes,
  }) {
    return CreateQuotationFormData(
      currentStep: currentStep ?? this.currentStep,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      quotationId: quotationId ?? this.quotationId,
      productName: productName ?? this.productName,
      productImage: productImage ?? this.productImage,
      category: category ?? this.category,
      rfqId: rfqId ?? this.rfqId,
      factoryName: factoryName ?? this.factoryName,
      unitPrice: unitPrice ?? this.unitPrice,
      currency: currency ?? this.currency,
      quantity: quantity ?? this.quantity,
      discountValue: discountValue ?? this.discountValue,
      isDiscountPercentage: isDiscountPercentage ?? this.isDiscountPercentage,
      productionLeadTime: productionLeadTime ?? this.productionLeadTime,
      preparationTime: preparationTime ?? this.preparationTime,
      targetDeliveryDate: targetDeliveryDate ?? this.targetDeliveryDate,
      dailyCapacity: dailyCapacity ?? this.dailyCapacity,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      advancePaymentPercentage: advancePaymentPercentage ?? this.advancePaymentPercentage,
      balanceDueDate: balanceDueDate ?? this.balanceDueDate,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      readyForPickupHours: readyForPickupHours ?? this.readyForPickupHours,
      deliveryNotes: deliveryNotes ?? this.deliveryNotes,
      validityPeriod: validityPeriod ?? this.validityPeriod,
      specialTerms: specialTerms ?? this.specialTerms,
      additionalNotes: additionalNotes ?? this.additionalNotes,
    );
  }
}


