import 'package:flutter/material.dart';

enum DealStatus {
  newDeal,               // صفقة جديدة
  waitingSupplierReview, // بانتظار مراجعة المورد
  quotationSent,         // تم إرسال عرض السعر
  negotiation,           // قيد التفاوض
  agreementPending,     // بانتظار توقيع الاتفاق
  signed,                // موقع ومعتمد
  production,            // قيد الإنتاج والتصنيع
  readyForDelivery,      // جاهز للتسليم
  delivering,            // قيد التسليم
  qualityInspection,     // فحص الجودة
  paymentPending,        // بانتظار تحويل المستحقات
  completed,             // مكتمل ومغلق
  cancelled,             // ملغي
  dispute;               // نزاع معلق

  String get arabicLabel => titleAr;

  String get titleAr {
    switch (this) {
      case DealStatus.newDeal:
        return 'صفقة جديدة';
      case DealStatus.waitingSupplierReview:
        return 'بانتظار مراجعتك';
      case DealStatus.quotationSent:
        return 'تم إرسال العرض';
      case DealStatus.negotiation:
        return 'قيد التفاوض';
      case DealStatus.agreementPending:
        return 'بانتظار التوقيع';
      case DealStatus.signed:
        return 'موقع ومعتمد';
      case DealStatus.production:
        return 'قيد الإنتاج';
      case DealStatus.readyForDelivery:
        return 'جاهز للتسليم';
      case DealStatus.delivering:
        return 'قيد التسليم';
      case DealStatus.qualityInspection:
        return 'فحص الجودة';
      case DealStatus.paymentPending:
        return 'بانتظار الدفع';
      case DealStatus.completed:
        return 'مكتملة ومغلقة';
      case DealStatus.cancelled:
        return 'ملغاة';
      case DealStatus.dispute:
        return 'نزاع معلق';
    }
  }
}

extension DealStatusExtension on DealStatus {
  Color getColor(ColorScheme scheme) {
    switch (this) {
      case DealStatus.newDeal:
        return scheme.primary;
      case DealStatus.waitingSupplierReview:
        return const Color(0xFFF59E0B); // Amber
      case DealStatus.quotationSent:
        return const Color(0xFF3B82F6); // Blue
      case DealStatus.negotiation:
        return const Color(0xFF8B5CF6); // Purple
      case DealStatus.agreementPending:
        return const Color(0xFFEC4899); // Pink
      case DealStatus.signed:
        return const Color(0xFF10B981); // Emerald
      case DealStatus.production:
        return const Color(0xFF06B6D4); // Cyan
      case DealStatus.readyForDelivery:
        return const Color(0xFF14B8A6); // Teal
      case DealStatus.delivering:
        return const Color(0xFF6366F1); // Indigo
      case DealStatus.qualityInspection:
        return const Color(0xFFEAB308); // Yellow
      case DealStatus.paymentPending:
        return const Color(0xFF84CC16); // Lime
      case DealStatus.completed:
        return const Color(0xFF16A34A); // Green
      case DealStatus.cancelled:
        return const Color(0xFFEF4444); // Red
      case DealStatus.dispute:
        return const Color(0xFFDC2626); // Dark Red
    }
  }

  IconData get icon {
    switch (this) {
      case DealStatus.newDeal:
        return Icons.fiber_new_rounded;
      case DealStatus.waitingSupplierReview:
        return Icons.rate_review_outlined;
      case DealStatus.quotationSent:
        return Icons.send_rounded;
      case DealStatus.negotiation:
        return Icons.handshake_outlined;
      case DealStatus.agreementPending:
        return Icons.history_edu_rounded;
      case DealStatus.signed:
        return Icons.verified_outlined;
      case DealStatus.production:
        return Icons.precision_manufacturing_outlined;
      case DealStatus.readyForDelivery:
        return Icons.inventory_2_outlined;
      case DealStatus.delivering:
        return Icons.local_shipping_outlined;
      case DealStatus.qualityInspection:
        return Icons.fact_check_outlined;
      case DealStatus.paymentPending:
        return Icons.account_balance_wallet_outlined;
      case DealStatus.completed:
        return Icons.check_circle_outline;
      case DealStatus.cancelled:
        return Icons.cancel_outlined;
      case DealStatus.dispute:
        return Icons.gavel_outlined;
    }
  }

  bool get requiresSupplierAction {
    return this == DealStatus.newDeal ||
        this == DealStatus.waitingSupplierReview ||
        this == DealStatus.negotiation ||
        this == DealStatus.agreementPending ||
        this == DealStatus.signed ||
        this == DealStatus.readyForDelivery ||
        this == DealStatus.qualityInspection;
  }
}

enum DeliveryMethod {
  supplierDelivery, // المورد يقوم بالتوصيل
  factoryPickup,    // المصنع يستلم من المورد
}

extension DeliveryMethodExtension on DeliveryMethod {
  String get titleAr {
    switch (this) {
      case DeliveryMethod.supplierDelivery:
        return 'المورد يقوم بالتوصيل لحساب المصنع';
      case DeliveryMethod.factoryPickup:
        return 'المصنع يستلم م المورد مباشرة بالمنشأة';
    }
  }
}

class DealPartyInfo {
  final String id;
  final String name;
  final String logoText;
  final int logoBgColorValue;
  final String city;

  const DealPartyInfo({
    required this.id,
    required this.name,
    required this.logoText,
    required this.logoBgColorValue,
    required this.city,
  });
}

class DealProductInfo {
  final String id;
  final String name;
  final String sku;
  final int quantity;
  final String unit;
  final double unitPrice;
  final String currency;
  final String imageUrl;

  const DealProductInfo({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.unit,
    required this.unitPrice,
    this.currency = 'ج.م',
    required this.imageUrl,
  });

  double get totalPrice => quantity * unitPrice;
}

class QuotationData {
  final String quoteId;
  final double unitPrice;
  final int quantity;
  final double totalPrice;
  final String currency;
  final int productionDays;
  final String paymentTerms;
  final DateTime validUntil;
  final String? notes;

  const QuotationData({
    required this.quoteId,
    required this.unitPrice,
    required this.quantity,
    required this.totalPrice,
    this.currency = 'ج.م',
    required this.productionDays,
    required this.paymentTerms,
    required this.validUntil,
    this.notes,
  });
}

class NegotiationData {
  final double proposedUnitPrice;
  final int proposedQuantity;
  final int proposedProductionDays;
  final String proposedPaymentTerms;
  final String proposedDeliveryDate;
  final String statusText;
  final bool isSupplierTurn;

  const NegotiationData({
    required this.proposedUnitPrice,
    required this.proposedQuantity,
    required this.proposedProductionDays,
    required this.proposedPaymentTerms,
    required this.proposedDeliveryDate,
    required this.statusText,
    required this.isSupplierTurn,
  });
}

class AgreementData {
  final String agreementNumber;
  final bool supplierSigned;
  final bool factorySigned;
  final DateTime? supplierSignedAt;
  final DateTime? factorySignedAt;
  final String? agreementDocUrl;

  const AgreementData({
    required this.agreementNumber,
    required this.supplierSigned,
    required this.factorySigned,
    this.supplierSignedAt,
    this.factorySignedAt,
    this.agreementDocUrl,
  });
}

class ProductionData {
  final double progressPercent;
  final List<String> photoUrls;
  final List<String> videoUrls;
  final String? notes;
  final DateTime lastUpdatedAt;

  const ProductionData({
    required this.progressPercent,
    required this.photoUrls,
    required this.videoUrls,
    this.notes,
    required this.lastUpdatedAt,
  });
}

class DeliveryData {
  final DeliveryMethod method;
  final DateTime estimatedDeliveryDate;
  final String responsiblePersonName;
  final String responsiblePersonPhone;
  final String? notes;

  const DeliveryData({
    required this.method,
    required this.estimatedDeliveryDate,
    required this.responsiblePersonName,
    required this.responsiblePersonPhone,
    this.notes,
  });
}

class QualityData {
  final String statusText; // pending, accepted, disputed
  final bool isAccepted;
  final List<String> inspectionPhotoUrls;
  final String? notes;

  const QualityData({
    required this.statusText,
    required this.isAccepted,
    required this.inspectionPhotoUrls,
    this.notes,
  });
}

class PaymentData {
  final double totalAmount;
  final String currency;
  final String paymentStatus; // pending, inEscrow, released
  final DateTime? transferDate;

  const PaymentData({
    required this.totalAmount,
    this.currency = 'ج.م',
    required this.paymentStatus,
    this.transferDate,
  });
}

class DealTimelineStep {
  final String title;
  final String description;
  final DateTime timestamp;
  final bool isCompleted;
  final bool isCurrent;

  const DealTimelineStep({
    required this.title,
    required this.description,
    required this.timestamp,
    required this.isCompleted,
    required this.isCurrent,
  });
}

class DealFileData {
  final String title;
  final String url;
  final String fileType;
  final String fileSize;

  const DealFileData({
    required this.title,
    required this.url,
    required this.fileType,
    required this.fileSize,
  });
}

class DealModel {
  final String id;
  final String dealNumber;
  final DealStatus status;
  final DealPartyInfo factoryInfo;
  final DealPartyInfo supplierInfo;
  final DealProductInfo product;
  final QuotationData? quotation;
  final NegotiationData? negotiation;
  final AgreementData? agreement;
  final ProductionData? production;
  final DeliveryData? delivery;
  final QualityData? quality;
  final PaymentData? payment;
  final List<DealTimelineStep> timeline;
  final List<DealFileData> files;
  final int daysRemaining;
  final DateTime createdAt;
  final DateTime updatedAt;

  const DealModel({
    required this.id,
    required this.dealNumber,
    required this.status,
    required this.factoryInfo,
    required this.supplierInfo,
    required this.product,
    this.quotation,
    this.negotiation,
    this.agreement,
    this.production,
    this.delivery,
    this.quality,
    this.payment,
    required this.timeline,
    required this.files,
    required this.daysRemaining,
    required this.createdAt,
    required this.updatedAt,
  });

  String get formattedLastUpdated {
    final diff = DateTime.now().difference(updatedAt);
    if (diff.inMinutes < 60) {
      return 'منذ ${diff.inMinutes} دقيقة';
    } else if (diff.inHours < 24) {
      return 'منذ ${diff.inHours} ساعة';
    } else {
      return 'منذ ${diff.inDays} يوم';
    }
  }

  DealModel copyWith({
    DealStatus? status,
    QuotationData? quotation,
    NegotiationData? negotiation,
    AgreementData? agreement,
    ProductionData? production,
    DeliveryData? delivery,
    QualityData? quality,
    PaymentData? payment,
    List<DealTimelineStep>? timeline,
    DateTime? updatedAt,
  }) {
    return DealModel(
      id: id,
      dealNumber: dealNumber,
      status: status ?? this.status,
      factoryInfo: factoryInfo,
      supplierInfo: supplierInfo,
      product: product,
      quotation: quotation ?? this.quotation,
      negotiation: negotiation ?? this.negotiation,
      agreement: agreement ?? this.agreement,
      production: production ?? this.production,
      delivery: delivery ?? this.delivery,
      quality: quality ?? this.quality,
      payment: payment ?? this.payment,
      timeline: timeline ?? this.timeline,
      files: files,
      daysRemaining: daysRemaining,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

