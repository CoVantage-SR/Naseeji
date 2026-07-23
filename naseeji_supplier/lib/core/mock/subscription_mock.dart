enum SubscriptionStatus {
  active,
  trial,
  expired,
  suspended,
  pendingPayment,
  cancelled,
}

enum SubscriptionPlanType {
  starter,
  professional,
  enterprise,
}

class SubscriptionPlanMock {
  final String id;
  final String name;
  final SubscriptionPlanType type;
  final double pricePerMonth;
  final double pricePerYear;
  final int productsLimit;
  final int imagesPerProduct;
  final int videosPerProduct;
  final int pdfPerProduct;
  final int employeeLimit;
  final bool analyticsEnabled;
  final bool prioritySupport;
  final String description;

  const SubscriptionPlanMock({
    required this.id,
    required this.name,
    required this.type,
    required this.pricePerMonth,
    required this.pricePerYear,
    required this.productsLimit,
    required this.imagesPerProduct,
    required this.videosPerProduct,
    required this.pdfPerProduct,
    required this.employeeLimit,
    required this.analyticsEnabled,
    required this.prioritySupport,
    required this.description,
  });

  static const samplePlans = [
    SubscriptionPlanMock(
      id: 'plan_starter',
      name: 'الباقة الأساسية (Starter)',
      type: SubscriptionPlanType.starter,
      pricePerMonth: 499.0,
      pricePerYear: 4990.0,
      productsLimit: 5,
      imagesPerProduct: 3,
      videosPerProduct: 1,
      pdfPerProduct: 1,
      employeeLimit: 2,
      analyticsEnabled: false,
      prioritySupport: false,
      description: 'مناسبة للموردين الجدد والمنشآت الصغرى للبدء في بورصة نسيجي.',
    ),

    SubscriptionPlanMock(
      id: 'plan_professional',
      name: 'الباقة الاحترافية (Professional)',
      type: SubscriptionPlanType.professional,
      pricePerMonth: 1299.0,
      pricePerYear: 12990.0,
      productsLimit: 25,
      imagesPerProduct: 10,
      videosPerProduct: 3,
      pdfPerProduct: 5,
      employeeLimit: 10,
      analyticsEnabled: true,
      prioritySupport: true,
      description: 'الباقة الأكثر طلباً للمصانع والموردين المحترفين للنمو والتوسع.',
    ),
    SubscriptionPlanMock(
      id: 'plan_enterprise',
      name: 'باقة كبار الموردين (Enterprise)',
      type: SubscriptionPlanType.enterprise,
      pricePerMonth: 2999.0,
      pricePerYear: 29990.0,
      productsLimit: 999,
      imagesPerProduct: 50,
      videosPerProduct: 20,
      pdfPerProduct: 20,
      employeeLimit: 50,
      analyticsEnabled: true,
      prioritySupport: true,
      description: 'حلول متكاملة للمصانع الكبرى والمجموعات الصناعية مع ربط API ومسؤول حساب مخصص.',
    ),
    





  ];
}

class SubscriptionInvoiceMock {
  final String invoiceId;
  final String subscriptionId;
  final String planName;
  final double amount;
  final String currency;
  final DateTime invoiceDate;
  final String paymentMethod;
  final String status;

  const SubscriptionInvoiceMock({
    required this.invoiceId,
    required this.subscriptionId,
    required this.planName,
    required this.amount,
    this.currency = 'ج.م',
    required this.invoiceDate,
    required this.paymentMethod,
    required this.status,
  });

  static final sampleInvoices = [
    SubscriptionInvoiceMock(
      invoiceId: 'INV-SUB-901',
      subscriptionId: 'SUB-101',
      planName: 'الباقة الاحترافية (Professional)',
      amount: 1299.0,
      invoiceDate: DateTime.now().subtract(const Duration(days: 23)),
      paymentMethod: 'بطاقة ائتمانية (فوري / ميزة)',
      status: 'مدفوع 🟢',
    ),
  ];
}

class SubscriptionHistoryMock {
  final String historyId;
  final String action;
  final String oldPlanName;
  final String newPlanName;
  final DateTime timestamp;
  final String notes;

  const SubscriptionHistoryMock({
    required this.historyId,
    required this.action,
    required this.oldPlanName,
    required this.newPlanName,
    required this.timestamp,
    required this.notes,
  });

  static final sampleHistory = [
    SubscriptionHistoryMock(
      historyId: 'HIST-001',
      action: 'تفعيل الباقة',
      oldPlanName: 'الباقة الأساسية (Starter)',
      newPlanName: 'الباقة الاحترافية (Professional)',
      timestamp: DateTime.now().subtract(const Duration(days: 23)),
      notes: 'تمت الترقية إلى الباقة الاحترافية بنجاح.',
    ),
  ];
}

class SubscriptionModel {
  final String subscriptionId;
  final String supplierId;
  final String planName;
  final SubscriptionPlanType planType;
  final SubscriptionStatus status;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime renewalDate;
  final int productsLimit;
  final int productsUsed;
  final int imagesPerProduct;
  final int videosPerProduct;
  final int pdfPerProduct;
  final bool analyticsEnabled;
  final bool prioritySupport;
  final int employeeLimit;
  final bool canPublishProducts;
  final bool canEditProducts;
  final bool canRepublishProducts;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SubscriptionModel({
    required this.subscriptionId,
    required this.supplierId,
    required this.planName,
    required this.planType,
    required this.status,
    required this.startDate,
    required this.endDate,
    required this.renewalDate,
    required this.productsLimit,
    required this.productsUsed,
    required this.imagesPerProduct,
    required this.videosPerProduct,
    required this.pdfPerProduct,
    required this.analyticsEnabled,
    required this.prioritySupport,
    required this.employeeLimit,
    required this.canPublishProducts,
    required this.canEditProducts,
    required this.canRepublishProducts,
    required this.createdAt,
    required this.updatedAt,
  });

  int get remainingDays {
    final diff = endDate.difference(DateTime.now()).inDays;
    return diff < 0 ? 0 : diff;
  }

  int get remainingProducts {
    final rem = productsLimit - productsUsed;
    return rem < 0 ? 0 : rem;
  }

  bool get isExpired => status == SubscriptionStatus.expired || DateTime.now().isAfter(endDate);

  bool get isExpiringSoon => remainingDays <= 7 && !isExpired;

  SubscriptionModel copyWith({
    String? subscriptionId,
    String? supplierId,
    String? planName,
    SubscriptionPlanType? planType,
    SubscriptionStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? renewalDate,
    int? productsLimit,
    int? productsUsed,
    int? imagesPerProduct,
    int? videosPerProduct,
    int? pdfPerProduct,
    bool? analyticsEnabled,
    bool? prioritySupport,
    int? employeeLimit,
    bool? canPublishProducts,
    bool? canEditProducts,
    bool? canRepublishProducts,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SubscriptionModel(
      subscriptionId: subscriptionId ?? this.subscriptionId,
      supplierId: supplierId ?? this.supplierId,
      planName: planName ?? this.planName,
      planType: planType ?? this.planType,
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      renewalDate: renewalDate ?? this.renewalDate,
      productsLimit: productsLimit ?? this.productsLimit,
      productsUsed: productsUsed ?? this.productsUsed,
      imagesPerProduct: imagesPerProduct ?? this.imagesPerProduct,
      videosPerProduct: videosPerProduct ?? this.videosPerProduct,
      pdfPerProduct: pdfPerProduct ?? this.pdfPerProduct,
      analyticsEnabled: analyticsEnabled ?? this.analyticsEnabled,
      prioritySupport: prioritySupport ?? this.prioritySupport,
      employeeLimit: employeeLimit ?? this.employeeLimit,
      canPublishProducts: canPublishProducts ?? this.canPublishProducts,
      canEditProducts: canEditProducts ?? this.canEditProducts,
      canRepublishProducts: canRepublishProducts ?? this.canRepublishProducts,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  static final defaultSubscription = SubscriptionModel(
    subscriptionId: 'SUB-101',
    supplierId: 'SUP-001',
    planName: 'الباقة الاحترافية (Professional)',
    planType: SubscriptionPlanType.professional,
    status: SubscriptionStatus.active,
    startDate: DateTime.now().subtract(const Duration(days: 23)),
    endDate: DateTime.now().add(const Duration(days: 7)),
    renewalDate: DateTime.now().add(const Duration(days: 7)),
    productsLimit: 25,
    productsUsed: 2,
    imagesPerProduct: 10,
    videosPerProduct: 3,
    pdfPerProduct: 5,
    analyticsEnabled: true,
    prioritySupport: true,
    employeeLimit: 10,
    canPublishProducts: true,
    canEditProducts: true,
    canRepublishProducts: true,
    createdAt: DateTime.now().subtract(const Duration(days: 23)),
    updatedAt: DateTime.now().subtract(const Duration(days: 1)),
  );
}
