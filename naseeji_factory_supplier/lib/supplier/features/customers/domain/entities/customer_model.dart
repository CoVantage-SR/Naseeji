// ─── Customer Status ─────────────────────────────────────────────────────────
enum CustomerStatus {
  active,    // نشط
  vip,       // VIP
  newCustomer, // جديد
  inactive,  // غير نشط
  blocked,   // محظور
}

// ─── Customer Tag ─────────────────────────────────────────────────────────────
class CustomerTag {
  final String id;
  final String label;
  final int colorValue;

  const CustomerTag({
    required this.id,
    required this.label,
    required this.colorValue,
  });

  CustomerTag copyWith({String? id, String? label, int? colorValue}) =>
      CustomerTag(id: id ?? this.id, label: label ?? this.label, colorValue: colorValue ?? this.colorValue);
}

// ─── Customer Rating (Private — supplier eyes only) ──────────────────────────
class CustomerRating {
  final double paymentReliability;  // الموثوقية في الدفع
  final double communication;       // التواصل
  final double negotiation;         // التفاوض
  final double responseSpeed;       // سرعة الاستجابة
  final double orderFrequency;      // تكرار الطلبات
  final double deliveryCooperation; // التعاون في التسليم
  final double overallRelationship; // العلاقة العامة

  const CustomerRating({
    this.paymentReliability = 0,
    this.communication = 0,
    this.negotiation = 0,
    this.responseSpeed = 0,
    this.orderFrequency = 0,
    this.deliveryCooperation = 0,
    this.overallRelationship = 0,
  });

  double get average => (paymentReliability + communication + negotiation +
      responseSpeed + orderFrequency + deliveryCooperation + overallRelationship) / 7;

  CustomerRating copyWith({
    double? paymentReliability,
    double? communication,
    double? negotiation,
    double? responseSpeed,
    double? orderFrequency,
    double? deliveryCooperation,
    double? overallRelationship,
  }) =>
      CustomerRating(
        paymentReliability: paymentReliability ?? this.paymentReliability,
        communication: communication ?? this.communication,
        negotiation: negotiation ?? this.negotiation,
        responseSpeed: responseSpeed ?? this.responseSpeed,
        orderFrequency: orderFrequency ?? this.orderFrequency,
        deliveryCooperation: deliveryCooperation ?? this.deliveryCooperation,
        overallRelationship: overallRelationship ?? this.overallRelationship,
      );
}

// ─── Customer Note ────────────────────────────────────────────────────────────
class CustomerNote {
  final String id;
  final String title;
  final String description;
  final String priority; // 'high' | 'medium' | 'low'
  final bool isPinned;
  final String createdDate;
  final String updatedDate;
  final List<String> attachments;

  const CustomerNote({
    required this.id,
    required this.title,
    required this.description,
    this.priority = 'medium',
    this.isPinned = false,
    required this.createdDate,
    required this.updatedDate,
    this.attachments = const [],
  });

  CustomerNote copyWith({
    String? id,
    String? title,
    String? description,
    String? priority,
    bool? isPinned,
    String? createdDate,
    String? updatedDate,
    List<String>? attachments,
  }) =>
      CustomerNote(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        priority: priority ?? this.priority,
        isPinned: isPinned ?? this.isPinned,
        createdDate: createdDate ?? this.createdDate,
        updatedDate: updatedDate ?? this.updatedDate,
        attachments: attachments ?? this.attachments,
      );
}

// ─── Customer Order Summary ───────────────────────────────────────────────────
class CustomerOrder {
  final String orderNumber;
  final String productName;
  final double quantity;
  final double totalPrice;
  final String currency;
  final String status;
  final String deliveryDate;
  final String paymentStatus;
  final String shipmentStatus;

  const CustomerOrder({
    required this.orderNumber,
    required this.productName,
    required this.quantity,
    required this.totalPrice,
    required this.currency,
    required this.status,
    required this.deliveryDate,
    required this.paymentStatus,
    required this.shipmentStatus,
  });
}

// ─── Customer Quotation Summary ───────────────────────────────────────────────
class CustomerQuotation {
  final String quotationNumber;
  final String date;
  final String productName;
  final double quantity;
  final double unitPrice;
  final String currency;
  final String status;

  const CustomerQuotation({
    required this.quotationNumber,
    required this.date,
    required this.productName,
    required this.quantity,
    required this.unitPrice,
    required this.currency,
    required this.status,
  });
}

// ─── Customer Agreement Summary ───────────────────────────────────────────────
class CustomerAgreement {
  final String agreementNumber;
  final String agreementDate;
  final String status;
  final double grandTotal;
  final String currency;
  final String paymentMethod;
  final String deliveryDate;

  const CustomerAgreement({
    required this.agreementNumber,
    required this.agreementDate,
    required this.status,
    required this.grandTotal,
    required this.currency,
    required this.paymentMethod,
    required this.deliveryDate,
  });
}

// ─── Customer Payment Record ──────────────────────────────────────────────────
class CustomerPayment {
  final String invoiceNumber;
  final double amount;
  final String currency;
  final String paymentMethod;
  final String paymentDate;
  final String paymentStatus;
  final double outstandingBalance;
  final bool isLate;
  final String settlementTime;

  const CustomerPayment({
    required this.invoiceNumber,
    required this.amount,
    required this.currency,
    required this.paymentMethod,
    required this.paymentDate,
    required this.paymentStatus,
    required this.outstandingBalance,
    required this.isLate,
    required this.settlementTime,
  });
}

// ─── Customer Shipment Record ─────────────────────────────────────────────────
class CustomerShipment {
  final String shipmentNumber;
  final String shippingCompany;
  final String trackingNumber;
  final String status;
  final String estimatedDelivery;
  final String? deliveredDate;

  const CustomerShipment({
    required this.shipmentNumber,
    required this.shippingCompany,
    required this.trackingNumber,
    required this.status,
    required this.estimatedDelivery,
    this.deliveredDate,
  });
}

// ─── Customer Document ────────────────────────────────────────────────────────
class CustomerDocument {
  final String name;
  final String type; // 'contract' | 'invoice' | 'quotation' | 'certificate' | 'shipping' | 'tax' | 'other'
  final String uploadedAt;
  final String url;

  const CustomerDocument({
    required this.name,
    required this.type,
    required this.uploadedAt,
    required this.url,
  });
}

// ─── Customer Timeline Event ──────────────────────────────────────────────────
class CustomerTimelineEvent {
  final String id;
  final String title;
  final String date;
  final String time;
  final String responsibleUser;
  final String category; // 'order' | 'quotation' | 'agreement' | 'payment' | 'shipment' | 'general'
  final String notes;
  final List<String> attachments;

  const CustomerTimelineEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.responsibleUser,
    required this.category,
    this.notes = '',
    this.attachments = const [],
  });
}

// ─── Monthly Revenue ─────────────────────────────────────────────────────────
class MonthlyRevenue {
  final String month;
  final double amount;

  const MonthlyRevenue({required this.month, required this.amount});
}

// ─── Customer Model ───────────────────────────────────────────────────────────
class CustomerModel {
  final String id;
  final String logoText;
  final int logoBgColorValue;
  final String factoryName;
  final String contactPerson;
  final String phone;
  final String email;
  final String website;
  final String country;
  final String city;
  final String address;
  final String businessCategory;
  final String industry;
  final String companyDescription;
  final bool isVerified;
  final CustomerStatus status;
  final double rating;

  // Business Statistics
  final int totalOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int pendingOrders;
  final int totalQuotations;
  final int acceptedQuotations;
  final int rejectedQuotations;
  final double negotiationSuccessRate;
  final int totalAgreements;
  final double totalRevenue;
  final double averageOrderValue;
  final double averagePaymentTime; // days
  final String lastPurchaseDate;
  final String relationshipSince;

  // Current Business Status
  final int activeOrdersCount;
  final int pendingQuotationsCount;
  final int pendingAgreementsCount;
  final int currentShipmentCount;
  final int pendingPaymentsCount;
  final int supportTicketsCount;

  // Tags
  final List<CustomerTag> tags;

  // Private Rating
  final CustomerRating privateRating;

  // Lists
  final List<CustomerNote> notes;
  final List<CustomerOrder> orders;
  final List<CustomerQuotation> quotations;
  final List<CustomerAgreement> agreements;
  final List<CustomerPayment> payments;
  final List<CustomerShipment> shipments;
  final List<CustomerDocument> documents;
  final List<CustomerTimelineEvent> timeline;
  final List<MonthlyRevenue> monthlyRevenue;
  final List<String> topProducts;

  const CustomerModel({
    required this.id,
    required this.logoText,
    required this.logoBgColorValue,
    required this.factoryName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    this.website = '',
    required this.country,
    required this.city,
    this.address = '',
    required this.businessCategory,
    required this.industry,
    this.companyDescription = '',
    this.isVerified = false,
    required this.status,
    required this.rating,
    this.totalOrders = 0,
    this.completedOrders = 0,
    this.cancelledOrders = 0,
    this.pendingOrders = 0,
    this.totalQuotations = 0,
    this.acceptedQuotations = 0,
    this.rejectedQuotations = 0,
    this.negotiationSuccessRate = 0,
    this.totalAgreements = 0,
    this.totalRevenue = 0,
    this.averageOrderValue = 0,
    this.averagePaymentTime = 0,
    this.lastPurchaseDate = '',
    this.relationshipSince = '',
    this.activeOrdersCount = 0,
    this.pendingQuotationsCount = 0,
    this.pendingAgreementsCount = 0,
    this.currentShipmentCount = 0,
    this.pendingPaymentsCount = 0,
    this.supportTicketsCount = 0,
    this.tags = const [],
    this.privateRating = const CustomerRating(),
    this.notes = const [],
    this.orders = const [],
    this.quotations = const [],
    this.agreements = const [],
    this.payments = const [],
    this.shipments = const [],
    this.documents = const [],
    this.timeline = const [],
    this.monthlyRevenue = const [],
    this.topProducts = const [],
  });

  CustomerModel copyWith({
    String? id,
    String? logoText,
    int? logoBgColorValue,
    String? factoryName,
    String? contactPerson,
    String? phone,
    String? email,
    String? website,
    String? country,
    String? city,
    String? address,
    String? businessCategory,
    String? industry,
    String? companyDescription,
    bool? isVerified,
    CustomerStatus? status,
    double? rating,
    int? totalOrders,
    int? completedOrders,
    int? cancelledOrders,
    int? pendingOrders,
    int? totalQuotations,
    int? acceptedQuotations,
    int? rejectedQuotations,
    double? negotiationSuccessRate,
    int? totalAgreements,
    double? totalRevenue,
    double? averageOrderValue,
    double? averagePaymentTime,
    String? lastPurchaseDate,
    String? relationshipSince,
    int? activeOrdersCount,
    int? pendingQuotationsCount,
    int? pendingAgreementsCount,
    int? currentShipmentCount,
    int? pendingPaymentsCount,
    int? supportTicketsCount,
    List<CustomerTag>? tags,
    CustomerRating? privateRating,
    List<CustomerNote>? notes,
    List<CustomerOrder>? orders,
    List<CustomerQuotation>? quotations,
    List<CustomerAgreement>? agreements,
    List<CustomerPayment>? payments,
    List<CustomerShipment>? shipments,
    List<CustomerDocument>? documents,
    List<CustomerTimelineEvent>? timeline,
    List<MonthlyRevenue>? monthlyRevenue,
    List<String>? topProducts,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      logoText: logoText ?? this.logoText,
      logoBgColorValue: logoBgColorValue ?? this.logoBgColorValue,
      factoryName: factoryName ?? this.factoryName,
      contactPerson: contactPerson ?? this.contactPerson,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      website: website ?? this.website,
      country: country ?? this.country,
      city: city ?? this.city,
      address: address ?? this.address,
      businessCategory: businessCategory ?? this.businessCategory,
      industry: industry ?? this.industry,
      companyDescription: companyDescription ?? this.companyDescription,
      isVerified: isVerified ?? this.isVerified,
      status: status ?? this.status,
      rating: rating ?? this.rating,
      totalOrders: totalOrders ?? this.totalOrders,
      completedOrders: completedOrders ?? this.completedOrders,
      cancelledOrders: cancelledOrders ?? this.cancelledOrders,
      pendingOrders: pendingOrders ?? this.pendingOrders,
      totalQuotations: totalQuotations ?? this.totalQuotations,
      acceptedQuotations: acceptedQuotations ?? this.acceptedQuotations,
      rejectedQuotations: rejectedQuotations ?? this.rejectedQuotations,
      negotiationSuccessRate: negotiationSuccessRate ?? this.negotiationSuccessRate,
      totalAgreements: totalAgreements ?? this.totalAgreements,
      totalRevenue: totalRevenue ?? this.totalRevenue,
      averageOrderValue: averageOrderValue ?? this.averageOrderValue,
      averagePaymentTime: averagePaymentTime ?? this.averagePaymentTime,
      lastPurchaseDate: lastPurchaseDate ?? this.lastPurchaseDate,
      relationshipSince: relationshipSince ?? this.relationshipSince,
      activeOrdersCount: activeOrdersCount ?? this.activeOrdersCount,
      pendingQuotationsCount: pendingQuotationsCount ?? this.pendingQuotationsCount,
      pendingAgreementsCount: pendingAgreementsCount ?? this.pendingAgreementsCount,
      currentShipmentCount: currentShipmentCount ?? this.currentShipmentCount,
      pendingPaymentsCount: pendingPaymentsCount ?? this.pendingPaymentsCount,
      supportTicketsCount: supportTicketsCount ?? this.supportTicketsCount,
      tags: tags ?? this.tags,
      privateRating: privateRating ?? this.privateRating,
      notes: notes ?? this.notes,
      orders: orders ?? this.orders,
      quotations: quotations ?? this.quotations,
      agreements: agreements ?? this.agreements,
      payments: payments ?? this.payments,
      shipments: shipments ?? this.shipments,
      documents: documents ?? this.documents,
      timeline: timeline ?? this.timeline,
      monthlyRevenue: monthlyRevenue ?? this.monthlyRevenue,
      topProducts: topProducts ?? this.topProducts,
    );
  }
}

