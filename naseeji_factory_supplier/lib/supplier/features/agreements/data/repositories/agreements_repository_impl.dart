import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/agreement_model.dart';
import '../../domain/repositories/agreements_repository.dart';

part 'agreements_repository_impl.g.dart';

class AgreementsRepositoryImpl implements AgreementsRepository {
  final List<B2BAgreement> _mockAgreements = [
    B2BAgreement(
      id: 'AGR-2026-105',
      rfqNumber: 'RFQ-8820',
      quotationNumber: 'QUO-9912',
      orderNumber: 'ORD-9022',
      createdDate: '2026-07-20',
      lastUpdated: '2026-07-22',
      version: '1.0',
      status: AgreementStatus.awaitingSupplierSignature,
      supplierInfo: const SupplierInfo(
        logoText: 'MS',
        logoBgColorValue: 0xFF0040E0,
        companyName: 'شركة النسيج الممتاز المحدودة',
        supplierName: 'مورد نسيجي (إبراهيم المحمدي)',
        phone: '+٢٠ ١٠٠ ١٢٣ ٤٥٦٧',
        email: 'supplier@naseeji.com',
        address: 'المنطقة الصناعية الثانية - العاشر من رمضان، مصر',
        rating: 4.9,
        verified: true,
      ),
      factoryInfo: const FactoryInfo(
        logoText: 'RC',
        logoBgColorValue: 0xFF006B5F,
        factoryName: 'مصنع الشرق للملابس الجاهزة والمنسوجات',
        contactPerson: 'المهندس أحمد مصطفى',
        phone: '+٢٠ ١١١ ٧٦٥ ٤٣٢١',
        email: 'factory.east@gmail.com',
        address: 'المنطقة الصناعية الأولى - المحلة الكبرى، مصر',
        rating: 4.7,
      ),
      product: const AgreementProduct(
        imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=400&q=80',
        name: 'قماش قطن ١٠٠٪ فاخر للثياب والقمصان',
        sku: 'FAB-COT-105',
        category: 'أقمشة قطنية صيفية',
        specifications: 'الوزن: ١٤٠ جم/م٢ • الطول: ٥٠ متر لفة • اللون: أبيض شاهق • نوع النسيج: بوبلين قطن',
        countryOfOrigin: 'جمهورية مصر العربية',
        quantity: 5000,
        unit: 'متراً',
        unitPrice: 120.0,
        totalPrice: 600000.0,
        currency: 'ج.م',
        packagingDetails: 'مغلف بأكياس بولي إيثيلين محكمة الإغلاق ومحفوظ داخل كراتين مقواة مثبتة على طبالي خشبية معقمة.',
      ),
      production: const ProductionInfo(
        productionDuration: '٢٥ يوم عمل',
        startDate: '2026-08-01',
        endDate: '2026-08-25',
        readyDate: '2026-08-26',
      ),
      payment: const PaymentInfo(
        method: 'حوالة بنكية وحساب الضمان المالي B2B من نسيجي',
        advancePercentage: 30.0,
        advanceAmount: 180000.0,
        paymentDueDate: 'خلال ٣ أيام عمل من التوقيع وقبل بدء الإنتاج',
        remainingAmount: 420000.0,
        currency: 'ج.م',
      ),
      delivery: const DeliveryInfo(
        pickupLocation: 'مستودع المورد الرئيسي - العاشر من رمضان - بوابة الشحن رقم ٢',
        shipmentReadyDate: '2026-08-27',
        deliveryStatus: 'في انتظار توقيع الاتفاقية (يتم اختيار شركة الشحن لاحقاً من نظام الشحن)',
        shippingCompanyNote: 'شركة الشحن يتم اختيارها لاحقاً بشكل مستقل عبر وحدة خدمات الشحن واللوجستيات بالمنصة.',
      ),
      terms: AgreementTerms.defaultTerms,
      documents: const [
        AgreementDocument(
          id: 'DOC-1',
          name: 'عرض_السعر_المعتمد_QUO_9912.pdf',
          type: 'عرض السعر',
          url: 'https://naseeji.com/docs/quote_9912.pdf',
          size: '١.٤ ميجابايت',
          version: 1,
          uploadedAt: '2026-07-20',
        ),
        AgreementDocument(
          id: 'DOC-2',
          name: 'كتالوج_الأقمشة_القطنية_2026.pdf',
          type: 'الكتالوج',
          url: 'https://naseeji.com/docs/catalog_2026.pdf',
          size: '٤.٢ ميجابايت',
          version: 1,
          uploadedAt: '2026-07-20',
        ),
        AgreementDocument(
          id: 'DOC-3',
          name: 'شهادة_الجودة_ISO9001.pdf',
          type: 'شهادات الجودة',
          url: 'https://naseeji.com/docs/iso9001.pdf',
          size: '٨٥٠ كيلوبايت',
          version: 1,
          uploadedAt: '2026-07-21',
        ),
        AgreementDocument(
          id: 'DOC-4',
          name: 'عينة_عالية_الدقة_لنسيج_القطن.jpg',
          type: 'صور',
          url: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=800&q=80',
          size: '٢.١ ميجابايت',
          version: 1,
          uploadedAt: '2026-07-21',
        ),
      ],
      supplierSignature: null,
      factorySignature: null,
      timeline: const [
        AgreementTimelineStep(
          date: '2026-07-20',
          time: '10:30 ص',
          user: 'المصنع (مصنع الشرق)',
          status: 'قبول عرض السعر',
          notes: 'تم قبول عرض السعر رقم (QUO-9912) بنجاح والموافقة على التكلفة والكميات.',
          attachments: ['عرض_السعر_المعتمد_QUO_9912.pdf'],
        ),
        AgreementTimelineStep(
          date: '2026-07-20',
          time: '10:31 ص',
          user: 'نظام نسيجي التلقائي',
          status: 'إنشاء الاتفاقية تلقائياً',
          notes: 'قام النظام بإنشاء مسودة الاتفاقية رقم (AGR-2026-105) تلقائياً من بيانات RFQ وعرض السعر.',
          attachments: [],
        ),
      ],
      history: const [
        AgreementHistoryRecord(
          timestamp: '2026-07-20 10:31 ص',
          user: 'نظام نسيجي الآلي',
          action: 'توليد الاتفاقية من عرض السعر المقبول',
          reason: 'قبول عرض السعر QUO-9912 لطلب RFQ-8820',
          versionNumber: '1.0',
        ),
      ],
    ),
    B2BAgreement(
      id: 'AGR-2026-088',
      rfqNumber: 'RFQ-8794',
      quotationNumber: 'QUO-8501',
      orderNumber: 'ORD-8910',
      createdDate: '2026-06-25',
      lastUpdated: '2026-06-26',
      version: '1.0',
      status: AgreementStatus.active,
      supplierInfo: const SupplierInfo(
        logoText: 'MS',
        logoBgColorValue: 0xFF0040E0,
        companyName: 'شركة النسيج الممتاز المحدودة',
        supplierName: 'مورد نسيجي',
        phone: '+٢٠ ١٠٠ ١٢٣ ٤٥٦٧',
        email: 'supplier@naseeji.com',
        address: 'المنطقة الصناعية الثانية - العاشر من رمضان، مصر',
        rating: 4.9,
        verified: true,
      ),
      factoryInfo: const FactoryInfo(
        logoText: 'UF',
        logoBgColorValue: 0xFF16A34A,
        factoryName: 'شركة الأزياء الموحدة للتصنيع',
        contactPerson: 'الأستاذ خالد السالم',
        phone: '+٢٠ ١٠٠ ٩٨٧ ٦٥٤٣',
        email: 'k.salam@uniform.com',
        address: 'حي السليمانية - مدينة ٦ أكتوبر، مصر',
        rating: 4.8,
      ),
      product: const AgreementProduct(
        imageUrl: 'https://images.unsplash.com/photo-1530087964557-3aa5c55537e2?auto=format&fit=crop&w=400&q=80',
        name: 'خيوط الصوف الإنجليزي المعالج ضد الرطوبة',
        sku: 'YRN-WOL-890',
        category: 'خيوط وغزل فاخر',
        specifications: 'السمك: ٣/٢٤ • الوزن الكلي: ٣٨٠٠ كجم • اللون: كحلي داكن',
        countryOfOrigin: 'المملكة المتحدة',
        quantity: 12500,
        unit: 'كجم',
        unitPrice: 38.5,
        totalPrice: 481250.0,
        currency: 'ج.م',
        packagingDetails: 'صناديق كرتونية مبطنة بألواح خشبية لامتصاص الصدمات وحماية الخيوط.',
      ),
      production: const ProductionInfo(
        productionDuration: '١٥ يوم عمل',
        startDate: '2026-06-27',
        endDate: '2026-07-12',
        readyDate: '2026-07-13',
      ),
      payment: const PaymentInfo(
        method: 'حوالة نسيجي المؤمنة وتأمين الدفعة المقدمة',
        advancePercentage: 30.0,
        advanceAmount: 144375.0,
        paymentDueDate: 'تم سداد الدفعة المقدمة بنجاح',
        remainingAmount: 336875.0,
        currency: 'ج.م',
      ),
      delivery: const DeliveryInfo(
        pickupLocation: 'مستودع المورد - العاشر من رمضان',
        shipmentReadyDate: '2026-07-13',
        deliveryStatus: 'جاري الشحن - تم اختيار شركة أرامكس',
        shippingCompanyNote: 'تم اختيار شركة الشحن لاحقاً عبر نظام الشحن الموحد بالمنصة.',
      ),
      terms: AgreementTerms.defaultTerms,
      documents: const [
        AgreementDocument(
          id: 'DOC-10',
          name: 'العقد_النهائي_الموقع_AGR_088.pdf',
          type: 'PDF',
          url: 'https://naseeji.com/docs/contract_final.pdf',
          size: '٢.٨ ميجابايت',
          version: 1,
          uploadedAt: '2026-06-26',
        ),
      ],
      supplierSignature: const SignatureInfo(
        userName: 'مورد نسيجي',
        userId: 'SUP-100',
        date: '2026-06-25',
        time: '٠٤:٠٠ م',
        isSigned: true,
      ),
      factorySignature: const SignatureInfo(
        userName: 'الأستاذ خالد السالم',
        userId: 'FAC-402',
        date: '2026-06-26',
        time: '٠٩:٠٠ ص',
        isSigned: true,
      ),
      timeline: const [
        AgreementTimelineStep(
          date: '2026-06-25',
          time: '٠٤:٠٠ م',
          user: 'المورد نسيجي',
          status: 'توقيع المورد',
          notes: 'تم توقيع الاتفاقية من جهة المورد بنجاح.',
          attachments: [],
        ),
        AgreementTimelineStep(
          date: '2026-06-26',
          time: '٠٩:٠٠ ص',
          user: 'الأستاذ خالد السالم (المصنع)',
          status: 'توقيع المصنع وتفعيل العقد',
          notes: 'تم التوقيع النهائي وتفعيل العقد وإصدار أمر الإنتاج PRD-8871.',
          attachments: [],
        ),
      ],
      history: const [
        AgreementHistoryRecord(
          timestamp: '2026-06-26 ٠٩:٠٠ ص',
          user: 'شركة الأزياء الموحدة',
          action: 'توقيع واعتماد الاتفاقية النهائية',
          reason: 'موافقة الطرفين وتأكيد الحجز المالي',
          versionNumber: '1.0',
        ),
      ],
      productionOrderId: 'PRD-8871',
    ),
  ];

  @override
  Future<List<B2BAgreement>> getAgreements() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_mockAgreements);
  }

  @override
  Future<B2BAgreement?> getAgreementDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      return _mockAgreements[index];
    }
    return null;
  }

  @override
  Future<void> updateAgreement(B2BAgreement agreement) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockAgreements.indexWhere((a) => a.id == agreement.id);
    if (index != -1) {
      _mockAgreements[index] = agreement;
    } else {
      _mockAgreements.insert(0, agreement);
    }
  }

  @override
  Future<void> approveAgreement(String id) async {
    final agreement = await getAgreementDetails(id);
    if (agreement != null) {
      final updated = agreement.copyWith(
        status: AgreementStatus.awaitingFactorySignature,
        supplierSignature: SignatureInfo(
          userName: agreement.supplierInfo.supplierName,
          userId: 'SUP-100',
          date: DateTime.now().toString().split(' ')[0],
          time: '${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}',
          isSigned: true,
        ),
      );
      await updateAgreement(updated);
    }
  }

  @override
  Future<void> rejectAgreement(String id, String reason) async {
    final agreement = await getAgreementDetails(id);
    if (agreement != null) {
      final updated = agreement.copyWith(
        status: AgreementStatus.cancelled,
        cancellationReason: reason,
      );
      await updateAgreement(updated);
    }
  }

  @override
  Future<void> requestModification(String id, String notes) async {
    final agreement = await getAgreementDetails(id);
    if (agreement != null) {
      final updated = agreement.copyWith(
        version: '1.1',
        lastUpdated: DateTime.now().toString().split(' ')[0],
      );
      await updateAgreement(updated);
    }
  }

  @override
  Future<void> uploadContractDocument(String id, String type, String name, String url) async {
    final agreement = await getAgreementDetails(id);
    if (agreement != null) {
      final docs = List<AgreementDocument>.from(agreement.documents);
      docs.add(AgreementDocument(
        id: 'DOC-${DateTime.now().millisecondsSinceEpoch}',
        name: name,
        type: type,
        url: url,
        size: '١.٥ ميجابايت',
        version: 1,
        uploadedAt: DateTime.now().toString().split(' ')[0],
      ));
      final updated = agreement.copyWith(documents: docs);
      await updateAgreement(updated);
    }
  }
}

@riverpod
AgreementsRepository agreementsRepository(AgreementsRepositoryRef ref) {
  return AgreementsRepositoryImpl();
}


