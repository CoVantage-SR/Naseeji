import '../../domain/entities/product_detail_entities.dart';
import '../../domain/repositories/product_detail_repository.dart';

/// Mock implementation of [ProductDetailRepository].
/// Returns realistic Arabic data with simulated network delay.
///
/// Business rules always enforced:
/// - Logistics carrier = "ناصيجي لوجستيك" (Naseeji Logistics Only)
/// - Shipping SLA = 48 hours
/// - Procurement timeline = 24 steps
class MockProductDetailRepository implements ProductDetailRepository {
  const MockProductDetailRepository();

  @override
  Future<List<BulkPricingTier>> getBulkPricingTiers(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      BulkPricingTier(minQty: 100, maxQty: 499, pricePerUnit: 145.0, discountPercent: 0),
      BulkPricingTier(minQty: 500, maxQty: 999, pricePerUnit: 132.0, discountPercent: 9),
      BulkPricingTier(minQty: 1000, maxQty: 4999, pricePerUnit: 120.0, discountPercent: 17),
      BulkPricingTier(minQty: 5000, maxQty: 0, pricePerUnit: 108.0, discountPercent: 26),
    ];
  }

  @override
  Future<ProductionCapacity> getProductionCapacity(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const ProductionCapacity(
      dailyCapacity: 2500,
      monthlyCapacity: 65000,
      unit: 'كيلو جرام',
      currentUtilization: 0.72,
    );
  }

  @override
  Future<LogisticsInfo> getLogisticsInfo(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    // Business rule: carrier ALWAYS = "ناصيجي لوجستيك", SLA ALWAYS = 48 hours
    return const LogisticsInfo(
      carrier: 'ناصيجي لوجستيك',
      slaHours: 48,
      coverageZones: [
        'القاهرة الكبرى',
        'الإسكندرية',
        'الدلتا',
        'الصعيد',
        'قناة السويس',
        'سيناء',
      ],
      freeShippingThreshold: 10000.0,
    );
  }

  @override
  Future<List<DocumentItem>> getDocuments(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      DocumentItem(
        id: 'doc_1',
        title: 'الكتالوج الفني الكامل',
        type: 'pdf',
        fileSizeKb: 2480,
        isDownloadable: true,
      ),
      DocumentItem(
        id: 'doc_2',
        title: 'شهادة ISO 9001',
        type: 'certificate',
        fileSizeKb: 320,
        isDownloadable: true,
      ),
      DocumentItem(
        id: 'doc_3',
        title: 'تقرير اختبار المختبر الكيميائي',
        type: 'lab_report',
        fileSizeKb: 870,
        isDownloadable: true,
      ),
      DocumentItem(
        id: 'doc_4',
        title: 'شهادة Oeko-Tex Standard 100',
        type: 'certificate',
        fileSizeKb: 290,
        isDownloadable: true,
      ),
    ];
  }

  @override
  Future<SampleInfo> getSampleInfo(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const SampleInfo(
      isAvailable: true,
      pricePerSample: 85.0,
      sampleDeliveryDays: 3,
      requiresDeposit: false,
    );
  }

  @override
  Future<List<ProductReview>> getReviews(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      ProductReview(
        id: 'rev_1',
        reviewerName: 'المهندس محمود الشرقاوي',
        factoryName: 'مصنع النسيج الحديث للملابس',
        rating: 5.0,
        comment:
            'جودة ممتازة وتسليم في الوقت المحدد تماماً. المنتج طابق المواصفات 100% وسأكرر التعامل بالتأكيد.',
        date: 'منذ ٣ أسابيع',
        verifiedPurchase: true,
      ),
      ProductReview(
        id: 'rev_2',
        reviewerName: 'أ. سامية الجمال',
        factoryName: 'مصنع الفردوس للملابس الجاهزة',
        rating: 4.5,
        comment:
            'خيوط عالية الجودة ومناسبة لخط إنتاجنا. التغليف كان محترماً جداً وأبعاد البكرات دقيقة.',
        date: 'منذ شهر',
        verifiedPurchase: true,
      ),
      ProductReview(
        id: 'rev_3',
        reviewerName: 'م. طارق نصر',
        factoryName: 'مصنع الجودة للبنطلونات',
        rating: 4.0,
        comment:
            'المنتج جيد ومناسب للسعر. الاستجابة للتواصل كانت سريعة والمورد محترف.',
        date: 'منذ شهرين',
        verifiedPurchase: false,
      ),
    ];
  }

  @override
  Future<List<ProcurementStage>> getProcurementTimeline(String productId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _buildTimeline();
  }

  static List<ProcurementStage> _buildTimeline() {
    final stages = [
      ('تقديم طلب عرض السعر (RFQ)', 'إرسال الطلب للمورد مع جميع المواصفات'),
      ('مراجعة الطلب من قِبل المورد', 'يراجع المورد المتطلبات والكميات'),
      ('تأكيد استلام الطلب', 'يؤكد المورد استلام الطلب ويحدد الجدول الزمني'),
      ('إعداد عرض السعر التفصيلي', 'يُعد المورد عرضاً تفصيلياً بالأسعار والشروط'),
      ('إرسال عرض السعر للمصنع', 'يُرسل المورد عرض السعر عبر المنصة'),
      ('مراجعة عرض السعر من المصنع', 'تراجع إدارة المصنع عرض السعر'),
      ('طلب تعديلات (إن وجدت)', 'التفاوض على الأسعار أو الشروط إن لزم'),
      ('الموافقة على عرض السعر', 'يوافق المصنع رسمياً على العرض'),
      ('توقيع عقد الشراء', 'توقيع العقد الرسمي بين الطرفين'),
      ('دفع العربون (إن وجد)', 'تحويل الدفعة المقدمة للمورد'),
      ('جدولة الإنتاج لدى المورد', 'يُدرج المورد الطلب في جدوله الإنتاجي'),
      ('بدء الإنتاج', 'يبدأ المورد فعلياً بتصنيع الكميات المطلوبة'),
      ('مراقبة جودة الإنتاج', 'فحوصات الجودة أثناء خط الإنتاج'),
      ('انتهاء الإنتاج', 'اكتمال تصنيع الكمية الكاملة'),
      ('فحص جودة ما قبل الشحن', 'فحص نهائي شامل قبل التعبئة'),
      ('الموافقة على نتائج الفحص', 'اعتماد تقرير الجودة'),
      ('تجهيز التعبئة والتغليف', 'التعبئة وفقاً لمواصفات المصنع'),
      ('استلام ناصيجي لوجستيك للشحنة', 'تستلم ناصيجي لوجستيك البضاعة من المورد'),
      ('الشحن خلال 48 ساعة (SLA)', 'انطلاق الشحنة في أقل من 48 ساعة من الاستلام'),
      ('تتبع الشحنة في الطريق', 'متابعة لحظية لموقع الشحنة'),
      ('وصول الشحنة للمصنع', 'تصل الشحنة إلى عنوان المصنع'),
      ('فحص الاستلام والتحقق من الجودة', 'يفحص المصنع الكميات والجودة عند الاستلام'),
      ('الموافقة على الاستلام وإصدار الفاتورة', 'تأكيد الاستلام وإصدار الفاتورة النهائية'),
      ('إغلاق الطلب وتقييم المورد', 'إتمام الصفقة وإضافة تقييم للمورد'),
    ];

    return List.generate(stages.length, (i) {
      final step = i + 1;
      final String status;
      final String? completedAt;

      // Mock: first 8 steps completed, step 9 active, rest pending
      if (step <= 8) {
        status = 'completed';
        completedAt = 'منذ ${8 - i} أيام';
      } else if (step == 9) {
        status = 'active';
        completedAt = null;
      } else {
        status = 'pending';
        completedAt = null;
      }

      return ProcurementStage(
        step: step,
        label: stages[i].$1,
        description: stages[i].$2,
        status: status,
        completedAt: completedAt,
      );
    });
  }
}

