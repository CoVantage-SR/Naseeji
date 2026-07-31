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
    // 1. Negotiation Phase
    DealModel(
      id: 'deal-2026-001',
      dealNumber: 'RFQ-2505-001',
      status: DealStatus.negotiation,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-101',
        name: 'مصنع النسيج الحديث',
        logoText: 'النسيج',
        logoBgColorValue: 0xFFEFF6FF,
        city: 'المحلة الكبرى، مصر',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-101',
        name: 'قماش قطن 100%',
        sku: 'COT-1001',
        quantity: 5000,
        unit: 'متر',
        unitPrice: 25.08,
        imageUrl: 'https://images.unsplash.com/photo-1584992236310-6edddc08acff?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: const NegotiationData(
        proposedUnitPrice: 25.08,
        proposedQuantity: 5000,
        proposedProductionDays: 5,
        proposedPaymentTerms: '30% مقدم، 70% عند التسليم',
        proposedDeliveryDate: '2026-03-05',
        statusText: 'مفاوضات سارية على السعر والكمية',
        isSupplierTurn: true,
      ),
      agreement: null,
      production: null,
      delivery: null,
      quality: null,
      payment: const PaymentData(totalAmount: 125400.0, paymentStatus: 'قيد التفاوض'),
      timeline: [],
      files: const [],
      daysRemaining: 10,
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      updatedAt: DateTime.now().subtract(const Duration(minutes: 30)),
    ),

    // 2. Waiting Factory Response Phase
    DealModel(
      id: 'deal-2026-002',
      dealNumber: 'RFQ-2505-002',
      status: DealStatus.waitingSupplierReview,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-102',
        name: 'مصنع الخليج للملابس',
        logoText: 'الخليج',
        logoBgColorValue: 0xFFECFDF5,
        city: 'المنصورة، مصر',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-102',
        name: 'قماش بوليستر ساده',
        sku: 'POL-2002',
        quantity: 3000,
        unit: 'متر',
        unitPrice: 27.73,
        imageUrl: 'https://images.unsplash.com/photo-1579546929518-9e396f3cc809?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: null,
      delivery: null,
      quality: null,
      payment: const PaymentData(totalAmount: 83200.0, paymentStatus: 'بانتظار رد المصنع'),
      timeline: [],
      files: const [],
      daysRemaining: 12,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      updatedAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),

    // 3. Production Phase (In Progress)
    DealModel(
      id: 'deal-2026-003',
      dealNumber: 'ORD-2504-045',
      status: DealStatus.production,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-103',
        name: 'مصنع مصر للغزل والنسيج',
        logoText: 'مصر',
        logoBgColorValue: 0xFFFEF2F2,
        city: 'طنطا، مصر',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-103',
        name: 'خيوط قطنية مشطية',
        sku: 'COT-YRN-301',
        quantity: 2000,
        unit: 'كجم',
        unitPrice: 105.0,
        imageUrl: 'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: ProductionData(
        progressPercent: 0.70,
        photoUrls: const [],
        videoUrls: const [],
        notes: 'جاري تصنيع وتعبئة البكرات',
        lastUpdatedAt: DateTime.now().subtract(const Duration(days: 1)),
      ),
      delivery: null,
      quality: null,
      payment: const PaymentData(totalAmount: 210000.0, paymentStatus: 'قيد التنفيذ والإنتاج'),
      timeline: [],
      files: const [],
      daysRemaining: 5,
      createdAt: DateTime.now().subtract(const Duration(days: 6)),
      updatedAt: DateTime.now().subtract(const Duration(days: 1)),
    ),

    // 4. Completed Phase
    DealModel(
      id: 'deal-2026-004',
      dealNumber: 'ORD-2504-032',
      status: DealStatus.completed,
      factoryInfo: const DealPartyInfo(
        id: 'FAC-104',
        name: 'مصنع العروبة للملابس',
        logoText: 'العروبة',
        logoBgColorValue: 0xFFF5F3FF,
        city: 'دمياط، مصر',
      ),
      supplierInfo: const DealPartyInfo(
        id: 'SUP-501',
        name: 'شركة نسيج النيل',
        logoText: 'نسيج',
        logoBgColorValue: 0xFF0D9488,
        city: 'العاشر من رمضان',
      ),
      product: const DealProductInfo(
        id: 'prod-104',
        name: 'قماش لينن طبيعي',
        sku: 'LIN-4004',
        quantity: 1500,
        unit: 'متر',
        unitPrice: 45.0,
        imageUrl: 'https://images.unsplash.com/photo-1528459801416-a9e53bbf4e17?auto=format&fit=crop&w=400&q=80',
      ),
      quotation: null,
      negotiation: null,
      agreement: null,
      production: null,
      delivery: null,
      quality: const QualityData(
        statusText: 'مكتملة ومقبولة الجودة 100%',
        isAccepted: true,
        inspectionPhotoUrls: [],
      ),
      payment: PaymentData(
        totalAmount: 67500.0,
        paymentStatus: 'تم الدفع بالكامل',
        transferDate: DateTime.now().subtract(const Duration(days: 5)),
      ),
      timeline: [],
      files: const [],
      daysRemaining: 0,
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
      updatedAt: DateTime.now().subtract(const Duration(days: 5)),
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

