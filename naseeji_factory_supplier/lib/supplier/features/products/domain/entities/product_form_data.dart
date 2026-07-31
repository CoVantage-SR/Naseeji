class ProductFormData {
  final int currentStep; // 1 to 8

  // Step 1: Basic Info
  final String name;
  final String category;
  final String subCategory;
  final String shortDescription;
  final String fullDescription;
  final String countryOfOrigin;
  final String brand;

  // Step 2: Technical Specifications
  final Map<String, String> technicalSpecs;

  // Step 3: Images
  final String? mainCoverImage;
  final List<String> additionalImages;
  final int usedImagesCount;
  final int maxImagesAllowed;

  // Step 4: Video
  final String? videoUrl;
  final String? videoFileName;
  final String videoDuration;
  final double videoSizeMb;
  final int usedVideosCount;
  final int maxVideosAllowed;

  // Step 5: Catalog & PDF Documents
  final List<Map<String, String>> pdfDocuments;
  final String? catalogUrl;
  final int usedPdfsCount;
  final int maxPdfsAllowed;

  // Step 6: Pricing & Wholesale Tiers
  final List<Map<String, dynamic>> tieredPrices;
  final int moq;
  final int maxQuantity;
  final String wholesaleDiscounts;
  final String priceValidityPeriod;

  // Step 7: Manufacturing & Logistics Pickup
  final int availableStock;
  final String dailyCapacity;
  final String monthlyCapacity;
  final String manufacturingLeadTime;
  final String preparationTime;
  final int readyForShipmentHours;
  final String pickupLocation;

  // Status & Draft tracking
  final bool isDraftSaved;
  final DateTime? lastSavedAt;

  const ProductFormData({
    this.currentStep = 1,
    this.name = 'خيوط غزل القطن الفاخر الممشط 30/1',
    this.category = 'خيوط ونُسُج',
    this.subCategory = 'خيوط قطن غزل دائرية',
    this.shortDescription = 'خيوط قطن مصري ممتاز ١٠٠٪ غزل دائر ممشط لمصانع التريكو.',
    this.fullDescription = 'خيوط غزل قطن مصري طويل التيلة عالي النقاء. مصنعة بأحدث تقنيات الغزل الآلي ومفحوصة معملياً لضمان أعلى مستويات المتانة.',
    this.countryOfOrigin = 'جمهورية مصر العربية',
    this.brand = 'مصانع المحلة للغزل والنسيج',
    this.technicalSpecs = const {
      'الخامة': 'قطن مصري 100%',
      'اللون': 'أبيض ناصع',
      'العرض': '180 سم',
      'الوزن': '220 جرام/متر',
      'السُمك': '0.5 مم',
      'الوحدة': 'كجم',
    },
    this.mainCoverImage = 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
    this.additionalImages = const [
      'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
      'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
    ],
    this.usedImagesCount = 3,
    this.maxImagesAllowed = 10,
    this.videoUrl = 'https://example.com/videos/yarn_demo.mp4',
    this.videoFileName = 'فيديو_تجربة_خيوط_الغزل.mp4',
    this.videoDuration = '01:30 دقيقة',
    this.videoSizeMb = 14.5,
    this.usedVideosCount = 1,
    this.maxVideosAllowed = 1,
    this.pdfDocuments = const [
      {'title': 'شهادة_الجودة_المصرية_ISO.pdf', 'size': '2.4 ميجابايت'},
    ],
    this.catalogUrl = 'https://example.com/catalogs/yarn_2026.pdf',
    this.usedPdfsCount = 1,
    this.maxPdfsAllowed = 2,
    this.tieredPrices = const [
      {'quantity': 100, 'price': 50.0},
      {'quantity': 500, 'price': 47.0},
      {'quantity': 1000, 'price': 43.0},
    ],
    this.moq = 100,
    this.maxQuantity = 5000,
    this.wholesaleDiscounts = 'خصم 14% عند طلب 1000 وحدة فأكثر',
    this.priceValidityPeriod = '30 يوم من تاريخ العرض',
    this.availableStock = 5000,
    this.dailyCapacity = '5,000 كجم / يوم',
    this.monthlyCapacity = '150,000 كجم / شهر',
    this.manufacturingLeadTime = '٧ أيام عمل',
    this.preparationTime = '٢٤ ساعة',
    this.readyForShipmentHours = 48,
    this.pickupLocation = 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى - المحلة',
    this.isDraftSaved = true,
    this.lastSavedAt,
  });

  double get completionPercentage => ((currentStep / 8.0) * 100).clamp(0.0, 100.0);

  bool isStepValid(int step) {
    switch (step) {
      case 1:
        return name.trim().isNotEmpty &&
            category.trim().isNotEmpty &&
            subCategory.trim().isNotEmpty &&
            shortDescription.trim().isNotEmpty &&
            countryOfOrigin.trim().isNotEmpty &&
            brand.trim().isNotEmpty;
      case 2:
        return technicalSpecs.isNotEmpty;
      case 3:
        return mainCoverImage != null && mainCoverImage!.isNotEmpty;
      case 4:
        return true; // Video optional
      case 5:
        return true; // Documents optional
      case 6:
        return tieredPrices.isNotEmpty && moq > 0;
      case 7:
        return availableStock >= 0 && pickupLocation.trim().isNotEmpty;
      case 8:
        return isReadyForPublish;
      default:
        return true;
    }
  }

  bool get isReadyForPublish {
    return isStepValid(1) &&
        isStepValid(2) &&
        isStepValid(3) &&
        isStepValid(6) &&
        isStepValid(7) &&
        usedImagesCount <= maxImagesAllowed &&
        usedVideosCount <= maxVideosAllowed &&
        usedPdfsCount <= maxPdfsAllowed;
  }

  ProductFormData copyWith({
    int? currentStep,
    String? name,
    String? category,
    String? subCategory,
    String? shortDescription,
    String? fullDescription,
    String? countryOfOrigin,
    String? brand,
    Map<String, String>? technicalSpecs,
    String? mainCoverImage,
    List<String>? additionalImages,
    int? usedImagesCount,
    int? maxImagesAllowed,
    String? videoUrl,
    String? videoFileName,
    String? videoDuration,
    double? videoSizeMb,
    int? usedVideosCount,
    int? maxVideosAllowed,
    List<Map<String, String>>? pdfDocuments,
    String? catalogUrl,
    int? usedPdfsCount,
    int? maxPdfsAllowed,
    List<Map<String, dynamic>>? tieredPrices,
    int? moq,
    int? maxQuantity,
    String? wholesaleDiscounts,
    String? priceValidityPeriod,
    int? availableStock,
    String? dailyCapacity,
    String? monthlyCapacity,
    String? manufacturingLeadTime,
    String? preparationTime,
    int? readyForShipmentHours,
    String? pickupLocation,
    bool? isDraftSaved,
    DateTime? lastSavedAt,
  }) {
    return ProductFormData(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      category: category ?? this.category,
      subCategory: subCategory ?? this.subCategory,
      shortDescription: shortDescription ?? this.shortDescription,
      fullDescription: fullDescription ?? this.fullDescription,
      countryOfOrigin: countryOfOrigin ?? this.countryOfOrigin,
      brand: brand ?? this.brand,
      technicalSpecs: technicalSpecs ?? this.technicalSpecs,
      mainCoverImage: mainCoverImage ?? this.mainCoverImage,
      additionalImages: additionalImages ?? this.additionalImages,
      usedImagesCount: usedImagesCount ?? this.usedImagesCount,
      maxImagesAllowed: maxImagesAllowed ?? this.maxImagesAllowed,
      videoUrl: videoUrl ?? this.videoUrl,
      videoFileName: videoFileName ?? this.videoFileName,
      videoDuration: videoDuration ?? this.videoDuration,
      videoSizeMb: videoSizeMb ?? this.videoSizeMb,
      usedVideosCount: usedVideosCount ?? this.usedVideosCount,
      maxVideosAllowed: maxVideosAllowed ?? this.maxVideosAllowed,
      pdfDocuments: pdfDocuments ?? this.pdfDocuments,
      catalogUrl: catalogUrl ?? this.catalogUrl,
      usedPdfsCount: usedPdfsCount ?? this.usedPdfsCount,
      maxPdfsAllowed: maxPdfsAllowed ?? this.maxPdfsAllowed,
      tieredPrices: tieredPrices ?? this.tieredPrices,
      moq: moq ?? this.moq,
      maxQuantity: maxQuantity ?? this.maxQuantity,
      wholesaleDiscounts: wholesaleDiscounts ?? this.wholesaleDiscounts,
      priceValidityPeriod: priceValidityPeriod ?? this.priceValidityPeriod,
      availableStock: availableStock ?? this.availableStock,
      dailyCapacity: dailyCapacity ?? this.dailyCapacity,
      monthlyCapacity: monthlyCapacity ?? this.monthlyCapacity,
      manufacturingLeadTime: manufacturingLeadTime ?? this.manufacturingLeadTime,
      preparationTime: preparationTime ?? this.preparationTime,
      readyForShipmentHours: readyForShipmentHours ?? this.readyForShipmentHours,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      isDraftSaved: isDraftSaved ?? this.isDraftSaved,
      lastSavedAt: lastSavedAt ?? this.lastSavedAt,
    );
  }
}



