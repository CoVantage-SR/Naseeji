import 'product_tier_price.dart';
import 'product_performance_model.dart';
import 'product_lifecycle_model.dart';

enum ProductStatus {
  published, // منشور
  hidden, // مخفي
  draft, // مسودة
  outOfStock, // منتهي
}

class ProductModel {
  final String id;
  final String name;
  final String sku;
  final String category;
  final String subCategory;
  final double startingPrice;
  final String currency;
  final int moq; // أقل كمية للطلب
  final int availableStock;
  final ProductStatus status;
  final int viewsCount;
  final int rfqCount;
  final int savesCount;

  // Media
  final String mainImageUrl;
  final List<String> additionalImages;
  final String? videoUrl;
  final List<String> pdfUrls;
  final String? catalogUrl;

  // Descriptions & Origin
  final String shortDescription;
  final String fullDescription;
  final String countryOfOrigin; // بلد المنشأ (e.g. مصر)
  final String brand; // العلامة التجارية

  // Tier Pricing
  final List<ProductTierPrice> tieredPrices;
  final double minPrice;
  final double maxPrice;
  final String? discountText;

  // Manufacturing & Logistics Capacity
  final String dailyCapacity; // الطاقة الإنتاجية اليومية
  final String monthlyCapacity; // الطاقة الإنتاجية الشهرية
  final String manufacturingLeadTime; // مدة التصنيع
  final String preparationTime; // مدة التجهيز
  final int readyForShipmentHours; // جاهز للشحن خلال X ساعة/يوم

  // Quality & Compliance
  final List<String> qualityCertificates; // شهادات الجودة و ISO
  final List<String> labTestReports;

  // Packaging & Pickup
  final String packagingMethod; // طريقة التغليف
  final double cartonWeightKg; // وزن الكرتونة/الرول
  final int unitsPerBox; // عدد الوحدات بالعبوة
  final String pickupLocation; // مكان الاستلام بالمصنع

  // Performance & Lifecycle
  final ProductPerformanceModel performance;
  final ProductLifecycleModel lifecycle;
  final DateTime createdAt;

  const ProductModel({
    required this.id,
    required this.name,
    required this.sku,
    required this.category,
    required this.subCategory,
    required this.startingPrice,
    this.currency = 'ج.م',
    required this.moq,
    required this.availableStock,
    required this.status,
    required this.viewsCount,
    required this.rfqCount,
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
  });

  String get statusArabicLabel {
    switch (status) {
      case ProductStatus.published:
        return 'منشور';
      case ProductStatus.hidden:
        return 'مخفي';
      case ProductStatus.draft:
        return 'مسودة';
      case ProductStatus.outOfStock:
        return 'منتهي';
    }
  }

  ProductModel copyWith({
    ProductStatus? status,
    int? availableStock,
  }) {
    return ProductModel(
      id: id,
      name: name,
      sku: sku,
      category: category,
      subCategory: subCategory,
      startingPrice: startingPrice,
      currency: currency,
      moq: moq,
      availableStock: availableStock ?? this.availableStock,
      status: status ?? this.status,
      viewsCount: viewsCount,
      rfqCount: rfqCount,
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
    );
  }
}
