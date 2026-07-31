import 'package:flutter/material.dart';
import 'product_tier_price.dart';
import 'product_performance_model.dart';
import 'product_lifecycle_model.dart';

enum ProductStatus {
  draft,          // مسودة
  pendingReview,  // بانتظار المراجعة
  published,      // منشور
  outOfStock,     // غير متوفر
  hidden,         // مخفي
  archived,       // مؤرشف
}

extension ProductStatusExtension on ProductStatus {
  String get titleAr {
    switch (this) {
      case ProductStatus.draft:
        return 'مسودة';
      case ProductStatus.pendingReview:
        return 'بانتظار المراجعة';
      case ProductStatus.published:
        return 'منشور';
      case ProductStatus.outOfStock:
        return 'غير متوفر';
      case ProductStatus.hidden:
        return 'مخفي';
      case ProductStatus.archived:
        return 'مؤرشف';
    }
  }

  Color get color {
    switch (this) {
      case ProductStatus.draft:
        return const Color(0xFF6B7280); // Grey
      case ProductStatus.pendingReview:
        return const Color(0xFFEAB308); // Yellow / Amber
      case ProductStatus.published:
        return const Color(0xFF16A34A); // Green
      case ProductStatus.outOfStock:
        return const Color(0xFFF97316); // Orange
      case ProductStatus.hidden:
        return const Color(0xFF9CA3AF); // Muted Grey
      case ProductStatus.archived:
        return const Color(0xFF374151); // Dark Slate Grey
    }
  }

  IconData get icon {
    switch (this) {
      case ProductStatus.draft:
        return Icons.edit_note_outlined;
      case ProductStatus.pendingReview:
        return Icons.hourglass_empty_rounded;
      case ProductStatus.published:
        return Icons.check_circle_outline;
      case ProductStatus.outOfStock:
        return Icons.remove_shopping_cart_outlined;
      case ProductStatus.hidden:
        return Icons.visibility_off_outlined;
      case ProductStatus.archived:
        return Icons.archive_outlined;
    }
  }
}

class ProductModel {
  final String id;
  final String supplierId;
  final String subscriptionId;
  final String name;
  final String sku;
  final String category;
  final String subCategory;
  final double startingPrice;
  final String currency;
  final int moq;
  final int availableStock;
  final ProductStatus status;
  final int viewsCount;
  final int rfqCount;
  final int dealsCount;
  final int savesCount;
  final String unit;

  // Media
  final String mainImageUrl;
  final List<String> additionalImages;
  final String? videoUrl;
  final List<String> pdfUrls;
  final String? catalogUrl;

  // Description
  final String shortDescription;
  final String fullDescription;
  final String countryOfOrigin;
  final String brand;

  // Tier Pricing
  final List<ProductTierPrice> tieredPrices;
  final double minPrice;
  final double maxPrice;
  final String? discountText;

  // Manufacturing & Logistics
  final String dailyCapacity;
  final String monthlyCapacity;
  final String manufacturingLeadTime;
  final String preparationTime;
  final int readyForShipmentHours;

  // Quality & Packaging
  final List<String> qualityCertificates;
  final List<String> labTestReports;
  final String packagingMethod;
  final double cartonWeightKg;
  final int unitsPerBox;
  final String pickupLocation;

  // Performance & Lifecycle
  final ProductPerformanceModel performance;
  final ProductLifecycleModel lifecycle;
  final DateTime createdAt;
  final DateTime updatedAt;

  const ProductModel({
    required this.id,
    this.supplierId = 'SUP-001',
    this.subscriptionId = 'SUB-101',
    required this.name,
    required this.sku,
    required this.category,
    required this.subCategory,
    required this.startingPrice,
    this.currency = 'ج.م',
    required this.moq,
    this.unit = 'متر',
    required this.availableStock,
    required this.status,
    required this.viewsCount,
    required this.rfqCount,
    this.dealsCount = 0,
    required this.savesCount,
    required this.mainImageUrl,
    required this.additionalImages,
    this.videoUrl,
    required this.pdfUrls,
    this.catalogUrl,
    required this.shortDescription,
    required this.fullDescription,
    required this.countryOfOrigin,
    required this.brand,
    required this.tieredPrices,
    required this.minPrice,
    required this.maxPrice,
    this.discountText,
    required this.dailyCapacity,
    required this.monthlyCapacity,
    required this.manufacturingLeadTime,
    required this.preparationTime,
    required this.readyForShipmentHours,
    required this.qualityCertificates,
    required this.labTestReports,
    required this.packagingMethod,
    required this.cartonWeightKg,
    required this.unitsPerBox,
    required this.pickupLocation,
    required this.performance,
    required this.lifecycle,
    required this.createdAt,
    required this.updatedAt,
  });

  String get statusArabicLabel => status.titleAr;

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

  ProductModel copyWith({
    String? name,
    ProductStatus? status,
    int? availableStock,
    double? startingPrice,
    DateTime? updatedAt,
    String? subscriptionId,
    String? supplierId,
    int? dealsCount,
    String? unit,
  }) {
    return ProductModel(
      id: id,
      supplierId: supplierId ?? this.supplierId,
      subscriptionId: subscriptionId ?? this.subscriptionId,
      name: name ?? this.name,
      sku: sku,
      category: category,
      subCategory: subCategory,
      startingPrice: startingPrice ?? this.startingPrice,
      currency: currency,
      moq: moq,
      unit: unit ?? this.unit,
      availableStock: availableStock ?? this.availableStock,
      status: status ?? this.status,
      viewsCount: viewsCount,
      rfqCount: rfqCount,
      dealsCount: dealsCount ?? this.dealsCount,
      savesCount: savesCount,
      mainImageUrl: mainImageUrl,
      additionalImages: additionalImages,
      videoUrl: videoUrl,
      pdfUrls: pdfUrls,
      catalogUrl: catalogUrl,
      shortDescription: shortDescription,
      fullDescription: fullDescription,
      countryOfOrigin: countryOfOrigin,
      brand: brand,
      tieredPrices: tieredPrices,
      minPrice: minPrice,
      maxPrice: maxPrice,
      discountText: discountText,
      dailyCapacity: dailyCapacity,
      monthlyCapacity: monthlyCapacity,
      manufacturingLeadTime: manufacturingLeadTime,
      preparationTime: preparationTime,
      readyForShipmentHours: readyForShipmentHours,
      qualityCertificates: qualityCertificates,
      labTestReports: labTestReports,
      packagingMethod: packagingMethod,
      cartonWeightKg: cartonWeightKg,
      unitsPerBox: unitsPerBox,
      pickupLocation: pickupLocation,
      performance: performance,
      lifecycle: lifecycle,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}



