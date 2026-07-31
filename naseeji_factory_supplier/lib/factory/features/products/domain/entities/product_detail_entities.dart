import 'package:flutter/foundation.dart';

/// Bulk quantity pricing tier from a supplier.
@immutable
class BulkPricingTier {
  final int minQty;
  final int maxQty; // 0 means "and above"
  final double pricePerUnit;
  final double discountPercent;

  const BulkPricingTier({
    required this.minQty,
    required this.maxQty,
    required this.pricePerUnit,
    required this.discountPercent,
  });

  BulkPricingTier copyWith({
    int? minQty,
    int? maxQty,
    double? pricePerUnit,
    double? discountPercent,
  }) {
    return BulkPricingTier(
      minQty: minQty ?? this.minQty,
      maxQty: maxQty ?? this.maxQty,
      pricePerUnit: pricePerUnit ?? this.pricePerUnit,
      discountPercent: discountPercent ?? this.discountPercent,
    );
  }
}

/// Supplier production capacity metrics.
@immutable
class ProductionCapacity {
  final int dailyCapacity;
  final int monthlyCapacity;
  final String unit;
  final double currentUtilization; // 0.0 – 1.0

  const ProductionCapacity({
    required this.dailyCapacity,
    required this.monthlyCapacity,
    required this.unit,
    required this.currentUtilization,
  });

  ProductionCapacity copyWith({
    int? dailyCapacity,
    int? monthlyCapacity,
    String? unit,
    double? currentUtilization,
  }) {
    return ProductionCapacity(
      dailyCapacity: dailyCapacity ?? this.dailyCapacity,
      monthlyCapacity: monthlyCapacity ?? this.monthlyCapacity,
      unit: unit ?? this.unit,
      currentUtilization: currentUtilization ?? this.currentUtilization,
    );
  }
}

/// Naseeji Logistics delivery information.
/// Business rule: carrier is ALWAYS "ناصيجي لوجستيك". SLA is ALWAYS 48 hours.
@immutable
class LogisticsInfo {
  final String carrier; // Always "ناصيجي لوجستيك"
  final int slaHours; // Always 48
  final List<String> coverageZones;
  final double freeShippingThreshold;

  const LogisticsInfo({
    required this.carrier,
    required this.slaHours,
    required this.coverageZones,
    required this.freeShippingThreshold,
  });

  LogisticsInfo copyWith({
    String? carrier,
    int? slaHours,
    List<String>? coverageZones,
    double? freeShippingThreshold,
  }) {
    return LogisticsInfo(
      carrier: carrier ?? this.carrier,
      slaHours: slaHours ?? this.slaHours,
      coverageZones: coverageZones ?? this.coverageZones,
      freeShippingThreshold: freeShippingThreshold ?? this.freeShippingThreshold,
    );
  }
}

/// A single downloadable document item (PDF, certificate, lab report).
@immutable
class DocumentItem {
  final String id;
  final String title;
  final String type; // 'pdf' | 'certificate' | 'lab_report'
  final int fileSizeKb;
  final bool isDownloadable;

  const DocumentItem({
    required this.id,
    required this.title,
    required this.type,
    required this.fileSizeKb,
    required this.isDownloadable,
  });

  DocumentItem copyWith({
    String? id,
    String? title,
    String? type,
    int? fileSizeKb,
    bool? isDownloadable,
  }) {
    return DocumentItem(
      id: id ?? this.id,
      title: title ?? this.title,
      type: type ?? this.type,
      fileSizeKb: fileSizeKb ?? this.fileSizeKb,
      isDownloadable: isDownloadable ?? this.isDownloadable,
    );
  }
}

/// Physical sample ordering information.
@immutable
class SampleInfo {
  final bool isAvailable;
  final double pricePerSample;
  final int sampleDeliveryDays;
  final bool requiresDeposit;

  const SampleInfo({
    required this.isAvailable,
    required this.pricePerSample,
    required this.sampleDeliveryDays,
    required this.requiresDeposit,
  });

  SampleInfo copyWith({
    bool? isAvailable,
    double? pricePerSample,
    int? sampleDeliveryDays,
    bool? requiresDeposit,
  }) {
    return SampleInfo(
      isAvailable: isAvailable ?? this.isAvailable,
      pricePerSample: pricePerSample ?? this.pricePerSample,
      sampleDeliveryDays: sampleDeliveryDays ?? this.sampleDeliveryDays,
      requiresDeposit: requiresDeposit ?? this.requiresDeposit,
    );
  }
}

/// A single B2B factory review for a product.
@immutable
class ProductReview {
  final String id;
  final String reviewerName;
  final String factoryName;
  final double rating;
  final String comment;
  final String date;
  final bool verifiedPurchase;

  const ProductReview({
    required this.id,
    required this.reviewerName,
    required this.factoryName,
    required this.rating,
    required this.comment,
    required this.date,
    required this.verifiedPurchase,
  });

  ProductReview copyWith({
    String? id,
    String? reviewerName,
    String? factoryName,
    double? rating,
    String? comment,
    String? date,
    bool? verifiedPurchase,
  }) {
    return ProductReview(
      id: id ?? this.id,
      reviewerName: reviewerName ?? this.reviewerName,
      factoryName: factoryName ?? this.factoryName,
      rating: rating ?? this.rating,
      comment: comment ?? this.comment,
      date: date ?? this.date,
      verifiedPurchase: verifiedPurchase ?? this.verifiedPurchase,
    );
  }
}

/// A single step in the 24-step procurement timeline.
@immutable
class ProcurementStage {
  final int step; // 1..24
  final String label;
  final String description;
  final String status; // 'completed' | 'active' | 'pending'
  final String? completedAt;

  const ProcurementStage({
    required this.step,
    required this.label,
    required this.description,
    required this.status,
    this.completedAt,
  });

  bool get isCompleted => status == 'completed';
  bool get isActive => status == 'active';
  bool get isPending => status == 'pending';

  ProcurementStage copyWith({
    int? step,
    String? label,
    String? description,
    String? status,
    String? completedAt,
  }) {
    return ProcurementStage(
      step: step ?? this.step,
      label: label ?? this.label,
      description: description ?? this.description,
      status: status ?? this.status,
      completedAt: completedAt ?? this.completedAt,
    );
  }
}


