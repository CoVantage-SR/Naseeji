import '../../domain/entities/deal_model.dart';

abstract class DealsRepository {
  Future<List<DealModel>> getDeals({
    DealStatus? statusFilter,
    String? searchQuery,
    bool onlyActionRequired = false,
  });

  Future<DealModel> getDealById(String dealId);

  Future<bool> updateDealStatus(String dealId, DealStatus newStatus);

  Future<bool> updateQuotation(String dealId, QuotationData quotation);

  Future<bool> updateNegotiation(String dealId, NegotiationData negotiation);

  Future<bool> signAgreement(String dealId, bool isSupplier);

  Future<bool> updateProduction(String dealId, ProductionData production);

  Future<bool> updateDelivery(String dealId, DeliveryData delivery);

  Future<bool> updateQuality(String dealId, QualityData quality);
}

class DealsRepositoryImpl implements DealsRepository {
  final List<DealModel> _mockDeals = [
    // 1. New Deal (Action Required)
    DealModel(
      id: 'deal-2026-001',
      dealNumber: 'DEAL-2026-001',
      status: DealStatus.newDeal,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-101',
        name: 'مصانع المحلة للقطنيات والملابس',
        logoText: 'المحلة',
        logoBgColorValue: 0xFF1E3A8A,
        city: 'المحلة الكبرى',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل للغزل والنسيج',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-101',
        name: 'خيوط غزل القطن الفاخر الممشط 30/1',
        sku: 'COT-YRN-301',
        quantity: 2000,
        unit: 'كجم',
        unitPrice: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: null,
      delivery: null,
      quality: null,
      payment: const PaymentData(totalAmount: 90000.0, paymentStatus: 'بانتظار تقديم عرض السعر'),
      timeline: [
        DealTimelineStep(
          title: 'استقبال طلب شراء جديد (RFQ)',
          description: 'قام المصنع بإرسال طلب توريد 2,000 كجم غزل قطن ممشط.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: true,
          isCurrent: true,
        ),
      ],
      files: const [
        DealFileData(
          title: 'مواصفات_طلب_التوريد_RFQ.pdf',
          url: 'https://naseeji.com/docs/rfq_specs.pdf',
          fileType: 'PDF',
          fileSize: '1.8 MB',
        ),
      ],
      daysRemaining: 14,
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),

    // 2. Negotiation Phase
    DealModel(
      id: 'deal-2026-002',
      dealNumber: 'DEAL-2026-002',
      status: DealStatus.negotiation,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-102',
        name: 'مصنع القاهرة للتريكو والمجهشات',
        logoText: 'القاهرة',
        logoBgColorValue: 0xFF4338CA,
        city: 'شبرا الخيمة',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل للغزل والنسيج',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-102',
        name: 'قماش قطني طبيعي 100% عرض 180 سم',
        sku: 'COT-FAB-180',
        quantity: 1500,
        unit: 'متر',
        unitPrice: 80.0,
        imageUrl: 'https://images.unsplash.com/photo-1596461404969-9ae70f2830c1?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: QuotationData(
        quoteId: 'Q-901',
        unitPrice: 85.0,
        quantity: 1500,
        totalPrice: 127500.0,
        productionDays: 7,
        paymentTerms: '50% مقدم، 50% عند الفحص والجودة',
        validUntil: DateTime.now().add(const Duration(days: 7)),
      ),
      negotiation: const NegotiationData(
        proposedUnitPrice: 80.0,
        proposedQuantity: 1500,
        proposedProductionDays: 5,
        proposedPaymentTerms: '30% مقدم، 70% عند الاستلام',
        proposedDeliveryDate: '2026-03-05',
        statusText: 'المصنع يطلب تخفيض السعر إلى 80 ج.م وتسريع التسليم لـ 5 أيام',
        isSupplierTurn: true,
      ),
      agreement: null,
      production: null,
      delivery: null,
      quality: null,
      payment: const PaymentData(totalAmount: 120000.0, paymentStatus: 'قيد التفاوض'),
      timeline: [
        DealTimelineStep(
          title: 'إرسال عرض السعر الأول',
          description: 'أرسل المورد عرض سعر بقيمة 85 ج.م/متر.',
          timestamp: DateTime.now().subtract(const Duration(days: 1)),
          isCompleted: true,
          isCurrent: false,
        ),
        DealTimelineStep(
          title: 'استقبال عرض مقابل من المصنع',
          description: 'طلب المصنع تعديل السعر لـ 80 ج.م وخصم يومين من التصنيع.',
          timestamp: DateTime.now().subtract(const Duration(hours: 4)),
          isCompleted: true,
          isCurrent: true,
        ),
      ],
      files: const [
        DealFileData(
          title: 'عرض_سعر_مبدئي_QUO.pdf',
          url: 'https://naseeji.com/docs/quo_901.pdf',
          fileType: 'PDF',
          fileSize: '2.1 MB',
        ),
      ],
      daysRemaining: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),

    // 3. Production Phase (Active)
    DealModel(
      id: 'deal-2026-003',
      dealNumber: 'DEAL-2026-003',
      status: DealStatus.production,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-103',
        name: 'شركة النصر للمنسوجات والمفروشات',
        logoText: 'النصر',
        logoBgColorValue: 0xFF15803D,
        city: 'مدينة 6 أكتوبر',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل للغزل والنسيج',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-101',
        name: 'خيوط غزل القطن الفاخر الممشط 30/1',
        sku: 'COT-YRN-301',
        quantity: 5000,
        unit: 'كجم',
        unitPrice: 42.0,
        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: QuotationData(
        quoteId: 'Q-882',
        unitPrice: 42.0,
        quantity: 5000,
        totalPrice: 210000.0,
        productionDays: 10,
        paymentTerms: '40% مقدم بالضمان، 60% عند قبول الجودة',
        validUntil: DateTime.now().add(const Duration(days: 20)),
      ),
      negotiation: null,
      agreement: AgreementData(
        agreementNumber: 'AGR-2026-882',
        supplierSigned: true,
        factorySigned: true,
        supplierSignedAt: DateTime.now().subtract(const Duration(days: 4)),
        factorySignedAt: DateTime.now().subtract(const Duration(days: 3)),
        agreementDocUrl: 'https://naseeji.com/docs/agreement_882.pdf',
      ),
      production: ProductionData(
        progressPercent: 0.65,
        photoUrls: const [
          'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
        ],
        videoUrls: const [],
        notes: 'تم الانتهاء من غزل 3,250 كجم وجاري التجهيز للتعبئة.',
        lastUpdatedAt: DateTime.now().subtract(const Duration(hours: 6)),
      ),
      delivery: const DeliveryData(
        method: DeliveryMethod.supplierDelivery,
        estimatedDeliveryDate: DateTime(2026, 3, 1),
        responsiblePersonName: 'أحمد إبراهيم (سائق الشحنة)',
        responsiblePersonPhone: '01000000000',
        notes: 'التوصيل لمخزن المصنع بـ 6 أكتوبر',
      ),
      quality: null,
      payment: const PaymentData(
        totalAmount: 210000.0,
        paymentStatus: 'الدفعة المقدمة مجمدة بالضمان (Escrow)',
      ),
      timeline: [
        DealTimelineStep(
          title: 'توقيع العقد رسمياً من الطرفين',
          description: 'تم اعتماد اتفاق التوريد رقم AGR-2026-882.',
          timestamp: DateTime.now().subtract(const Duration(days: 3)),
          isCompleted: true,
          isCurrent: false,
        ),
        DealTimelineStep(
          title: 'بدء عمليات الإنتاج والتصنيع بالمصنع',
          description: 'تم الوصول لنسبة إنجاز 65%.',
          timestamp: DateTime.now().subtract(const Duration(hours: 6)),
          isCompleted: true,
          isCurrent: true,
        ),
      ],
      files: const [
        DealFileData(
          title: 'عقد_التوريد_المعتمد_AGR.pdf',
          url: 'https://naseeji.com/docs/agreement_882.pdf',
          fileType: 'PDF',
          fileSize: '3.4 MB',
        ),
      ],
      daysRemaining: 4,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 6)),
    ),

    // 4. Quality Inspection Phase
    DealModel(
      id: 'deal-2026-004',
      dealNumber: 'DEAL-2026-004',
      status: DealStatus.qualityInspection,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-104',
        name: 'مؤسسة الشرق للمنسوجات الراقية',
        logoText: 'الشرق',
        logoBgColorValue: 0xFF9333EA,
        city: 'العاشر من رمضان',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل للغزل والنسيج',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-103',
        name: 'نسيج صوف مخلوط مميز للبدل والأطقم',
        sku: 'WOL-MIX-003',
        quantity: 500,
        unit: 'متر',
        unitPrice: 160.0,
        imageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: null,
      delivery: const DeliveryData(
        method: DeliveryMethod.factoryPickup,
        estimatedDeliveryDate: DateTime(2026, 2, 20),
        responsiblePersonName: 'مندوب استلام المصنع',
        responsiblePersonPhone: '01100000000',
      ),
      quality: const QualityData(
        statusText: 'المصنع يقوم بفحص الأثواب والمعايرة المعملية حالياً',
        isAccepted: false,
        inspectionPhotoUrls: [],
        notes: 'فحص ثبات الألوان ونسبة الصوف بالمختبر.',
      ),
      payment: const PaymentData(
        totalAmount: 80000.0,
        paymentStatus: 'المبلغ كلياً بضمان نسيجي لحين الفسح',
      ),
      timeline: [
        DealTimelineStep(
          title: 'استلام الكمية من المنشأة',
          description: 'تم تسليم الأثواب لمندوب المصنع.',
          timestamp: DateTime.now().subtract(const Duration(hours: 12)),
          isCompleted: true,
          isCurrent: false,
        ),
        DealTimelineStep(
          title: 'فحص الجودة والمعايرة المعملية',
          description: 'جاري مطابقة المواصفات القياسية.',
          timestamp: DateTime.now().subtract(const Duration(hours: 2)),
          isCompleted: true,
          isCurrent: true,
        ),
      ],
      files: const [],
      daysRemaining: 2,
      createdAt: DateTime.now().subtract(const Duration(days: 8)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    // 5. Completed Deal
    DealModel(
      id: 'deal-2026-005',
      dealNumber: 'DEAL-2026-005',
      status: DealStatus.completed,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-105',
        name: 'مصانع الدلتا للغزل والتريكو',
        logoText: 'الدلتا',
        logoBgColorValue: 0xFF2563EB,
        city: 'طنطا',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل للغزل والنسيج',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-101',
        name: 'خيوط غزل القطن الفاخر الممشط 30/1',
        sku: 'COT-YRN-301',
        quantity: 3000,
        unit: 'كجم',
        unitPrice: 44.0,
        imageUrl: 'https://images.unsplash.com/photo-1544816155-12df9643f363?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: null,
      delivery: null,
      quality: const QualityData(
        statusText: 'تمت الموافقة وقبول الجودة 100%',
        isAccepted: true,
        inspectionPhotoUrls: [],
      ),
      payment: PaymentData(
        totalAmount: 132000.0,
        paymentStatus: 'تم تحويل المستحقات كاملة لحسابك',
        transferDate: DateTime.now().subtract(const Duration(days: 2)),
      ),
      timeline: [
        DealTimelineStep(
          title: 'تحويل المستحقات وإغلاق الصفقة بنجاح',
          description: 'تم تحويل 132,000 ج.م لحساب المورد.',
          timestamp: DateTime.now().subtract(const Duration(days: 2)),
          isCompleted: true,
          isCurrent: true,
        ),
      ],
      files: const [],
      daysRemaining: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
      updatedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
  ];

  @override
  Future<List<DealModel>> getDeals({
    DealStatus? statusFilter,
    String? searchQuery,
    bool onlyActionRequired = false,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    var result = List<DealModel>.from(_mockDeals);

    if (onlyActionRequired) {
      result = result.where((d) => d.status.requiresSupplierAction).toList();
    }

    if (statusFilter != null) {
      result = result.where((d) => d.status == statusFilter).toList();
    }

    if (searchQuery != null && searchQuery.trim().isNotEmpty) {
      final q = searchQuery.toLowerCase().trim();
      result = result.where((d) =>
          d.dealNumber.toLowerCase().contains(q) ||
          d.factoryInfo.name.toLowerCase().contains(q) ||
          d.product.name.toLowerCase().contains(q)).toList();
    }

    return result;
  }

  @override
  Future<DealModel> getDealById(String dealId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _mockDeals.firstWhere(
      (d) => d.id == dealId,
      orElse: () => _mockDeals.first,
    );
  }

  @override
  Future<bool> updateDealStatus(String dealId, DealStatus newStatus) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      _mockDeals[index] = _mockDeals[index].copyWith(
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateQuotation(String dealId, QuotationData quotation) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      _mockDeals[index] = _mockDeals[index].copyWith(
        quotation: quotation,
        status: DealStatus.quotationSent,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateNegotiation(String dealId, NegotiationData negotiation) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      _mockDeals[index] = _mockDeals[index].copyWith(
        negotiation: negotiation,
        status: DealStatus.negotiation,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> signAgreement(String dealId, bool isSupplier) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      final currentAg = _mockDeals[index].agreement ?? AgreementData(
        agreementNumber: 'AGR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        supplierSigned: false,
        factorySigned: false,
      );

      final updatedAg = AgreementData(
        agreementNumber: currentAg.agreementNumber,
        supplierSigned: isSupplier ? true : currentAg.supplierSigned,
        factorySigned: !isSupplier ? true : currentAg.factorySigned,
        supplierSignedAt: isSupplier ? DateTime.now() : currentAg.supplierSignedAt,
        factorySignedAt: !isSupplier ? DateTime.now() : currentAg.factorySignedAt,
        agreementDocUrl: currentAg.agreementDocUrl ?? 'https://naseeji.com/docs/signed_agreement.pdf',
      );

      final newStatus = (updatedAg.supplierSigned && updatedAg.factorySigned)
          ? DealStatus.signed
          : DealStatus.agreementPending;

      _mockDeals[index] = _mockDeals[index].copyWith(
        agreement: updatedAg,
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateProduction(String dealId, ProductionData production) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      final newStatus = production.progressPercent >= 1.0 ? DealStatus.readyForDelivery : DealStatus.production;
      _mockDeals[index] = _mockDeals[index].copyWith(
        production: production,
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateDelivery(String dealId, DeliveryData delivery) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      _mockDeals[index] = _mockDeals[index].copyWith(
        delivery: delivery,
        status: DealStatus.delivering,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }

  @override
  Future<bool> updateQuality(String dealId, QualityData quality) async {
    await Future.delayed(const Duration(milliseconds: 250));
    final index = _mockDeals.indexWhere((d) => d.id == dealId);
    if (index != -1) {
      final newStatus = quality.isAccepted ? DealStatus.paymentPending : DealStatus.dispute;
      _mockDeals[index] = _mockDeals[index].copyWith(
        quality: quality,
        status: newStatus,
        updatedAt: DateTime.now(),
      );
      return true;
    }
    return false;
  }
}
