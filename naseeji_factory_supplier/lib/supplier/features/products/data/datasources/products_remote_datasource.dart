import '../../domain/entities/product_model.dart';
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
      name: 'قماش قطن مصري 100%',
      sku: 'COT-1001',
      category: 'أقمشة قطنية',
      subCategory: 'قطن مصري 100%',
      startingPrice: 1250.0,
      currency: 'ج.م',
      moq: 500,
      unit: 'متر',
      availableStock: 850,
      status: ProductStatus.published,
      viewsCount: 1250,
      rfqCount: 35,
      dealsCount: 12,
      savesCount: 84,
      mainImageUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=600&q=80',
      additionalImages: const [
        'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
      ],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'قماش قطن مصري فاخر 100% مناسب لأجود أنواع الملابس والمفروشات.',
      fullDescription: 'قماش قطن مصري خالص عالي المتانة ومناسب لمختلف الصناعات النسيجية.',
      countryOfOrigin: 'مصر',
      brand: 'نسيج مصر',
      tieredPrices: const [],
      minPrice: 1250.0,
      maxPrice: 1250.0,
      discountText: null,
      dailyCapacity: '5,000 متر / يوم',
      monthlyCapacity: '150,000 متر / شهر',
      manufacturingLeadTime: '٧ أيام',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const ['ISO 9001'],
      labTestReports: const [],
      packagingMethod: 'رولات محفوفة بكرتون مقوى',
      cartonWeightKg: 25.0,
      unitsPerBox: 12,
      pickupLocation: 'مخزن المحلة الكبرى',
      performance: const ProductPerformanceModel(
        views: 1250,
        pageVisits: 890,
        saves: 84,
        catalogDownloads: 38,
        videoViews: 0,
        rfqRequests: 35,
        quotesSubmitted: 25,
        completedOrders: 12,
        conversionRatePercent: 9.6,
        topKeywords: ['قطن', 'مصري', 'أقمشة'],
        lastActivityText: 'منذ ساعتين',
        totalRevenue: 284000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 7,
        steps: [],
      ),
      createdAt: DateTime(2026, 1, 10),
      updatedAt: DateTime(2026, 2, 22),
    ),
    ProductModel(
      id: 'prod-102',
      name: 'قماش بوليستر ساده',
      sku: 'POL-2002',
      category: 'أقمشة بوليستر',
      subCategory: 'بوليستر سادة',
      startingPrice: 980.0,
      currency: 'ج.م',
      moq: 300,
      unit: 'متر',
      availableStock: 620,
      status: ProductStatus.published,
      viewsCount: 980,
      rfqCount: 28,
      dealsCount: 8,
      savesCount: 65,
      mainImageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&w=600&q=80',
      additionalImages: const [],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'قماش بوليستر ناعم سادة عالي المقاومة للتجعد.',
      fullDescription: 'قماش بوليستر ممتازة الجودة ثابت الألوان ومقاوم للتآكل والانكماش.',
      countryOfOrigin: 'مصر',
      brand: 'نسيج القاهرة',
      tieredPrices: const [],
      minPrice: 980.0,
      maxPrice: 980.0,
      discountText: null,
      dailyCapacity: '3,000 متر / يوم',
      monthlyCapacity: '90,000 متر / شهر',
      manufacturingLeadTime: '٥ أيام',
      preparationTime: '١٢ ساعة',
      readyForShipmentHours: 24,
      qualityCertificates: const ['ISO 14001'],
      labTestReports: const [],
      packagingMethod: 'أثواب مغلفة ببلاستيك مقاوم للرطوبة',
      cartonWeightKg: 30.0,
      unitsPerBox: 10,
      pickupLocation: 'مخزن العاشر من رمضان',
      performance: const ProductPerformanceModel(
        views: 980,
        pageVisits: 650,
        saves: 65,
        catalogDownloads: 20,
        videoViews: 0,
        rfqRequests: 28,
        quotesSubmitted: 20,
        completedOrders: 8,
        conversionRatePercent: 8.2,
        topKeywords: ['بوليستر', 'سادة'],
        lastActivityText: 'منذ يوم',
        totalRevenue: 196000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 5,
        steps: [],
      ),
      createdAt: DateTime(2026, 2, 1),
      updatedAt: DateTime(2026, 2, 23),
    ),
    ProductModel(
      id: 'prod-103',
      name: 'قماش مخلوط (قطن - بوليستر)',
      sku: 'BLEND-3003',
      category: 'أقمشة مخلوطة',
      subCategory: 'قطن وبوليستر',
      startingPrice: 320.0,
      currency: 'ج.م',
      moq: 400,
      unit: 'متر',
      availableStock: 450,
      status: ProductStatus.draft,
      viewsCount: 320,
      rfqCount: 12,
      dealsCount: 3,
      savesCount: 22,
      mainImageUrl: 'https://images.unsplash.com/photo-1618005182384-a83a8bd57fbe?auto=format&fit=crop&w=600&q=80',
      additionalImages: const [],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'قماش مخلوط يجمع بين نعومة القطن ومتانة البوليستر.',
      fullDescription: 'خامة متينة وعملية ومناسبة لمختلف الزي الموحد والملابس الرسمية.',
      countryOfOrigin: 'مصر',
      brand: 'نسيج الدلتا',
      tieredPrices: const [],
      minPrice: 320.0,
      maxPrice: 320.0,
      discountText: null,
      dailyCapacity: '2,000 متر / يوم',
      monthlyCapacity: '60,000 متر / شهر',
      manufacturingLeadTime: '٦ أيام',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const [],
      labTestReports: const [],
      packagingMethod: 'رولات مغلفة عادية',
      cartonWeightKg: 20.0,
      unitsPerBox: 8,
      pickupLocation: 'مخزن طنطا',
      performance: const ProductPerformanceModel(
        views: 320,
        pageVisits: 200,
        saves: 22,
        catalogDownloads: 10,
        videoViews: 0,
        rfqRequests: 12,
        quotesSubmitted: 5,
        completedOrders: 3,
        conversionRatePercent: 3.7,
        topKeywords: ['مخلوط', 'قطن بوليستر'],
        lastActivityText: 'منذ ٣ أيام',
        totalRevenue: 38000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 1,
        steps: [],
      ),
      createdAt: DateTime(2026, 2, 10),
      updatedAt: DateTime(2026, 2, 20),
    ),
    ProductModel(
      id: 'prod-104',
      name: 'قماش لينن طبيعي',
      sku: 'LIN-4004',
      category: 'أقمشة لينن',
      subCategory: 'لينن طبيعي',
      startingPrice: 760.0,
      currency: 'ج.م',
      moq: 200,
      unit: 'متر',
      availableStock: 300,
      status: ProductStatus.published,
      viewsCount: 760,
      rfqCount: 22,
      dealsCount: 7,
      savesCount: 45,
      mainImageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=600&q=80',
      additionalImages: const [],
      videoUrl: null,
      pdfUrls: const [],
      catalogUrl: null,
      shortDescription: 'قماش لينن طبيعي صيفي راقي وخفيف الوزن.',
      fullDescription: 'قماش كتان ولينن طبيعي ممتاز يمنح مظهر أنيق وإحساس بارد ومريح.',
      countryOfOrigin: 'مصر',
      brand: 'نسيج الأهرام',
      tieredPrices: const [],
      minPrice: 760.0,
      maxPrice: 760.0,
      discountText: null,
      dailyCapacity: '1,500 متر / يوم',
      monthlyCapacity: '45,000 متر / شهر',
      manufacturingLeadTime: '٨ أيام',
      preparationTime: '٢٤ ساعة',
      readyForShipmentHours: 48,
      qualityCertificates: const ['OEKO-TEX'],
      labTestReports: const [],
      packagingMethod: 'أثواب مغلفة فاخرة',
      cartonWeightKg: 18.0,
      unitsPerBox: 6,
      pickupLocation: 'مخزن 6 أكتوبر',
      performance: const ProductPerformanceModel(
        views: 760,
        pageVisits: 480,
        saves: 45,
        catalogDownloads: 15,
        videoViews: 0,
        rfqRequests: 22,
        quotesSubmitted: 14,
        completedOrders: 7,
        conversionRatePercent: 9.2,
        topKeywords: ['لينن', 'كتان'],
        lastActivityText: 'منذ ٤ ساعات',
        totalRevenue: 152000.0,
      ),
      lifecycle: const ProductLifecycleModel(
        currentStepIndex: 4,
        steps: [],
      ),
      createdAt: DateTime(2026, 2, 12),
      updatedAt: DateTime(2026, 2, 24),
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
      _mockProducts[index] = _mockProducts[index].copyWith(status: newStatus, updatedAt: DateTime.now());
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
      updatedAt: DateTime.now(),
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


