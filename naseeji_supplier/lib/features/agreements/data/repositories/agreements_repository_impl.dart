import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/agreement_model.dart';
import '../../domain/repositories/agreements_repository.dart';

part 'agreements_repository_impl.g.dart';

class AgreementsRepositoryImpl implements AgreementsRepository {
  final List<B2BAgreement> _mockAgreements = [
    B2BAgreement(
      id: 'AG-9022',
      orderNumber: 'ORD-9022',
      rfqNumber: 'RFQ-8820',
      createdDate: '2026-07-04',
      lastUpdated: '2026-07-05',
      version: '1.0',
      type: 'اتفاقية توريد خامات إنتاج',
      expirationDate: '2026-12-31',
      status: AgreementStatus.pendingApproval,
      supplierInfo: const SupplierInfo(
        logoText: 'MS',
        logoBgColorValue: 0xFF0040E0,
        companyName: 'شركة النسيج الممتاز المحدودة',
        supplierName: 'مورد نسيجي',
        phone: '+٩٦٦ ٥٠ ١٢٣ ٤٥٦٧',
        email: 'supplier@naseeji.com',
        address: 'المنطقة الصناعية الثانية، الرياض، SA',
        rating: 4.8,
        verified: true,
      ),
      factoryInfo: const FactoryInfo(
        logoText: 'RC',
        logoBgColorValue: 0xFF006B5F,
        factoryName: 'مصنع الرياض للملابس الجاهزة',
        contactPerson: 'المهندس أحمد مصطفى',
        phone: '+٩٦٦ ٥٥ ٧٦٥ ٤٣٢١',
        email: 'factory.riyadh@gmail.com',
        address: 'المنطقة الصناعية الأولى، الرياض، SA',
        rating: 4.5,
      ),
      product: const AgreementProduct(
        imageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
        name: 'قماش قطن ١٠٠٪ فاخر للثياب الرجالية',
        sku: 'FAB-COT-0922',
        category: 'أقمشة صيفية',
        specifications: 'الوزن: ١٣0 جم/متر مربع • الطول: ٥٠ متر لفة • اللون: أبيض لؤلؤي',
        countryOfOrigin: 'اليابان',
        quantity: 5000,
        unit: 'لفة',
        packagingDetails: 'مغلف بأكياس بلاستيكية مقاومة للرطوبة ومرتبة على منصات خشبية معقمة.',
      ),
      pricing: const AgreementPricing(
        originalPrice: 15.0,
        negotiatedPrice: 12.5,
        finalPrice: 12.0,
        discount: 1500.0,
        tax: 9000.0,
        shippingCost: 250.0,
        extraFees: 0.0,
        grandTotal: 67750.0,
        currency: 'ر.س',
      ),
      paymentTerms: const AgreementPaymentTerms(
        method: 'حوالة بنكية B2B المعتمدة بنسيجي',
        advancePayment: 20000.0,
        remainingBalance: 47750.0,
        paymentSchedule: '٣٠٪ دفعة مقدمة قبل الإنتاج و ٧٠٪ بعد تأكيد مطابقة الجودة والاستلام.',
        paymentStatus: 'في انتظار الموافقة وتفعيل الضمان المالي',
        releaseConditions: 'موافقة المصنع الكاملة بعد الاستلام الفحص خلو الشحنة من تلفيات الترانزيت.',
        settlementTime: 'خلال ٢ يوم عمل من الفسح المالي التلقائي.',
      ),
      deliveryTerms: const AgreementDeliveryTerms(
        preparationTime: '١٠ أيام عمل من التوقيع',
        deliveryDate: '2026-07-20',
        deliveryAddress: 'مستودع مصنع الرياض - البوابة اللوجستية رقم ٤، الرياض، SA',
        shippingCompany: 'أرامكس Aramex',
        shipmentMethod: 'شحن بري سريع ومؤمن',
        trackingNumber: '',
        warehouse: 'مستودع الخامات المركزي الرئيسي للمشتري',
      ),
      conditions: const AgreementConditions(
        warranty: 'ضمان كامل ضد العيوب المصنعية والخيوط المفكوكة لمدة ٦ أشهر من الاستلام.',
        qualityRequirements: 'مستوى الجودة مقبول بالكامل وفقاً لعينة الاعتماد الموقعة مسبقاً بموجب RFQ.',
        inspectionRequirements: 'يحق للمشتري إرسال مندوب فحص جودة قبل تفريغ الشاحنات بالكامل.',
        cancellationPolicy: 'في حال الإلغاء بعد بدء الإنتاج الفعلي، يتم حجز مبلغ الدفعة المقدمة بالكامل.',
        penaltyClauses: 'غرامة تأخير بقيمة ٠.٥٪ يومياً من إجمالي قيمة العقد بحد أقصى ١٠٪.',
        additionalNotes: 'أي تعديلات على الفاتورة تتطلب إصدار نسخة جديدة من العقد وتوقيع الطرفين.',
      ),
      timeline: [
        const AgreementTimelineStep(
          date: '2026-07-04',
          time: '09:00 ص',
          user: 'المشتري (مصنع الرياض)',
          attachments: ['طلب_الشراء_8820.pdf'],
          status: 'استلام RFQ والمفاوضات',
          notes: 'بدء الاتفاق الأولي وتحديد كمية ٥٠٠٠ لفة خامات.',
        ),
        const AgreementTimelineStep(
          date: '2026-07-04',
          time: '02:00 م',
          user: 'المورد (مورد نسيجي)',
          attachments: ['Quotation_Rev1.pdf'],
          status: 'إرسال عرض الأسعار',
          notes: 'تقديم تسعير بـ ١٥ ر.س مع اقتراح طريقة الشحن البري.',
        ),
        const AgreementTimelineStep(
          date: '2026-07-05',
          time: '11:00 ص',
          user: 'النظام نسيجي الموحد',
          attachments: ['Draft_Contract_9022.pdf'],
          status: 'إنشاء مسودة الاتفاقية والنسخة الأولى',
          notes: 'تم توليد مسودة الاتفاقية وجاري مراجعة المورد لإبداء الموافقة النهائية.',
        ),
      ],
      history: [
        const AgreementHistoryRecord(
          timestamp: '2026-07-05 11:00 ص',
          user: 'النظام المالي الموحد',
          action: 'توليد مسودة العقد',
          reason: 'اعتماد عرض السعر النهائي والمفاوضات رقم ٣.',
          versionNumber: '1.0',
        ),
      ],
      documents: [
        const AgreementDocument(
          name: 'Supply_Agreement_Draft_v1.pdf',
          type: 'مسودة العقد الأساسي',
          url: 'https://naseeji.com/docs/contract_draft_v1.pdf',
          version: 1,
          uploadedAt: '2026-07-05',
        ),
        const AgreementDocument(
          name: 'Factory_Quotation_Approved.pdf',
          type: 'عرض السعر المعتمد',
          url: 'https://naseeji.com/docs/quote_approved.pdf',
          version: 1,
          uploadedAt: '2026-07-04',
        ),
      ],
      rfqData: const ComparisonData(
        unitPrice: '15.00 ر.س',
        quantity: '5,000 لفة',
        moq: '1,000 لفة',
        deliveryTime: '١٥ يوم عمل',
        paymentMethod: 'حوالة بنكية',
        shippingTerms: 'شحن عادي غير مؤمن',
        taxes: '١٥٪ ضريبة القيمة المضافة',
        discount: '٠.٠٠ ر.س',
        validity: '٧ أيام عمل',
        preparationTime: '١٢ يوم عمل',
      ),
      firstQuoteData: const ComparisonData(
        unitPrice: '15.00 ر.س',
        quantity: '5,000 لفة',
        moq: '2,000 لفة',
        deliveryTime: '١٢ يوم عمل',
        paymentMethod: 'حوالة نسيجي المضمونة',
        shippingTerms: 'شحن بري سريع مؤمن',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '٥٠٠.٠٠ ر.س خصم ولاء',
        validity: '١٠ أيام عمل',
        preparationTime: '١٠ أيام عمل',
      ),
      counterOfferData: const ComparisonData(
        unitPrice: '12.50 ر.س',
        quantity: '5,000 لفة',
        moq: '2,000 لفة',
        deliveryTime: '١٠ أيام عمل',
        paymentMethod: '٣٠٪ دفعة مقدمة و ٧٠٪ بعد الاستلام',
        shippingTerms: 'شحن بري سريع مؤمن',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '١٠٠٠.٠٠ ر.س خصم تسوية',
        validity: '١٠ أيام عمل',
        preparationTime: '١٠ أيام عمل',
      ),
      finalAgreementData: const ComparisonData(
        unitPrice: '12.00 ر.س',
        quantity: '5,000 لفة',
        moq: '2,000 لفة',
        deliveryTime: '١٠ أيام عمل',
        paymentMethod: '٣٠٪ دفعة مقدمة و ٧٠٪ حوالة نسيجي المضمونة',
        shippingTerms: 'شحن بري سريع أرامكس مؤمن بالكامل',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '١٥٠٠.٠٠ ر.س إجمالي الخصومات',
        validity: 'ساري المفعول',
        preparationTime: '١٠ أيام عمل',
      ),
      savingsAmount: 16500.0,
      savingsDifference: 'وفر للمشتري: ١٥٪ من إجمالي القيمة المقترحة الأولى',
      negotiationSuccessPercent: 88.5,
    ),
    B2BAgreement(
      id: 'AG-8910',
      orderNumber: 'ORD-8910',
      rfqNumber: 'RFQ-8794',
      createdDate: '2026-06-25',
      lastUpdated: '2026-06-26',
      version: '1.2',
      type: 'اتفاقية توريد خيوط الصوف',
      expirationDate: '2026-11-30',
      status: AgreementStatus.active,
      supplierInfo: const SupplierInfo(
        logoText: 'MS',
        logoBgColorValue: 0xFF0040E0,
        companyName: 'شركة النسيج الممتاز المحدودة',
        supplierName: 'مورد نسيجي',
        phone: '+٩٦٦ ٥٠ ١٢٣ ٤٥٦٧',
        email: 'supplier@naseeji.com',
        address: 'المنطقة الصناعية الثانية، الرياض، SA',
        rating: 4.8,
        verified: true,
      ),
      factoryInfo: const FactoryInfo(
        logoText: 'UF',
        logoBgColorValue: 0xFF16A34A,
        factoryName: 'شركة الأزياء الموحدة',
        contactPerson: 'الأستاذ خالد السالم',
        phone: '+٩٦٦ ٥٦ ٩٨٧ ٦٥٤٣',
        email: 'k.salam@uniform.com',
        address: 'حي السليمانية، جدة، SA',
        rating: 4.6,
      ),
      product: const AgreementProduct(
        imageUrl: 'https://images.unsplash.com/photo-1530087964557-3aa5c55537e2?auto=format&fit=crop&w=300&q=80',
        name: 'خيوط الصوف الإنجليزي المعالج ضد الرطوبة',
        sku: 'YRN-WOL-890',
        category: 'خيوط وغزل',
        specifications: 'السمك: ٣/٢٤ • الوزن الكلي للشحنة: ٣٨٠٠ كجم • اللون: كحلي داكن',
        countryOfOrigin: 'المملكة المتحدة',
        quantity: 12500,
        unit: 'كجم',
        packagingDetails: 'صناديق كرتونية مبطنة بألواح خشبية لامتصاص الصدمات وحماية الخيوط.',
      ),
      pricing: const AgreementPricing(
        originalPrice: 42.00,
        negotiatedPrice: 40.00,
        finalPrice: 38.50,
        discount: 5000.0,
        tax: 72187.5,
        shippingCost: 850.0,
        extraFees: 120.0,
        grandTotal: 554407.5,
        currency: 'ر.س',
      ),
      paymentTerms: const AgreementPaymentTerms(
        method: 'حوالة بنكية ومستندات ضمان نسيجي',
        advancePayment: 150000.0,
        remainingBalance: 404407.5,
        paymentSchedule: 'دفع ٣٠٪ دفعة تشغيل مقدمة و ٧٠٪ رصيد متبقي يتم الإفراج عنه فورا بعد تأكيد استلام المصنع.',
        paymentStatus: 'تم تفعيل الضمان المالي والدفعة المقدمة قيد الحجز',
        releaseConditions: 'توقيع إيصال الاستلام من المشتري في مستودع جدة.',
        settlementTime: 'مباشرة خلال ٢٤ ساعة من الفسح المالي.',
      ),
      deliveryTerms: const AgreementDeliveryTerms(
        preparationTime: '١٥ يوم عمل',
        deliveryDate: '2026-07-10',
        deliveryAddress: 'مستودعات جدة الرئيسية - ميناء جدة الإسلامي - رصيف ٥، SA',
        shippingCompany: 'دي إتش إل DHL',
        shipmentMethod: 'شحن سريع دولي DHL Express',
        trackingNumber: 'DHL-8877221199',
        warehouse: 'مستودع جدة المركزي للبضائع المستوردة',
      ),
      conditions: const AgreementConditions(
        warranty: 'ضمان سلامة خيوط الغزل من التعفن والرطوبة لمدة سنة من تاريخ الاستلام.',
        qualityRequirements: 'مطابق بالكامل لشهادة الأيزو العالمية للمنسوجات.',
        inspectionRequirements: 'فحص جودة إلزامي من فريق تدقيق معتمد قبل مغادرة ميناء جدة.',
        cancellationPolicy: 'إلغاء العقد بعد توقيع النسخة النهائية يترتب عليه غرامة بقيمة ١٥٪ من إجمالي العقد.',
        penaltyClauses: 'خصم ٢٪ من إجمالي الفاتورة عن كل أسبوع تأخير في التوصيل.',
        additionalNotes: 'تلتزم شركة الشحن بتوفير حاويات مبردة للشحن الدولي لحماية الصوف.',
      ),
      timeline: [
        const AgreementTimelineStep(
          date: '2026-06-24',
          time: '10:00 ص',
          user: 'المشتري (شركة الأزياء)',
          attachments: [],
          status: 'إنشاء طلب RFQ',
          notes: 'بدء الاتفاق وتجهيز خيوط صوف كحلي لخطوط إنتاج المعاطف الشتوية.',
        ),
        const AgreementTimelineStep(
          date: '2026-06-25',
          time: '04:00 م',
          user: 'المورد (مورد نسيجي)',
          attachments: ['Invoice_Draft.pdf'],
          status: 'تقديم العرض والموافقة',
          notes: 'توقيع العرض ونسخة المسودة الأولى للاتفاقية وتثبيت السعر.',
        ),
        const AgreementTimelineStep(
          date: '2026-06-26',
          time: '09:00 ص',
          user: 'المشتري (شركة الأزياء)',
          attachments: ['Signed_Contract_DHL.pdf'],
          status: 'موافقة المصنع وتفعيل العقد',
          notes: 'تم التوقيع الرسمي وتفعيل الضمان المالي للشحنة ساري المفعول.',
        ),
      ],
      history: [
        const AgreementHistoryRecord(
          timestamp: '2026-06-25 04:00 م',
          user: 'المورد نسيجي',
          action: 'تعديل شروط التوصيل والدفع',
          reason: 'تضمين شحن مبرد DHL بدلا من الشحن العادي.',
          versionNumber: '1.1',
        ),
        const AgreementHistoryRecord(
          timestamp: '2026-06-26 09:00 ص',
          user: 'شركة الأزياء الموحدة',
          action: 'توقيع واعتماد الاتفاقية النهائية',
          reason: 'موافقة الطرفين وتأكيد الحجز المالي.',
          versionNumber: '1.2',
        ),
      ],
      documents: [
        const AgreementDocument(
          name: 'Supply_Agreement_Final_8910.pdf',
          type: 'العقد المالي النهائي الموقع',
          url: 'https://naseeji.com/docs/contract_final_8910.pdf',
          version: 2,
          uploadedAt: '2026-06-26',
        ),
        const AgreementDocument(
          name: 'DHL_Shipping_Specs.pdf',
          type: 'مواصفات الشحن والتأمين المبرد',
          url: 'https://naseeji.com/docs/dhl_specs.pdf',
          version: 1,
          uploadedAt: '2026-06-25',
        ),
      ],
      rfqData: const ComparisonData(
        unitPrice: '42.00 ر.س',
        quantity: '12,500 كجم',
        moq: '5,000 كجم',
        deliveryTime: '٢٠ يوم عمل',
        paymentMethod: 'حوالة بنكية عادي',
        shippingTerms: 'شحن بحري عادي',
        taxes: '١٥٪ ضريبة القيمة المضافة',
        discount: '٠.٠٠ ر.س',
        validity: '٥ أيام عمل',
        preparationTime: '١٨ يوم عمل',
      ),
      firstQuoteData: const ComparisonData(
        unitPrice: '42.00 ر.س',
        quantity: '12,500 كجم',
        moq: '5,000 كجم',
        deliveryTime: '١٥ يوم عمل',
        paymentMethod: 'حوالة نسيجي المضمونة',
        shippingTerms: 'شحن مبرد DHL سريع ومؤمن',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '١٥٠٠.٠٠ ر.س خصم توريد',
        validity: '٧ أيام عمل',
        preparationTime: '١٥ يوم عمل',
      ),
      counterOfferData: const ComparisonData(
        unitPrice: '40.00 ر.س',
        quantity: '12,500 كجم',
        moq: '5,000 كجم',
        deliveryTime: '١٥ يوم عمل',
        paymentMethod: '٣٠٪ دفعة مقدمة و ٧٠٪ بعد الاستلام',
        shippingTerms: 'شحن مبرد DHL سريع ومؤمن',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '٣٠٠٠.٠٠ ر.س خصم تشغيل',
        validity: '٧ أيام عمل',
        preparationTime: '١٥ يوم عمل',
      ),
      finalAgreementData: const ComparisonData(
        unitPrice: '38.50 ر.س',
        quantity: '12,500 كجم',
        moq: '5,000 كجم',
        deliveryTime: '١٥ يوم عمل',
        paymentMethod: '٣٠٪ دفعة مقدمة و ٧٠٪ حوالة نسيجي البنكية المؤمنة',
        shippingTerms: 'شحن جوي مبرد DHL سريع ومؤمن بالكامل',
        taxes: 'مشمولة بالكامل بالضريبة',
        discount: '٥٠٠٠.٠٠ ر.س إجمالي الخصومات والتعويضات',
        validity: 'ساري المفعول',
        preparationTime: '١٥ يوم عمل',
      ),
      savingsAmount: 43750.0,
      savingsDifference: 'وفر للمشتري: ٨.٣٪ من القيمة المقترحة الأولى لشراء خيوط الصوف',
      negotiationSuccessPercent: 92.0,
    ),
  ];

  @override
  Future<List<B2BAgreement>> getAgreements() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return List.from(_mockAgreements);
  }

  @override
  Future<B2BAgreement?> getAgreementDetails(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      return _mockAgreements[index];
    }
    return null;
  }

  @override
  Future<void> approveAgreement(String id) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = _mockAgreements[index];
      
      final DateTime now = DateTime.now();
      final String timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';
      final String dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final newTimelineStep = AgreementTimelineStep(
        date: dateStr,
        time: timeStr,
        user: 'المورد (مورد نسيجي)',
        attachments: const [],
        status: 'موافقة المورد وتأكيد العقد',
        notes: 'تمت موافقة المورد نسيجي على بنود الاتفاقية وجاري مراجعة المشتري لتفعيلها.',
      );

      final newHistoryRecord = AgreementHistoryRecord(
        timestamp: '$dateStr $timeStr',
        user: 'المورد نسيجي',
        action: 'الموافقة على بنود الاتفاقية',
        reason: 'توقيع العقد من جهة المورد.',
        versionNumber: current.version,
      );

      _mockAgreements[index] = current.copyWith(
        status: AgreementStatus.active,
        lastUpdated: dateStr,
        timeline: List.from(current.timeline)..add(newTimelineStep),
        history: List.from(current.history)..add(newHistoryRecord),
      );
    }
  }

  @override
  Future<void> rejectAgreement(String id, String reason) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = _mockAgreements[index];

      final DateTime now = DateTime.now();
      final String timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';
      final String dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final newTimelineStep = AgreementTimelineStep(
        date: dateStr,
        time: timeStr,
        user: 'المورد (مورد نسيجي)',
        attachments: const [],
        status: 'إلغاء الاتفاقية',
        notes: 'تم رفض التوقيع من المورد للسبب التالي: $reason',
      );

      final newHistoryRecord = AgreementHistoryRecord(
        timestamp: '$dateStr $timeStr',
        user: 'المورد نسيجي',
        action: 'رفض وتجميد الاتفاقية',
        reason: reason,
        versionNumber: current.version,
      );

      _mockAgreements[index] = current.copyWith(
        status: AgreementStatus.cancelled,
        cancellationReason: reason,
        lastUpdated: dateStr,
        timeline: List.from(current.timeline)..add(newTimelineStep),
        history: List.from(current.history)..add(newHistoryRecord),
      );
    }
  }

  @override
  Future<void> requestModification(String id, String notes) async {
    await Future.delayed(const Duration(milliseconds: 300));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = _mockAgreements[index];

      final DateTime now = DateTime.now();
      final String timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';
      final String dateStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

      final double currentVer = double.parse(current.version);
      final String nextVer = (currentVer + 0.1).toStringAsFixed(1);

      final newTimelineStep = AgreementTimelineStep(
        date: dateStr,
        time: timeStr,
        user: 'المورد (مورد نسيجي)',
        attachments: const [],
        status: 'طلب تعديل الاتفاقية',
        notes: 'طلب المورد إرجاع العقد للتعديل ومفاوضات بنود إضافية. الملاحظات: $notes',
      );

      final newHistoryRecord = AgreementHistoryRecord(
        timestamp: '$dateStr $timeStr',
        user: 'المورد نسيجي',
        action: 'طلب تعديل بنود العقد وتحرير نسخة جديدة',
        reason: notes,
        versionNumber: nextVer,
      );

      _mockAgreements[index] = current.copyWith(
        version: nextVer,
        lastUpdated: dateStr,
        timeline: List.from(current.timeline)..add(newTimelineStep),
        history: List.from(current.history)..add(newHistoryRecord),
      );
    }
  }

  @override
  Future<void> uploadContractDocument(String id, String type, String name, String url) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final index = _mockAgreements.indexWhere((a) => a.id == id);
    if (index != -1) {
      final current = _mockAgreements[index];
      final List<AgreementDocument> updatedDocs = List.from(current.documents);

      final DateTime now = DateTime.now();
      final String todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
      final String timeStr = '${now.hour}:${now.minute.toString().padLeft(2, '0')} ${now.hour >= 12 ? "م" : "ص"}';

      final docIndex = current.documents.indexWhere((doc) => doc.type == type);

      if (docIndex != -1) {
        final existing = current.documents[docIndex];
        updatedDocs[docIndex] = existing.copyWith(
          name: name,
          url: url,
          version: existing.version + 1,
          uploadedAt: todayStr,
        );
      } else {
        updatedDocs.add(AgreementDocument(
          name: name,
          type: type,
          url: url,
          version: 1,
          uploadedAt: todayStr,
        ));
      }

      final newTimelineStep = AgreementTimelineStep(
        date: todayStr,
        time: timeStr,
        user: 'المورد (مورد نسيجي)',
        attachments: [name],
        status: 'إرفاق وثيقة العقد المحدثة',
        notes: 'تم رفع مستند الشراكة: $name كنسخة معتمدة للنوع: $type',
      );

      _mockAgreements[index] = current.copyWith(
        documents: updatedDocs,
        timeline: List.from(current.timeline)..add(newTimelineStep),
      );
    }
  }
}

@riverpod
AgreementsRepository agreementsRepository(AgreementsRepositoryRef ref) {
  return AgreementsRepositoryImpl();
}
