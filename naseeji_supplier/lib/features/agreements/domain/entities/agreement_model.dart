enum AgreementStatus {
  pendingApproval, // انتظار موافقة المورد
  active,          // سارية ونشطة
  completed,       // مكتملة ومغلقة
  cancelled,       // ملغاة
  expired,         // منتهية الصلاحية
}

class SupplierInfo {
  final String logoText;
  final int logoBgColorValue;
  final String companyName;
  final String supplierName;
  final String phone;
  final String email;
  final String address;
  final double rating;
  final bool verified;

  const SupplierInfo({
    required this.logoText,
    required this.logoBgColorValue,
    required this.companyName,
    required this.supplierName,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
    required this.verified,
  });
}

class FactoryInfo {
  final String logoText;
  final int logoBgColorValue;
  final String factoryName;
  final String contactPerson;
  final String phone;
  final String email;
  final String address;
  final double rating;

  const FactoryInfo({
    required this.logoText,
    required this.logoBgColorValue,
    required this.factoryName,
    required this.contactPerson,
    required this.phone,
    required this.email,
    required this.address,
    required this.rating,
  });
}

class AgreementProduct {
  final String imageUrl;
  final String name;
  final String sku;
  final String category;
  final String specifications;
  final String countryOfOrigin;
  final int quantity;
  final String unit;
  final String packagingDetails;

  const AgreementProduct({
    required this.imageUrl,
    required this.name,
    required this.sku,
    required this.category,
    required this.specifications,
    required this.countryOfOrigin,
    required this.quantity,
    required this.unit,
    required this.packagingDetails,
  });
}

class AgreementPricing {
  final double originalPrice;
  final double negotiatedPrice;
  final double finalPrice;
  final double discount;
  final double tax;
  final double shippingCost;
  final double extraFees;
  final double grandTotal;
  final String currency;

  const AgreementPricing({
    required this.originalPrice,
    required this.negotiatedPrice,
    required this.finalPrice,
    required this.discount,
    required this.tax,
    required this.shippingCost,
    required this.extraFees,
    required this.grandTotal,
    required this.currency,
  });
}

class AgreementPaymentTerms {
  final String method;
  final double advancePayment;
  final double remainingBalance;
  final String paymentSchedule;
  final String paymentStatus;
  final String releaseConditions;
  final String settlementTime;

  const AgreementPaymentTerms({
    required this.method,
    required this.advancePayment,
    required this.remainingBalance,
    required this.paymentSchedule,
    required this.paymentStatus,
    required this.releaseConditions,
    required this.settlementTime,
  });
}

class AgreementDeliveryTerms {
  final String preparationTime;
  final String deliveryDate;
  final String deliveryAddress;
  final String shippingCompany;
  final String shipmentMethod;
  final String trackingNumber;
  final String warehouse;

  const AgreementDeliveryTerms({
    required this.preparationTime,
    required this.deliveryDate,
    required this.deliveryAddress,
    required this.shippingCompany,
    required this.shipmentMethod,
    required this.trackingNumber,
    required this.warehouse,
  });
}

class AgreementConditions {
  final String warranty;
  final String qualityRequirements;
  final String inspectionRequirements;
  final String cancellationPolicy;
  final String penaltyClauses;
  final String additionalNotes;

  const AgreementConditions({
    required this.warranty,
    required this.qualityRequirements,
    required this.inspectionRequirements,
    required this.cancellationPolicy,
    required this.penaltyClauses,
    required this.additionalNotes,
  });
}

class AgreementTimelineStep {
  final String date;
  final String time;
  final String user;
  final List<String> attachments;
  final String status;
  final String notes;

  const AgreementTimelineStep({
    required this.date,
    required this.time,
    required this.user,
    required this.attachments,
    required this.status,
    required this.notes,
  });
}

class AgreementHistoryRecord {
  final String timestamp;
  final String user;
  final String action;
  final String reason;
  final String versionNumber;

  const AgreementHistoryRecord({
    required this.timestamp,
    required this.user,
    required this.action,
    required this.reason,
    required this.versionNumber,
  });
}

class ComparisonData {
  final String unitPrice;
  final String quantity;
  final String moq;
  final String deliveryTime;
  final String paymentMethod;
  final String shippingTerms;
  final String taxes;
  final String discount;
  final String validity;
  final String preparationTime;

  const ComparisonData({
    required this.unitPrice,
    required this.quantity,
    required this.moq,
    required this.deliveryTime,
    required this.paymentMethod,
    required this.shippingTerms,
    required this.taxes,
    required this.discount,
    required this.validity,
    required this.preparationTime,
  });
}

class AgreementDocument {
  final String name;
  final String type;
  final String url;
  final int version;
  final String uploadedAt;

  const AgreementDocument({
    required this.name,
    required this.type,
    required this.url,
    required this.version,
    required this.uploadedAt,
  });

  AgreementDocument copyWith({
    String? name,
    String? type,
    String? url,
    int? version,
    String? uploadedAt,
  }) {
    return AgreementDocument(
      name: name ?? this.name,
      type: type ?? this.type,
      url: url ?? this.url,
      version: version ?? this.version,
      uploadedAt: uploadedAt ?? this.uploadedAt,
    );
  }
}

class B2BAgreement {
  final String id;
  final String orderNumber;
  final String rfqNumber;
  final String createdDate;
  final String lastUpdated;
  final String version;
  final String type;
  final String expirationDate;
  final AgreementStatus status;
  final SupplierInfo supplierInfo;
  final FactoryInfo factoryInfo;
  final AgreementProduct product;
  final AgreementPricing pricing;
  final AgreementPaymentTerms paymentTerms;
  final AgreementDeliveryTerms deliveryTerms;
  final AgreementConditions conditions;
  final List<AgreementTimelineStep> timeline;
  final List<AgreementHistoryRecord> history;
  final List<AgreementDocument> documents;
  final ComparisonData rfqData;
  final ComparisonData firstQuoteData;
  final ComparisonData counterOfferData;
  final ComparisonData finalAgreementData;
  final double savingsAmount;
  final String savingsDifference;
  final double negotiationSuccessPercent;
  final String? cancellationReason;

  const B2BAgreement({
    required this.id,
    required this.orderNumber,
    required this.rfqNumber,
    required this.createdDate,
    required this.lastUpdated,
    required this.version,
    required this.type,
    required this.expirationDate,
    required this.status,
    required this.supplierInfo,
    required this.factoryInfo,
    required this.product,
    required this.pricing,
    required this.paymentTerms,
    required this.deliveryTerms,
    required this.conditions,
    required this.timeline,
    required this.history,
    required this.documents,
    required this.rfqData,
    required this.firstQuoteData,
    required this.counterOfferData,
    required this.finalAgreementData,
    required this.savingsAmount,
    required this.savingsDifference,
    required this.negotiationSuccessPercent,
    this.cancellationReason,
  });

  B2BAgreement copyWith({
    String? id,
    String? orderNumber,
    String? rfqNumber,
    String? createdDate,
    String? lastUpdated,
    String? version,
    String? type,
    String? expirationDate,
    AgreementStatus? status,
    SupplierInfo? supplierInfo,
    FactoryInfo? factoryInfo,
    AgreementProduct? product,
    AgreementPricing? pricing,
    AgreementPaymentTerms? paymentTerms,
    AgreementDeliveryTerms? deliveryTerms,
    AgreementConditions? conditions,
    List<AgreementTimelineStep>? timeline,
    List<AgreementHistoryRecord>? history,
    List<AgreementDocument>? documents,
    ComparisonData? rfqData,
    ComparisonData? firstQuoteData,
    ComparisonData? counterOfferData,
    ComparisonData? finalAgreementData,
    double? savingsAmount,
    String? savingsDifference,
    double? negotiationSuccessPercent,
    String? cancellationReason,
  }) {
    return B2BAgreement(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      rfqNumber: rfqNumber ?? this.rfqNumber,
      createdDate: createdDate ?? this.createdDate,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      version: version ?? this.version,
      type: type ?? this.type,
      expirationDate: expirationDate ?? this.expirationDate,
      status: status ?? this.status,
      supplierInfo: supplierInfo ?? this.supplierInfo,
      factoryInfo: factoryInfo ?? this.factoryInfo,
      product: product ?? this.product,
      pricing: pricing ?? this.pricing,
      paymentTerms: paymentTerms ?? this.paymentTerms,
      deliveryTerms: deliveryTerms ?? this.deliveryTerms,
      conditions: conditions ?? this.conditions,
      timeline: timeline ?? this.timeline,
      history: history ?? this.history,
      documents: documents ?? this.documents,
      rfqData: rfqData ?? this.rfqData,
      firstQuoteData: firstQuoteData ?? this.firstQuoteData,
      counterOfferData: counterOfferData ?? this.counterOfferData,
      finalAgreementData: finalAgreementData ?? this.finalAgreementData,
      savingsAmount: savingsAmount ?? this.savingsAmount,
      savingsDifference: savingsDifference ?? this.savingsDifference,
      negotiationSuccessPercent: negotiationSuccessPercent ?? this.negotiationSuccessPercent,
      cancellationReason: cancellationReason ?? this.cancellationReason,
    );
  }
}
