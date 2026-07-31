import '../../../agreements/domain/entities/agreement_model.dart'; // Reuse FactoryInfo

enum QuotationStatus {
  draft,
  sent,
  underNegotiation,
  accepted,
  rejected,
  expired,
}

class QuotationModel {
  final String id; // Quotation Number (e.g. QT-8820)
  final String rfqNumber;
  final String? orderNumber;
  final String version;
  final String createdDate;
  final String lastUpdated;
  final String expirationDate;
  final QuotationStatus status;
  final bool hasNegotiationBadge;
  
  // Factory Info
  final FactoryInfo factoryInfo;
  
  // Product Info
  final String productName;
  final String productSku;
  final String productCategory;
  final String productMaterial;
  final String productSpecifications;
  final String countryOfOrigin;
  final String productImageUrl;
  final double quantity;
  final String unit;
  final double moq;
  final String packagingDetails;
  
  // Pricing
  final double originalRequestedPrice;
  final double supplierUnitPrice;
  final double discount;
  final double taxes;
  final double shippingCost;
  final double additionalCharges;
  final double grandTotal;
  final String currency;
  final double expectedProfitMargin; // e.g. 25%
  
  // Payment Terms
  final String paymentMethod;
  final double advancePayment;
  final double remainingBalance;
  final String creditPeriod;
  final String settlementTime;
  final String releaseConditions;
  
  // Delivery Terms
  final String preparationTime;
  final String estimatedDelivery;
  final String deliveryLocation;
  final String shippingMethod;
  final String shippingCompany;
  final String? incoterms;

  // Rejection
  final String? rejectionReason;
  
  // History and Timeline
  final List<QuotationRevisionModel> revisions;
  final List<QuotationTimelineStep> timeline;

  const QuotationModel({
    required this.id,
    required this.rfqNumber,
    this.orderNumber,
    required this.version,
    required this.createdDate,
    required this.lastUpdated,
    required this.expirationDate,
    required this.status,
    this.hasNegotiationBadge = false,
    required this.factoryInfo,
    required this.productName,
    required this.productSku,
    required this.productCategory,
    required this.productMaterial,
    required this.productSpecifications,
    required this.countryOfOrigin,
    required this.productImageUrl,
    required this.quantity,
    required this.unit,
    required this.moq,
    required this.packagingDetails,
    required this.originalRequestedPrice,
    required this.supplierUnitPrice,
    required this.discount,
    required this.taxes,
    required this.shippingCost,
    required this.additionalCharges,
    required this.grandTotal,
    required this.currency,
    required this.expectedProfitMargin,
    required this.paymentMethod,
    required this.advancePayment,
    required this.remainingBalance,
    required this.creditPeriod,
    required this.settlementTime,
    required this.releaseConditions,
    required this.preparationTime,
    required this.estimatedDelivery,
    required this.deliveryLocation,
    required this.shippingMethod,
    required this.shippingCompany,
    this.incoterms,
    this.rejectionReason,
    this.revisions = const [],
    this.timeline = const [],
  });

  QuotationModel copyWith({
    String? id,
    String? rfqNumber,
    String? orderNumber,
    String? version,
    String? createdDate,
    String? lastUpdated,
    String? expirationDate,
    QuotationStatus? status,
    bool? hasNegotiationBadge,
    FactoryInfo? factoryInfo,
    String? productName,
    String? productSku,
    String? productCategory,
    String? productMaterial,
    String? productSpecifications,
    String? countryOfOrigin,
    String? productImageUrl,
    double? quantity,
    String? unit,
    double? moq,
    String? packagingDetails,
    double? originalRequestedPrice,
    double? supplierUnitPrice,
    double? discount,
    double? taxes,
    double? shippingCost,
    double? additionalCharges,
    double? grandTotal,
    String? currency,
    double? expectedProfitMargin,
    String? paymentMethod,
    double? advancePayment,
    double? remainingBalance,
    String? creditPeriod,
    String? settlementTime,
    String? releaseConditions,
    String? preparationTime,
    String? estimatedDelivery,
    String? deliveryLocation,
    String? shippingMethod,
    String? shippingCompany,
    String? incoterms,
    String? rejectionReason,
    List<QuotationRevisionModel>? revisions,
    List<QuotationTimelineStep>? timeline,
  }) {
    return QuotationModel(
      id: id ?? this.id,
      rfqNumber: rfqNumber ?? this.rfqNumber,
      orderNumber: orderNumber ?? this.orderNumber,
      version: version ?? this.version,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      expirationDate: expirationDate ?? this.expirationDate,
      status: status ?? this.status,
      hasNegotiationBadge: hasNegotiationBadge ?? this.hasNegotiationBadge,
      factoryInfo: factoryInfo ?? this.factoryInfo,
      productName: productName ?? this.productName,
      productSku: productSku ?? this.productSku,
      productCategory: productCategory ?? this.productCategory,
      productMaterial: productMaterial ?? this.productMaterial,
      productSpecifications: productSpecifications ?? this.productSpecifications,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      productImageUrl: productImageUrl ?? this.productImageUrl,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      moq: moq ?? this.moq,
      packagingDetails: packagingDetails ?? this.packagingDetails,
      originalRequestedPrice: originalRequestedPrice ?? this.originalRequestedPrice,
      supplierUnitPrice: supplierUnitPrice ?? this.supplierUnitPrice,
      discount: discount ?? this.discount,
      taxes: taxes ?? this.taxes,
      shippingCost: shippingCost ?? this.shippingCost,
      additionalCharges: additionalCharges ?? this.additionalCharges,
      grandTotal: grandTotal ?? this.grandTotal,
      currency: currency ?? this.currency,
      expectedProfitMargin: expectedProfitMargin ?? this.expectedProfitMargin,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      advancePayment: advancePayment ?? this.advancePayment,
      remainingBalance: remainingBalance ?? this.remainingBalance,
      creditPeriod: creditPeriod ?? this.creditPeriod,
      settlementTime: settlementTime ?? this.settlementTime,
      releaseConditions: releaseConditions ?? this.releaseConditions,
      preparationTime: preparationTime ?? this.preparationTime,
      estimatedDelivery: estimatedDelivery ?? this.estimatedDelivery,
      deliveryLocation: deliveryLocation ?? this.deliveryLocation,
      shippingMethod: shippingMethod ?? this.shippingMethod,
      shippingCompany: shippingCompany ?? this.shippingCompany,
      incoterms: incoterms ?? this.incoterms,
      rejectionReason: rejectionReason ?? this.rejectionReason,
      revisions: revisions ?? this.revisions,
      timeline: timeline ?? this.timeline,
    );
  }
}

class QuotationRevisionModel {
  final String version;
  final double supplierPrice;
  final double factoryCounterOffer;
  final double priceDifference;
  final String reason;
  final String createdDate;
  final String negotiatedBy;
  final String status;

  const QuotationRevisionModel({
    required this.version,
    required this.supplierPrice,
    required this.factoryCounterOffer,
    required this.priceDifference,
    required this.reason,
    required this.createdDate,
    required this.negotiatedBy,
    required this.status,
  });
}

class QuotationTimelineStep {
  final String title;
  final String date;
  final String time;
  final String responsibleUser;
  final String status;
  final List<String> attachments;
  final String notes;

  const QuotationTimelineStep({
    required this.title,
    required this.date,
    required this.time,
    required this.responsibleUser,
    required this.status,
    this.attachments = const [],
    this.notes = '',
  });
}

