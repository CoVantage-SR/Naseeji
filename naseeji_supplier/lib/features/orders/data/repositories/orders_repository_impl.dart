import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/rfq_details.dart';
import '../../domain/entities/rfq_stats.dart';
import '../../domain/entities/rfq_item.dart';
import '../../domain/entities/chat_message.dart';
import '../../domain/entities/offer_details.dart';
import '../../domain/entities/offer_approved.dart';
import '../../domain/entities/offer_rejected.dart';
import '../../domain/entities/final_agreement.dart';
import '../../domain/entities/quotation_revision.dart';
import '../../domain/entities/production_preparation.dart';
import '../../domain/entities/shipping_manifest.dart';
import '../../domain/entities/delivery_confirmation.dart';
import '../../domain/entities/payment_release.dart';
import '../../domain/entities/activity_log.dart';
import '../../domain/repositories/orders_repository.dart';

part 'orders_repository_impl.g.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  @override
  Future<RfqStats> getRfqStats() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqStats(
      newRequests: 12,
      awaitingResponse: 5,
      underNegotiation: 8,
      approvedToday: 4,
    );
  }

  @override
  Future<List<RfqItem>> getRfqItems() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return const [
      RfqItem(
        companyName: 'مصنع الرياض للملابس',
        rfqNumber: 'RFQ-8820',
        material: 'Cotton 100%',
        status: 'جديد',
        statusColorValue: 0xFF0040E0,
        statusBgColorValue: 0xFFE8F0FE,
        quantity: '5,000 م',
        location: 'الرياض، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ ساعتين',
        logoText: 'RC',
        logoBgColorValue: 0xFF0040E0,
        actionButtonText: 'تقديم عرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: true,
        iconButtonIconType: 'more',
      ),
      RfqItem(
        companyName: 'حلول جدة للنسيج',
        rfqNumber: 'RFQ-8794',
        material: 'Polyester Silk Blend',
        status: 'تفاوض',
        statusColorValue: 0xFFEA580C,
        statusBgColorValue: 0xFFFFEDD5,
        quantity: '12,500 م',
        location: 'جدة، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'منذ 5 ساعات',
        logoText: 'JT',
        logoBgColorValue: 0xFF006B5F,
        actionButtonText: 'متابعة العرض',
        actionButtonColorValue: 0xFF0040E0,
        actionButtonTextColorValue: 0xFF0040E0,
        actionButtonIsOutlined: true,
        hasIconButton: true,
        iconButtonIconType: 'chat',
      ),
      RfqItem(
        companyName: 'مصنع الدمام للملابس',
        rfqNumber: 'RFQ-8710',
        material: 'Organic Linen',
        status: 'في الانتظار',
        statusColorValue: 0xFF8B5CF6,
        statusBgColorValue: 0xFFF3E8FF,
        quantity: '3,200 م',
        location: 'الدمام، SA',
        dateLabel: 'تاريخ الطلب',
        dateValue: 'أمس، 04:30 م',
        logoText: 'DC',
        logoBgColorValue: 0xFF4B5563,
        actionButtonText: 'تم إرسال العرض',
        actionButtonColorValue: 0xFF9CA3AF,
        actionButtonTextColorValue: 0xFF4B5563,
        actionButtonIsOutlined: true,
        hasIconButton: false,
      ),
      RfqItem(
        companyName: 'شركة الأزياء الموحدة',
        rfqNumber: 'RFQ-8655',
        material: 'Wool Blend',
        status: 'تمت الموافقة',
        statusColorValue: 0xFF16A34A,
        statusBgColorValue: 0xFFDCFCE7,
        quantity: '8,000 م',
        location: 'المدينة، SA',
        dateLabel: 'تاريخ الموافقة',
        dateValue: 'اليوم، 10:15 ص',
        logoText: 'UF',
        logoBgColorValue: 0xFFD97706,
        actionButtonText: 'بدء الإنتاج',
        actionButtonColorValue: 0xFF006B5F,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: false,
      ),
      RfqItem(
        companyName: 'مصنع الشرقية للخيوط',
        rfqNumber: 'RFQ-8510',
        material: 'Nylon Waterproof',
        status: 'مرفوض',
        statusColorValue: 0xFFDC2626,
        statusBgColorValue: 0xFFFEE2E2,
        quantity: '15,000 م',
        location: 'الخبر، SA',
        dateLabel: 'تاريخ الرفض',
        dateValue: 'منذ يومين',
        logoText: 'EF',
        logoBgColorValue: 0xFFDC2626,
        actionButtonText: 'عرض سبب الرفض',
        actionButtonColorValue: 0xFFDC2626,
        actionButtonTextColorValue: 0xFFFFFFFF,
        hasIconButton: false,
      ),
    ];
  }

  @override
  Future<RfqDetails> getRfqDetails(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const RfqDetails(
      rfqId: 'NAS-2024-0892',
      companyName: 'الشركة المتحدة للنسيج الذكي',
      contactPerson: 'سارة أحمد',
      status: 'مورد معتمد',
      fabricType: 'قطن 100% (Cotton)',
      quantity: '5,000 متر',
      color: 'Indigo',
      weight: 'GSM 180',
      quality: 'Premium',
      packagingMethod: 'لفات (Rolls) مع غطاء حماية مزدوج',
      deliveryDestination: 'مستودعات الشركة - مدينة الرياض',
      notes: 'نحن بحاجة إلى متانة عالية وقدرة ممتازة على التنفس لضمان جودة استثنائية لمجموعة الصيف القادمة. يرجى التركيز على ثبات اللون تحت أشعة الشمس.',
    );
  }

  @override
  Future<List<ChatMessage>> getChatMessages(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:10 ص',
        isOutgoing: true,
        imageAttachments: [
          'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
          'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80',
        ],
      ),
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: 'هذه هي العينات المتاحة لدينا بجودة 180 جرام. متوفرة بألوان متعددة.',
        time: '09:15 ص',
        isOutgoing: true,
      ),
      ChatMessage(
        senderName: 'الشركة المتحدة للنسيج الذكي',
        senderAvatar: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:20 ص',
        isOutgoing: true,
        pdfName: 'Quotation_RFQ8820.pdf',
        pdfSize: '1.2 MB • عرض السعر المبدئي',
      ),
      ChatMessage(
        senderName: 'مصنع الأقمشة المتطور',
        senderAvatar: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?auto=format&fit=crop&w=100&q=80',
        content: '',
        time: '09:30 ص',
        isOutgoing: false,
        priceUpdateOld: 15.00,
        priceUpdateNew: 13.50,
        priceUpdateDesc: 'تم تعديل السعر بناء على الكمية المطلوبة (5000 متر).',
      ),
    ];
  }

  @override
  Future<OfferDetails> getOfferDetails(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferDetails(
      rfqId: '8710',
      statusLabel: 'في انتظار الموافقة',
      statusDescription: 'طلبك قيد المراجعة حالياً من قبل قسم الإنتاج في مصنع نسيجك.',
      lastSeen: 'منذ 5 دقائق',
      sentTimeAgo: 'ساعة واحدة',
      factoryImage: 'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=350&q=80',
      factoryLabel: 'مصنع نسيجك - وحدة الإنتاج رقم 4',
      phases: [
        OfferPhase(
          title: 'إرسال العرض',
          description: 'تم إرسال عرض السعر والتفاصيل الفنية بنجاح.',
          time: '10:45 AM',
          isCompleted: true,
        ),
        OfferPhase(
          title: 'تمت المشاهدة',
          description: 'قام مدير المصنع بفتح ومراجعة وثيقة العرض.',
          time: '11:30 AM',
          isCompleted: true,
        ),
        OfferPhase(
          title: 'قيد المراجعة',
          description: 'يتم الآن دراسة الجدول الزمني للإنتاج وتوفر المواد.',
          time: 'الآن',
          isActive: true,
          showSpinner: true,
          showPill: true,
        ),
        OfferPhase(
          title: 'الموافقة النهائية',
          description: 'المرحلة الأخيرة لإصدار أمر الشراء الرسمي.',
          time: 'قريباً',
          isFuture: true,
        ),
      ],
    );
  }

  @override
  Future<OfferApproved> getOfferApproved(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferApproved(
      rfqId: '8842',
      meterPrice: '120 ر.س / م',
      totalPrice: '600,000 ر.س',
      deliveryDate: '20 يوليو',
      paymentMethodTitle: 'طريقة الدفع',
      paymentMethodDesc: 'تحويل بنكي مباشر - المصرف الراجحي - شركة نسيجي',
      fabricTextureImage: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=350&q=80',
      fabricTextureLabel: 'خامات نسيج مختارة بعناية',
    );
  }

  @override
  Future<OfferRejected> getOfferRejected(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const OfferRejected(
      rfqId: '8510',
      factoryNotes: 'The unit price is higher than our budget for this project. We are looking for a supplier who can offer a more competitive rate for the high-volume production phase starting next quarter.',
      standardsImage: 'https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=350&q=80',
      standardsLabel: 'معايير نسيجي للجودة والابتكار',
      suggestedChanges: [
        SuggestedChange(
          text: 'خفض سعر الوحدة بنسبة 15%\nللمنافسة مع العروض الحالية في السوق',
          iconTag: 'trending_down',
        ),
        SuggestedChange(
          text: 'تقليص مدة التوريد\nالمصنع يفضل التسليم خلال 10 أيام عمل',
          iconTag: 'access_time',
        ),
        SuggestedChange(
          text: 'إرفاق شهادات الجودة (ISO)\nلتعزيز موثوقية الخامات المستخدمة',
          iconTag: 'verified',
        ),
      ],
    );
  }

  @override
  Future<FinalAgreement> getFinalAgreement(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return FinalAgreement(
      rfqId: rfqId,
      factoryLabel: 'مصنع الأقمشة المتطور',
      supplierLabel: 'شركة نسيجي للمنسوجات',
      productName: 'قطن طبيعي 100%',
      quantity: '5,000 متر',
      originalPrice: 15.00,
      counterPrice: 13.50,
      finalPrice: 12.00,
      shippingCost: 250.00,
      taxes: 900.00,
      totalAmount: 61150.00,
      paymentTerms: '50% مقدم، 50% عند الاستلام',
      deliveryTime: '7 أيام عمل',
      shippingMethod: 'شحن بري سريع',
      date: '06 يوليو 2026',
      version: 'v3.0',
    );
  }

  @override
  Future<List<QuotationRevision>> getQuotationHistory(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      QuotationRevision(
        versionNumber: 3,
        createdBy: 'مورد نسيجي',
        date: '2026-07-06',
        time: '11:00 ص',
        price: 12.00,
        notes: 'تمت الموافقة على السعر النهائي مع الخصم الإضافي.',
        status: 'مقبول',
      ),
      QuotationRevision(
        versionNumber: 2,
        createdBy: 'مصنع الأقمشة المتطور',
        date: '2026-07-05',
        time: '04:30 م',
        price: 13.50,
        notes: 'طلب خصم إضافي نظراً لحجم الطلب الكبير.',
        status: 'مرفوض',
      ),
      QuotationRevision(
        versionNumber: 1,
        createdBy: 'مورد نسيجي',
        date: '2026-07-05',
        time: '10:00 ص',
        price: 15.00,
        notes: 'العرض المبدئي بناء على مواصفات طلب السعر.',
        status: 'مستبدل',
      ),
    ];
  }

  @override
  Future<ProductionPreparation> getProductionPreparation(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ProductionPreparation(
      rfqId: rfqId,
      progressPercent: 50.0,
      currentPhase: 'Manufacturing',
      estimatedFinishDate: '12 يوليو 2026',
      preparationImages: [
        'https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?auto=format&fit=crop&w=150&q=80',
        'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=150&q=80',
      ],
      productVideoUrl: 'https://assets.mixkit.co/videos/preview/mixkit-spinning-thread-at-weaving-loom-41804-large.mp4',
      qualityInspectionImages: [
        'https://images.unsplash.com/photo-1576086213369-97a306d36557?auto=format&fit=crop&w=150&q=80',
      ],
      packagingImages: [],
      preparationNotes: 'تم تجهيز 50% من خامات القطن والبدء في نسيج اللفات الأولى. الفحص الأولي أكد مطابقة الألوان.',
    );
  }

  @override
  Future<ShippingManifest> getShippingManifest(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return ShippingManifest(
      rfqId: rfqId,
      shippingCompany: 'أرامكس Aramex',
      trackingNumber: 'ARMX-99882211',
      shipmentNumber: 'SH-882200',
      truckNumber: 'أ ب ج 1234',
      driverName: 'محمد العتيبي',
      expectedArrival: '15 يوليو 2026',
      beforeLoadingImages: [
        'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=150&q=80'
      ],
      afterLoadingImages: [
        'https://images.unsplash.com/photo-1601584115197-04ecc0da31d7?auto=format&fit=crop&w=150&q=80'
      ],
      shippingLabelUrl: 'https://pdfobject.com/pdf/sample.pdf',
      invoiceUrl: 'https://pdfobject.com/pdf/sample.pdf',
      deliveryDocsUrl: 'https://pdfobject.com/pdf/sample.pdf',
      shipmentVideoUrl: null,
    );
  }

  @override
  Future<DeliveryConfirmation> getDeliveryConfirmation(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return DeliveryConfirmation(
      rfqId: rfqId,
      receivedDate: '15 يوليو 2026',
      shipmentCondition: 'ممتازة - خالية من التلفيات',
      deliveredQuantity: '5,000 متر (كامل الكمية)',
      qualityMatch: true,
      comments: 'تم فحص الخامات ومطابقتها تماماً للعينات المتفق عليها. نشكركم على الالتزام بالوقت والمواصفات.',
      deliveryImages: [
        'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=150&q=80'
      ],
    );
  }

  @override
  Future<PaymentRelease> getPaymentRelease(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return PaymentRelease(
      rfqId: rfqId,
      orderTotal: 60000.00,
      commission: 1500.00,
      supplierReceivable: 58500.00,
      paymentStatus: 'تحت التحويل',
      expectedReleaseDate: '17 يوليو 2026',
      transferReference: 'TXN-998877665544',
      releaseTimeline: [
        'تم تأكيد الاستلام من المشتري - 15 يوليو 2026',
        'تصفية العمولة والرسوم الإدارية - 16 يوليو 2026',
        'جدولة الحوالة البنكية التلقائية - 17 يوليو 2026',
      ],
    );
  }

  final Map<String, List<ActivityLogItem>> _activityLogs = {};

  List<ActivityLogItem> _getActivityLogFor(String rfqId) {
    return _activityLogs.putIfAbsent(rfqId, () => [
      const ActivityLogItem(
        iconTag: 'payment',
        user: 'النظام المالي نسيجي',
        action: 'تجهيز الدفعة المالية للإفراج البنكي',
        date: '2026-07-06',
        time: '12:00 م',
        device: 'سيرفر الإيداعات',
        status: 'مكتمل',
      ),
      const ActivityLogItem(
        iconTag: 'delivery',
        user: 'الشركة المتحدة للنسيج الذكي',
        action: 'تأكيد استلام الشحنة وتوقيع إيصال الجودة',
        date: '2026-07-06',
        time: '11:15 ص',
        device: 'iOS Device - سارة أحمد',
        attachments: ['إيصال_الاستلام.pdf'],
        status: 'مكتمل',
      ),
      const ActivityLogItem(
        iconTag: 'shipping',
        user: 'مورد نسيجي',
        action: 'شحن الطلب وتحديث بوليصة النقل أرامكس',
        date: '2026-07-05',
        time: '03:40 م',
        device: 'Web App Portal',
        attachments: ['بوليصة_أرامكس.pdf', 'صورة_التحميل.jpg'],
        status: 'مكتمل',
      ),
      const ActivityLogItem(
        iconTag: 'verified',
        user: 'مصنع الأقمشة المتطور',
        action: 'الموافقة على جينات الخامات والإنتاج المرفوعة',
        date: '2026-07-04',
        time: '09:00 ص',
        device: 'Android App',
        status: 'مكتمل',
      ),
    ]);
  }

  @override
  Future<List<ActivityLogItem>> getActivityLog(String rfqId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _getActivityLogFor(rfqId);
  }

  @override
  Future<void> addActivityLogItem(String rfqId, ActivityLogItem item) async {
    final list = _getActivityLogFor(rfqId);
    list.insert(0, item);
  }
}

@riverpod
OrdersRepository ordersRepository(OrdersRepositoryRef ref) {
  return OrdersRepositoryImpl();
}
