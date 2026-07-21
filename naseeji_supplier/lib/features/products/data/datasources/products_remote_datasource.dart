import '../../domain/entities/product_model.dart';
import '../../domain/entities/product_tier_price.dart';
import '../../domain/entities/product_performance_model.dart';
import '../../domain/entities/product_lifecycle_model.dart';
import '../../domain/entities/product_subscription_limit_model.dart';

abstract class ProductsRemoteDatasource {
  Future<List<ProductModel>> fetchProducts({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  });

  Future<ProductModel> fetchProductDetails(String productId);

  Future<bool> updateProductStatus(String productId, ProductStatus newStatus);

  Future<ProductModel> duplicateProduct(String productId);

  Future<ProductSubscriptionLimitModel> fetchSubscriptionLimits();
}

class ProductsRemoteDatasourceImpl implements ProductsRemoteDatasource {
  final List<ProductModel> _mockProducts = [
    ProductModel(
      id: 'prod-101',
      name: 'خيوط غزل القطن الفاخر الممشط 30/1',
      sku: 'COT-YRN-301',
      category: 'خيوط ونُسُج',
      subCategory: 'خيوط قطن غزل دائرية',
      startingPrice: 40.0,
      currency: 'ج.م',
      moq: 100,
      availableStock: 5000,
      status: ProductStatus.published,
      viewsCount: 1420,
      rfqCount: 18,
      savesCount: 64,
      mainImageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      additionalImages: const [
        'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
        'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
      ],
      videoUrl: 'https://example.com/videos/cotton_yarn_production.mp4',
      pdfUrls: const [
        'https://example.com/docs/yarn_specifications_sheet.pdf',
        'https://example.com/docs/iso_quality_report.pdf',
      ],
      catalogUrl: 'https://example.com/docs/cotton_yarn_catalog_2026.pdf',
      shortDescription: 'خيوط قطن مصري ممتاز ١٠٠٪ غزل دائر ممشط لمصانع التريكو والنسيج الدائري.',
      fullDescription:
          'خيوط غزل قطن مصري طويل التيلة عالي النقاء. مصنعة بأحدث تقنيات الغزل الآلي ومفحوصة معملياً لضمان أعلى مستويات المتانة والمقاومة للتقصف والانكماش. مناسبة لإنتاج ملابس القطنيات الفاخرة والمفروشات.',
      countryOfOrigin: 'جمهورية مصر العربية',
      brand: 'مصانع المحلة للغزل والنسيج',
      tieredPrices: const [
        ProductTierPrice(minQuantity: 100, pricePerUnit: 50.0, formattedLabel: '100 كجم = 50 جنيه/كجم'),
        ProductTierPrice(minQuantity: 500, pricePerUnit: 45.0, formattedLabel: '500 كجم = 45 جنيه/كجم'),
        ProductTierPrice(minQuantity: 1000, pricePerUnit: 40.0, formattedLabel: '1000 كجم = 40 جنيه/كجم'),
      ],
      minPrice: 40.0,
      maxPrice: 50.0,
      discountText: 'خصم الجملة 20% عند طلب 1000 كجم فأكثر',
      dailyCapacity: '5,000 كجم / يوم',
      monthlyCapacity: '150,000 كجم / شهر',
      manufacturingLeadTime: '٧ أيام عمل',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const [
        'شهادة الجودة العالمية ISO 9001:2015',
        'شهادة السلامة البيئية OEKO-TEX Standard 100',
        'شهادة الاعتماد المصرية لسلامة المنسوجات',
      ],
      labTestReports: const [
        'تقرير اختبار قوة الشد ومقاومة التمزق والمعايرة (Uster Tester 5)',
      ],
      packagingMethod: 'رولات مغلفة بيلستر عالي الكثافة كرتون سميك مقاوم للرطوبة والعوامل الجوية',
      cartonWeightKg: 25.0,
      unitsPerBox: 12,
      pickupLocation: 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى - المحلة',
      performance: const ProductPerformanceModel(
        views: 1420,
        saves: 64,
        catalogDownloads: 38,
        videoViews: 125,
        rfqRequests: 18,
        completedOrders: 12,
        totalRevenue: 284000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 7, // بدأ التصنيع
        steps: [
          ProductLifecycleStep(stepIndex: 0, title: 'تم نشر المنتج', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 1, title: 'ظهر في نتائج البحث', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 2, title: 'شاهده 120 مصنع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 3, title: 'تم حفظه لدى 35 مصنع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 4, title: 'استلم 8 طلبات RFQ', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 5, title: 'تم التفاوض', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 6, title: 'تم اعتماد العرض', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 7, title: 'بدأ التصنيع', isCompleted: true, isCurrent: true),
          ProductLifecycleStep(stepIndex: 8, title: 'جاهز للاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 9, title: 'استلمت شركة الشحن الطلب', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 10, title: 'أكد المصنع الاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 11, title: 'تم تحويل المستحقات', isCompleted: false, isCurrent: false),
        ],
      ),
      createdAt: DateTime(2026, 1, 10),
    ),
    ProductModel(
      id: 'prod-102',
      name: 'قماش قطني طبيعي 100% عرض 180 سم',
      sku: 'COT-FAB-180',
      category: 'أقمشة ملابس',
      subCategory: 'أقمشة سادة قطن تريكو',
      startingPrice: 75.0,
      currency: 'ج.م',
      moq: 200,
      availableStock: 3500,
      status: ProductStatus.published,
      viewsCount: 2890,
      rfqCount: 32,
      savesCount: 112,
      mainImageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80',
      additionalImages: const [
        'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=400&q=80',
      ],
      videoUrl: null,
      pdfUrls: const [
        'https://example.com/docs/fabric_catalog_page.pdf',
      ],
      catalogUrl: 'https://example.com/docs/fabrics_2026.pdf',
      shortDescription: 'قماش قطن مصري ممتاز مغسول ومعالج ضد الانكماش والوبر.',
      fullDescription:
          'قماش قطني فاخر بعرض ١٨٠ سم مناسب لمصانع التيشرتات والملابس الرياضية والبيتي. خامة ناعمة على البشرة عالية امتصاص الرطوبة وثبات ألوان ممتاز.',
      countryOfOrigin: 'جمهورية مصر العربية',
      brand: 'نسيج القاهرة الكبرى',
      tieredPrices: const [
        ProductTierPrice(minQuantity: 200, pricePerUnit: 85.0, formattedLabel: '200 متر = 85 جنيه/متر'),
        ProductTierPrice(minQuantity: 500, pricePerUnit: 80.0, formattedLabel: '500 متر = 80 جنيه/متر'),
        ProductTierPrice(minQuantity: 1000, pricePerUnit: 75.0, formattedLabel: '1000 متر = 75 جنيه/متر'),
      ],
      minPrice: 75.0,
      maxPrice: 85.0,
      discountText: 'تخفيض 12% للطلبيات الكبيرة',
      dailyCapacity: '3,000 متر / يوم',
      monthlyCapacity: '90,000 متر / شهر',
      manufacturingLeadTime: '٥ أيام',
      preparationTime: '١٢ ساعة',
      readyForShipmentHours: 24,
      qualityCertificates: const [
        'شهادة الجودة ISO 14001',
      ],
      labTestReports: const [
        'تقرير اختبار ثبات الألوان لغسيل 40 درجة مئوية',
      ],
      packagingMethod: 'أثواب مغلفة ببلاستيك عالي المرونة لحمايتها أثناء النقل',
      cartonWeightKg: 30.0,
      unitsPerBox: 10,
      pickupLocation: 'مخزن العاشر من رمضان - المنطقة الصناعية ٣',
      performance: const ProductPerformanceModel(
        views: 2890,
        saves: 112,
        catalogDownloads: 94,
        videoViews: 0,
        rfqRequests: 32,
        completedOrders: 24,
        totalRevenue: 480000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 11, // تم تحويل المستحقات
        steps: [
          ProductLifecycleStep(stepIndex: 0, title: 'تم نشر المنتج', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 1, title: 'ظهر في نتائج البحث', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 2, title: 'شاهده 120 مصنع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 3, title: 'تم حفظه لدى 35 مصنع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 4, title: 'استلم 8 طلبات RFQ', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 5, title: 'تم التفاوض', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 6, title: 'تم اعتماد العرض', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 7, title: 'بدأ التصنيع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 8, title: 'جاهز للاستلام', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 9, title: 'استلمت شركة الشحن الطلب', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 10, title: 'أكد المصنع الاستلام', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 11, title: 'تم تحويل المستحقات', isCompleted: true, isCurrent: true),
        ],
      ),
      createdAt: DateTime(2026, 2, 1),
    ),
    ProductModel(
      id: 'prod-103',
      name: 'نسيج صوف مخلوط مميز للبدل والأطقم',
      sku: 'WOL-MIX-003',
      category: 'أقمشة راقية',
      subCategory: 'أقمشة صوف مخلوط',
      startingPrice: 160.0,
      currency: 'ج.م',
      moq: 50,
      availableStock: 800,
      status: ProductStatus.hidden,
      viewsCount: 820,
      rfqCount: 6,
      savesCount: 22,
      mainImageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=400&q=80',
      additionalImages: const [],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'قماش صوف مخلوط ثقيل شتوي راقي للبدل والجاكت الرجالي والحريمي.',
      fullDescription: 'صوف أسترالي مخلوط ببوليستر عالي الجودة لإعطاء مرونة ومظهر أنيق وتجاعيد منخفضة.',
      countryOfOrigin: 'جمهورية مصر العربية',
      brand: 'نسيج الشرقية المعاصر',
      tieredPrices: const [
        ProductTierPrice(minQuantity: 50, pricePerUnit: 180.0, formattedLabel: '50 متر = 180 جنيه/متر'),
        ProductTierPrice(minQuantity: 200, pricePerUnit: 160.0, formattedLabel: '200 متر = 160 جنيه/متر'),
      ],
      minPrice: 160.0,
      maxPrice: 180.0,
      discountText: null,
      dailyCapacity: '1,000 متر / يوم',
      monthlyCapacity: '30,000 متر / شهر',
      manufacturingLeadTime: '١٠ أيام',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const ['شهادة ISO 9001'],
      labTestReports: const [],
      packagingMethod: 'كراتين حماية من الخدش والأتربة',
      cartonWeightKg: 20.0,
      unitsPerBox: 5,
      pickupLocation: 'مخزن مدينة شبرا الخيمة الصناعية',
      performance: const ProductPerformanceModel(
        views: 820,
        saves: 22,
        catalogDownloads: 12,
        videoViews: 0,
        rfqRequests: 6,
        completedOrders: 4,
        totalRevenue: 96000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 3,
        steps: [
          ProductLifecycleStep(stepIndex: 0, title: 'تم نشر المنتج', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 1, title: 'ظهر في نتائج البحث', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 2, title: 'شاهده 120 مصنع', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 3, title: 'تم حفظه لدى 35 مصنع', isCompleted: true, isCurrent: true),
          ProductLifecycleStep(stepIndex: 4, title: 'استلم 8 طلبات RFQ', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 5, title: 'تم التفاوض', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 6, title: 'تم اعتماد العرض', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 7, title: 'بدأ التصنيع', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 8, title: 'جاهز للاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 9, title: 'استلمت شركة الشحن الطلب', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 10, title: 'أكد المصنع الاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 11, title: 'تم تحويل المستحقات', isCompleted: false, isCurrent: false),
        ],
      ),
      createdAt: DateTime(2026, 2, 15),
    ),
    ProductModel(
      id: 'prod-104',
      name: 'خيوط بوليستر عالية المتانة 150D',
      sku: 'PLY-YRN-150',
      category: 'خيوط ونُسُج',
      subCategory: 'خيوط بوليستر سداء',
      startingPrice: 28.0,
      currency: 'ج.م',
      moq: 500,
      availableStock: 0,
      status: ProductStatus.outOfStock,
      viewsCount: 650,
      rfqCount: 2,
      savesCount: 15,
      mainImageUrl: 'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
      additionalImages: const [],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'خيوط بوليستر معالجة حرارياً عالية المقاومة للتآكل والقطع.',
      fullDescription: 'مناسبة لخياطة وتصنيع المنسوجات الثقيلة والحقائب والأثاث وأشرطة الأمان.',
      countryOfOrigin: 'جمهورية مصر العربية',
      brand: 'شركة خيوط النيل',
      tieredPrices: const [
        ProductTierPrice(minQuantity: 500, pricePerUnit: 28.0, formattedLabel: '500 كجم = 28 جنيه/كجم'),
      ],
      minPrice: 28.0,
      maxPrice: 28.0,
      discountText: null,
      dailyCapacity: '4,000 كجم / يوم',
      monthlyCapacity: '120,000 كجم / شهر',
      manufacturingLeadTime: '٤ أيام',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const ['شهادة ISO 9001'],
      labTestReports: const [],
      packagingMethod: 'كراتين مقواة برولات محفوفة سداسية',
      cartonWeightKg: 20.0,
      unitsPerBox: 16,
      pickupLocation: 'مخزن مدينة 6 أكتوبر الصناعية',
      performance: const ProductPerformanceModel(
        views: 650,
        saves: 15,
        catalogDownloads: 4,
        videoViews: 0,
        rfqRequests: 2,
        completedOrders: 2,
        totalRevenue: 28000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 1,
        steps: [
          ProductLifecycleStep(stepIndex: 0, title: 'تم نشر المنتج', isCompleted: true, isCurrent: false),
          ProductLifecycleStep(stepIndex: 1, title: 'ظهر في نتائج البحث', isCompleted: true, isCurrent: true),
          ProductLifecycleStep(stepIndex: 2, title: 'شاهده 120 مصنع', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 3, title: 'تم حفظه لدى 35 مصنع', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 4, title: 'استلم 8 طلبات RFQ', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 5, title: 'تم التفاوض', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 6, title: 'تم اعتماد العرض', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 7, title: 'بدأ التصنيع', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 8, title: 'جاهز للاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 9, title: 'استلمت شركة الشحن الطلب', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 10, title: 'أكد المصنع الاستلام', isCompleted: false, isCurrent: false),
          ProductLifecycleStep(stepIndex: 11, title: 'تم تحويل المستحقات', isCompleted: false, isCurrent: false),
        ],
      ),
      createdAt: DateTime(2026, 2, 20),
    ),
  ];

  @override
  Future<List<ProductModel>> fetchProducts({
    String? statusFilter,
    String? categoryFilter,
    String? searchQuery,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = List<ProductModel>.from(_mockProducts);

    if (statusFilter != null && statusFilter != 'الكل') {
      result = result.where((p) => p.statusArabicLabel == statusFilter).toList();
    }

    if (categoryFilter != null && categoryFilter != 'الكل') {
      result = result.where((p) => p.category == categoryFilter).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      result = result.where((p) => p.name.toLowerCase().contains(q) || p.sku.toLowerCase().contains(q)).toList();
    }

    return result;
  }

  @override
  Future<ProductModel> fetchProductDetails(String productId) async {
    await Future.delayed(const Duration(milliseconds: 250));
    return _mockProducts.firstWhere(
      (p) => p.id == productId,
      orElse: () => _mockProducts.first,
    );
  }

  @override
  Future<bool> updateProductStatus(String productId, ProductStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockProducts.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _mockProducts[index] = _mockProducts[index].copyWith(status: newStatus);
      return true;
    }
    return false;
  }

  @override
  Future<ProductModel> duplicateProduct(String productId) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final original = await fetchProductDetails(productId);
    final duplicated = original.copyWith(
      status: ProductStatus.draft,
    );
    _mockProducts.add(duplicated);
    return duplicated;
  }

  @override
  Future<ProductSubscriptionLimitModel> fetchSubscriptionLimits() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ProductSubscriptionLimitModel(
      currentPlan: 'Professional (احترافي)',
      maxProducts: 100,
      usedProducts: 58,
      remainingProducts: 42,
      maxImagesPerProduct: 10,
      usedImages: 8,
      remainingImages: 2,
      maxVideosPerProduct: 1,
      usedVideos: 1,
      remainingVideos: 0,
      maxPdfsPerProduct: 2,
      usedPdfs: 1,
      remainingPdfs: 1,
      maxRfqs: 100,
      usedRfqs: 66,
      remainingRfqs: 34,
    );
  }
}
