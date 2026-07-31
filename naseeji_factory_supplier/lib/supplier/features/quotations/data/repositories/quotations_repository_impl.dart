import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../agreements/domain/entities/agreement_model.dart'; // For FactoryInfo
import '../../domain/entities/quotation_model.dart';
import '../../domain/repositories/quotations_repository.dart';

part 'quotations_repository_impl.g.dart';

class QuotationsRepositoryImpl implements QuotationsRepository {
  final List<QuotationModel> _mockQuotations = [
    QuotationModel(
      id: 'QT-8821',
      rfqNumber: 'RFQ-8820',
      version: '1.0',
      createdDate: '2026-07-06',
      lastUpdated: '2026-07-06',
      expirationDate: '2026-07-13',
      status: QuotationStatus.draft,
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
      productName: 'قماش قطن ١٠٠٪ فاخر للثياب الرجالية',
      productSku: 'FAB-COT-0922',
      productCategory: 'أقمشة صيفية',
      productMaterial: 'قطن ١٠٠٪ فاخر للثياب الرجالية',
      productSpecifications: 'الوزن: ١٣0 جم/متر مربع • الطول: ٥٠ متر لفة • اللون: أبيض لؤلؤي',
      countryOfOrigin: 'اليابان',
      productImageUrl: 'https://images.unsplash.com/photo-1586528116311-ad8dd3c8310d?auto=format&fit=crop&w=300&q=80',
      quantity: 5000,
      unit: 'لفة',
      moq: 100,
      packagingDetails: 'مغلف بأكياس بلاستيكية مقاومة للرطوبة ومرتبة على منصات خشبية معقمة.',
      originalRequestedPrice: 15.0,
      supplierUnitPrice: 12.5,
      discount: 1500.0,
      taxes: 9000.0,
      shippingCost: 250.0,
      additionalCharges: 0.0,
      grandTotal: 67750.0,
      currency: 'جنيه',
      expectedProfitMargin: 25.0,
      paymentMethod: 'Bank Transfer',
      advancePayment: 20000.0,
      remainingBalance: 47750.0,
      creditPeriod: '٣٠ يوماً من الاستلام',
      settlementTime: '٢ يوم عمل',
      releaseConditions: 'موافقة المصنع الكاملة بعد الاستلام الفحص خلو الشحنة من التلفيات.',
      preparationTime: '١٠ أيام عمل',
      estimatedDelivery: '2026-07-20',
      deliveryLocation: 'مستودع مصنع الرياض - البوابة اللوجستية ٤',
      shippingMethod: 'شحن بري سريع',
      shippingCompany: 'أرامكس Aramex',
      incoterms: 'DDP',
      timeline: [
        const QuotationTimelineStep(
          title: 'استلام طلب الأسعار (RFQ)',
          date: '2026-07-06',
          time: '09:00 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
          notes: 'تم استقبال طلب التسعير رقم RFQ-8820 بنجاح.',
        ),
        const QuotationTimelineStep(
          title: 'إنشاء مسودة عرض السعر',
          date: '2026-07-06',
          time: '11:15 ص',
          responsibleUser: 'مورد نسيجي',
          status: 'تحت المراجعة',
          notes: 'تمت تعبئة بيانات المسودة تمهيداً للإرسال.',
        ),
      ],
    ),
    QuotationModel(
      id: 'QT-8822',
      rfqNumber: 'RFQ-8821',
      version: '1.0',
      createdDate: '2026-07-05',
      lastUpdated: '2026-07-05',
      expirationDate: '2026-07-12',
      status: QuotationStatus.sent,
      factoryInfo: const FactoryInfo(
        logoText: 'JK',
        logoBgColorValue: 0xFF8F00FF,
        factoryName: 'مصنع جدة للكسوة والأثواب',
        contactPerson: 'المهندس وليد خالد',
        phone: '+٩٦٦ ٥٦ ١١١ ٢٢٢٢',
        email: 'jeddah.apparel@gmail.com',
        address: 'المنطقة الصناعية الثالثة، جدة، SA',
        rating: 4.2,
      ),
      productName: 'قماش حرير هندي طبيعي مطرز',
      productSku: 'FAB-SILK-003',
      productCategory: 'أقمشة فاخرة',
      productMaterial: 'حرير هندي طبيعي ١٠٠٪ مطرز يدوياً بأسلاك فضية',
      productSpecifications: 'العرض: ٤٤ إنش • الوزن: ٨٠ جم/متر • التصميم: نقوش هندسية كلاسيكية',
      countryOfOrigin: 'الهند',
      productImageUrl: 'https://images.unsplash.com/photo-1606744824163-985d376605aa?auto=format&fit=crop&w=300&q=80',
      quantity: 1200,
      unit: 'متر',
      moq: 50,
      packagingDetails: 'ملفوف على كرتون مقوى وداخل صناديق خشبية مبطنة بالورق الخالي من الأحماض.',
      originalRequestedPrice: 85.0,
      supplierUnitPrice: 80.0,
      discount: 2000.0,
      taxes: 14100.0,
      shippingCost: 400.0,
      additionalCharges: 100.0,
      grandTotal: 108600.0,
      currency: 'جنيه',
      expectedProfitMargin: 30.0,
      paymentMethod: 'Letter of Credit',
      advancePayment: 50000.0,
      remainingBalance: 58600.0,
      creditPeriod: 'خطاب اعتماد بنكي غير قابل للإلغاء',
      settlementTime: '٥ أيام عمل',
      releaseConditions: 'تقديم بوليصة الشحن وشهادة المنشأ والفاتورة المصدقة للبنك الفاتح للاعتماد.',
      preparationTime: '١٥ يوم عمل',
      estimatedDelivery: '2026-07-25',
      deliveryLocation: 'ميناء جدة الإسلامي - قسم الجمارك',
      shippingMethod: 'شحن بحري حاويات LCL',
      shippingCompany: 'ميرسك Maersk',
      incoterms: 'CIF',
      timeline: [
        const QuotationTimelineStep(
          title: 'استلام طلب الأسعار (RFQ)',
          date: '2026-07-05',
          time: '10:00 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'إنشاء وإرسال عرض السعر v1.0',
          date: '2026-07-05',
          time: '04:30 م',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
          notes: 'تم تسليم العرض بنجاح وبانتظار رد المصنع.',
        ),
      ],
    ),
    QuotationModel(
      id: 'QT-8823',
      rfqNumber: 'RFQ-8822',
      version: '2.0',
      createdDate: '2026-07-03',
      lastUpdated: '2026-07-05',
      expirationDate: '2026-07-15',
      status: QuotationStatus.underNegotiation,
      hasNegotiationBadge: true,
      factoryInfo: const FactoryInfo(
        logoText: 'DF',
        logoBgColorValue: 0xFFFF5722,
        factoryName: 'مصنع الشرق للمنسوجات الفاخرة',
        contactPerson: 'الأستاذ فهد الدوسري',
        phone: '+٩٦٦ ٥٤ ٩٩٩ ٨٨٨٨',
        email: 'info@orientaltextiles.com',
        address: 'المنطقة الصناعية، الدمام، SA',
        rating: 4.7,
      ),
      productName: 'أقمشة صوف كشميري للسترات الباردة',
      productSku: 'FAB-WOOL-788',
      productCategory: 'أقمشة شتوية',
      productMaterial: 'صوف كشميري طبيعي ٩٠٪ مع نيلون ١٠٪ للمتانة',
      productSpecifications: 'الوزن: ٣٥٠ جم/متر • اللون: كحلي ملكي ومارون داكن',
      countryOfOrigin: 'منغوليا',
      productImageUrl: 'https://images.unsplash.com/photo-1544022613-e87ca75a784a?auto=format&fit=crop&w=300&q=80',
      quantity: 3000,
      unit: 'لفة',
      moq: 200,
      packagingDetails: 'مغلف بالخيش الطبيعي المقاوم للرطوبة وتوضع في حاوية جافة.',
      originalRequestedPrice: 120.0,
      supplierUnitPrice: 105.0,
      discount: 5000.0,
      taxes: 46500.0,
      shippingCost: 1500.0,
      additionalCharges: 0.0,
      grandTotal: 358000.0,
      currency: 'جنيه',
      expectedProfitMargin: 22.0,
      paymentMethod: 'Bank Transfer',
      advancePayment: 100000.0,
      remainingBalance: 258000.0,
      creditPeriod: '٤٥ يوماً من شحن البضائع',
      settlementTime: '٣ أيام عمل',
      releaseConditions: 'موافقة جودة المنسوجات من جهة فحص مستقلة SGS.',
      preparationTime: '٢٠ يوم عمل',
      estimatedDelivery: '2026-08-05',
      deliveryLocation: 'مستودعات مصنع الشرق، الدمام',
      shippingMethod: 'شحن بري مؤمن بالكامل',
      shippingCompany: 'دي إتش إل DHL',
      incoterms: 'DAP',
      revisions: [
        const QuotationRevisionModel(
          version: 'v1.0',
          supplierPrice: 115.0,
          factoryCounterOffer: 90.0,
          priceDifference: 25.0,
          reason: 'المصنع يرى أن السعر الأول مرتفع وبحاجة إلى خصم كميات.',
          createdDate: '2026-07-03',
          negotiatedBy: 'المهندس وليد (المشتري)',
          status: 'مرفوض وبانتظار رد المورد',
        ),
        const QuotationRevisionModel(
          version: 'v2.0',
          supplierPrice: 105.0,
          factoryCounterOffer: 100.0,
          priceDifference: 5.0,
          reason: 'المورد قدم تنازلاً إضافياً بتخفيض السعر إلى ١٠٥ جنيه مع زيادة الخصم المباشر.',
          createdDate: '2026-07-05',
          negotiatedBy: 'مورد نسيجي',
          status: 'تحت المفاوضات النشطة',
        ),
      ],
      timeline: [
        const QuotationTimelineStep(
          title: 'استلام طلب الأسعار (RFQ)',
          date: '2026-07-03',
          time: '08:00 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'تقديم عرض سعر v1.0 بقيمة ١١٥ جنيه للوحدة',
          date: '2026-07-03',
          time: '01:00 م',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'استلام عرض مقابل (Counter Offer) من المصنع بقيمة ٩٠ جنيه',
          date: '2026-07-04',
          time: '10:30 ص',
          responsibleUser: 'فهد الدوسري (مصنع الشرق)',
          status: 'مكتمل',
          notes: 'نرجو مراجعة الأسعار وتخفيضها لنتمكن من اعتماد العرض للربع الثالث.',
        ),
        const QuotationTimelineStep(
          title: 'تقديم عرض محدث v2.0 بقيمة ١٠٥ جنيه للوحدة',
          date: '2026-07-05',
          time: '03:15 م',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
          notes: 'قدمنا هذا السعر كأقصى تخفيض ممكن مع الحفاظ على معايير الجودة العالية.',
        ),
      ],
    ),
    QuotationModel(
      id: 'QT-8824',
      rfqNumber: 'RFQ-8823',
      orderNumber: 'ORD-9055',
      version: '3.0',
      createdDate: '2026-06-28',
      lastUpdated: '2026-07-04',
      expirationDate: '2026-07-18',
      status: QuotationStatus.accepted,
      factoryInfo: const FactoryInfo(
        logoText: 'NF',
        logoBgColorValue: 0xFFE91E63,
        factoryName: 'مصنع نخبة الغزل والنسيج الوطني',
        contactPerson: 'المهندس سمير عبد الله',
        phone: '+٩٦٦ ٥٠ ٤٤٤ ٣٣٣٣',
        email: 'elite.yarns@outlook.com',
        address: 'المدينة الصناعية الثانية، مكة المكرمة، SA',
        rating: 4.9,
      ),
      productName: 'بكرات خيوط بوليستر عالية القوة',
      productSku: 'YRN-POLY-900',
      productCategory: 'خيوط صناعية',
      productMaterial: 'بوليستر ١٠٠٪ معالج لمقاومة الشد والحرارة الاحتكاكية',
      productSpecifications: 'المقاس: 75D/2 • الوزن الكلي للبكرة: ١.٢ كجم • قوة الشد: ٤.٥ جم/دنير',
      countryOfOrigin: 'كوريا الجنوبية',
      productImageUrl: 'https://images.unsplash.com/photo-1605810230434-7631ac76ec81?auto=format&fit=crop&w=300&q=80',
      quantity: 15000,
      unit: 'بكرة',
      moq: 1000,
      packagingDetails: '٦ بكرات في صندوق كرتوني مقوى موضوع على منصات خشبية مغلفة بالبلاستيك بالكامل.',
      originalRequestedPrice: 8.5,
      supplierUnitPrice: 7.2,
      discount: 3000.0,
      taxes: 15750.0,
      shippingCost: 800.0,
      additionalCharges: 0.0,
      grandTotal: 121550.0,
      currency: 'جنيه',
      expectedProfitMargin: 20.0,
      paymentMethod: 'Bank Transfer',
      advancePayment: 36465.0,
      remainingBalance: 85085.0,
      creditPeriod: '٣٠ يوماً بعد الشحن الفعلي',
      settlementTime: '٢ يوم عمل',
      releaseConditions: 'تأكيد شحن الحاوية وتسليم بوليسة الشحن عبر منصة نسيجي.',
      preparationTime: '٨ أيام عمل',
      estimatedDelivery: '2026-07-12',
      deliveryLocation: 'مستودع مصنع النخبة، مكة المكرمة',
      shippingMethod: 'شحن بري مباشر شاحنات مبردة ورطوبة منخفضة',
      shippingCompany: 'DHL Freight',
      incoterms: 'DDP',
      revisions: [
        const QuotationRevisionModel(
          version: 'v1.0',
          supplierPrice: 8.0,
          factoryCounterOffer: 6.5,
          priceDifference: 1.5,
          reason: 'المصنع طلب تسعيراً أقل نظراً للكمية الكبيرة المستهدفة (١٥ ألف بكرة).',
          createdDate: '2026-06-28',
          negotiatedBy: 'سمير عبد الله',
          status: 'مرفوض',
        ),
        const QuotationRevisionModel(
          version: 'v2.0',
          supplierPrice: 7.5,
          factoryCounterOffer: 7.0,
          priceDifference: 0.5,
          reason: 'تقارب في السعر وعرضنا تخفيض القيمة مع تحمل تكاليف التأمين.',
          createdDate: '2026-07-02',
          negotiatedBy: 'مورد نسيجي',
          status: 'مرفوض',
        ),
        const QuotationRevisionModel(
          version: 'v3.0',
          supplierPrice: 7.2,
          factoryCounterOffer: 7.2,
          priceDifference: 0.0,
          reason: 'تم الاتفاق النهائي على ٧.٢ جنيه للبكرة بعد مراجعة تكاليف الإنتاج والخدمات اللوجستية.',
          createdDate: '2026-07-04',
          negotiatedBy: 'مورد نسيجي والأستاذ سمير',
          status: 'مقبول ومعتمد',
        ),
      ],
      timeline: [
        const QuotationTimelineStep(
          title: 'RFQ Received',
          date: '2026-06-28',
          time: '09:00 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'Quotation Created v1.0',
          date: '2026-06-28',
          time: '11:00 ص',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'Negotiation Started & Counter Offer Received',
          date: '2026-06-30',
          time: '02:00 م',
          responsibleUser: 'سمير عبد الله',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'Revised Offer Sent v2.0',
          date: '2026-07-02',
          time: '10:00 ص',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'Final Offer Approved v3.0',
          date: '2026-07-04',
          time: '12:00 م',
          responsibleUser: 'سمير عبد الله',
          status: 'مكتمل',
          notes: 'تم قبول العرض والاتفاق نهائياً وبدء كتابة وثائق الاتفاقية.',
        ),
        const QuotationTimelineStep(
          title: 'Agreement Created ORD-9055',
          date: '2026-07-04',
          time: '04:15 م',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
          notes: 'تم نقل العرض تلقائياً ليصبح اتفاقية رسمية قيد التوقيع.',
        ),
      ],
    ),
    QuotationModel(
      id: 'QT-8825',
      rfqNumber: 'RFQ-8824',
      version: '1.0',
      createdDate: '2026-06-20',
      lastUpdated: '2026-06-24',
      expirationDate: '2026-07-04',
      status: QuotationStatus.rejected,
      rejectionReason: 'السعر النهائي خارج الميزانية المقررة للمشروع (الميزانية القصوى للمصنع كانت ٤٠ ألف جنيه).',
      factoryInfo: const FactoryInfo(
        logoText: 'TC',
        logoBgColorValue: 0xFF4CAF50,
        factoryName: 'مصنع المنسوجات التقنية المتقدمة',
        contactPerson: 'المهندس هاني زكي',
        phone: '+٩٦٦ ٥٠ ٥٥٥ ٦٦٦٦',
        email: 'tech.tex@advanced.com',
        address: 'منطقة التطوير التقني، الجبيل، SA',
        rating: 4.0,
      ),
      productName: 'نسيج كتان بلجيكي طبيعي مغسول',
      productSku: 'FAB-LINEN-99',
      productCategory: 'أقمشة طبيعية',
      productMaterial: 'كتان بلجيكي طبيعي مغسول بإنزيمات حيوية للنعومة',
      productSpecifications: 'العرض: ٥٨ إنش • الوزن: ٢١٠ جم/متر • اللون: بيج كتاني طبيعي',
      countryOfOrigin: 'بلجيكا',
      productImageUrl: 'https://images.unsplash.com/photo-1545048702-79362596cdc9?auto=format&fit=crop&w=300&q=80',
      quantity: 2000,
      unit: 'متر',
      moq: 300,
      packagingDetails: 'ملفوف على كرتون وحماية بولي إيثيلين مشدود ومقاوم للظروف المناخية القاسية.',
      originalRequestedPrice: 32.0,
      supplierUnitPrice: 26.5,
      discount: 1000.0,
      taxes: 7800.0,
      shippingCost: 500.0,
      additionalCharges: 0.0,
      grandTotal: 60300.0,
      currency: 'جنيه',
      expectedProfitMargin: 18.0,
      paymentMethod: 'Bank Transfer',
      advancePayment: 18000.0,
      remainingBalance: 42300.0,
      creditPeriod: '٣٠ يوماً من الاستلام',
      settlementTime: '٢ يوم عمل',
      releaseConditions: 'موافقة المشتري الفورية بعد التحقق الفني الفعلي.',
      preparationTime: '١٢ يوم عمل',
      estimatedDelivery: '2026-07-05',
      deliveryLocation: 'مستودع المنسوجات، الجبيل الصناعية',
      shippingMethod: 'شحن بري سريع ومغلق',
      shippingCompany: 'سمسا SMSA',
      incoterms: 'DDP',
      timeline: [
        const QuotationTimelineStep(
          title: 'استلام طلب الأسعار (RFQ)',
          date: '2026-06-20',
          time: '08:45 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'إرسال العرض v1.0',
          date: '2026-06-21',
          time: '11:00 ص',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'رفض العرض بالكامل من قبل المصنع',
          date: '2026-06-24',
          time: '02:30 م',
          responsibleUser: 'هاني زكي (مصنع المنسوجات التقنية)',
          status: 'مرفوض',
          notes: 'نأسف لرفض العرض نظراً لأن التكلفة الكلية تتعدى الميزانية المحددة بمقدار ٢٠ ألف جنيه ولم ينجح خفض السعر الكافي.',
        ),
      ],
    ),
    QuotationModel(
      id: 'QT-8826',
      rfqNumber: 'RFQ-8825',
      version: '1.0',
      createdDate: '2026-06-15',
      lastUpdated: '2026-06-15',
      expirationDate: '2026-06-22',
      status: QuotationStatus.expired,
      factoryInfo: const FactoryInfo(
        logoText: 'GF',
        logoBgColorValue: 0xFF607D8B,
        factoryName: 'مصنع الخليج للملابس التقليدية',
        contactPerson: 'المهندس صالح المهند',
        phone: '+٩٦٦ ٥٠ ٧٧٧ ٨٨٨٨',
        email: 'gulf.garments@outlook.com',
        address: 'المنطقة الحرة، الخبر، SA',
        rating: 4.1,
      ),
      productName: 'قماش كتان ممزوج ناعم',
      productSku: 'FAB-LIN-BLD',
      productCategory: 'أقمشة مختلطة',
      productMaterial: 'كتان ٥٥٪ مع قطن ٤٥٪ للنعومة الإضافية وسهولة الكي',
      productSpecifications: 'العرض: ٥٦ إنش • الوزن: ١٦٠ جم/متر • اللون: بيج رمادي وأوف وايت',
      countryOfOrigin: 'الصين',
      productImageUrl: 'https://images.unsplash.com/photo-1576566588028-4147f3842f27?auto=format&fit=crop&w=300&q=80',
      quantity: 4000,
      unit: 'متر',
      moq: 500,
      packagingDetails: 'أكياس بلاستيكية متينة مقاومة للأتربة والرطوبة مجمعة في بالات شحن.',
      originalRequestedPrice: 20.0,
      supplierUnitPrice: 18.0,
      discount: 3000.0,
      taxes: 10425.0,
      shippingCost: 500.0,
      additionalCharges: 0.0,
      grandTotal: 79925.0,
      currency: 'جنيه',
      expectedProfitMargin: 20.0,
      paymentMethod: 'Bank Transfer',
      advancePayment: 25000.0,
      remainingBalance: 54925.0,
      creditPeriod: '٣٠ يوماً من الاستلام',
      settlementTime: '٢ يوم عمل',
      releaseConditions: 'موافقة الفحص الفني.',
      preparationTime: '١٠ أيام عمل',
      estimatedDelivery: '2026-07-02',
      deliveryLocation: 'مستودعات الخليج للنسيج، الخبر',
      shippingMethod: 'شحن بري مغلق',
      shippingCompany: 'Aramex Freight',
      incoterms: 'DDP',
      timeline: [
        const QuotationTimelineStep(
          title: 'RFQ Received',
          date: '2026-06-15',
          time: '11:00 ص',
          responsibleUser: 'نظام نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'Quotation Sent v1.0',
          date: '2026-06-15',
          time: '04:00 م',
          responsibleUser: 'مورد نسيجي',
          status: 'مكتمل',
        ),
        const QuotationTimelineStep(
          title: 'انقضاء مهلة صلاحية العرض دون رد',
          date: '2026-06-22',
          time: '11:59 م',
          responsibleUser: 'نظام نسيجي',
          status: 'منتهي الصلاحية',
          notes: 'انتهت صلاحية العرض المحددة بـ ٧ أيام عمل دون اعتماد أو طلب تفاوض من المشتري.',
        ),
      ],
    ),
  ];

  @override
  Future<List<QuotationModel>> getQuotations() async {
    return List.from(_mockQuotations);
  }

  @override
  Future<QuotationModel?> getQuotationDetails(String id) async {
    final index = _mockQuotations.indexWhere((q) => q.id == id);
    if (index != -1) {
      return _mockQuotations[index];
    }
    return null;
  }

  @override
  Future<void> saveQuotation(QuotationModel quotation) async {
    final index = _mockQuotations.indexWhere((q) => q.id == quotation.id);
    if (index != -1) {
      _mockQuotations[index] = quotation;
    } else {
      _mockQuotations.add(quotation);
    }
  }

  @override
  Future<void> deleteQuotation(String id) async {
    _mockQuotations.removeWhere((q) => q.id == id);
  }

  @override
  Future<void> sendQuotation(String id) async {
    await updateQuotationStatus(id, QuotationStatus.sent);
  }

  @override
  Future<void> withdrawQuotation(String id) async {
    await updateQuotationStatus(id, QuotationStatus.draft);
  }

  @override
  Future<void> acceptQuotation(String id) async {
    await updateQuotationStatus(id, QuotationStatus.accepted);
  }

  @override
  Future<void> rejectQuotation(String id, String reason) async {
    final index = _mockQuotations.indexWhere((q) => q.id == id);
    if (index != -1) {
      final current = _mockQuotations[index];
      _mockQuotations[index] = current.copyWith(
        status: QuotationStatus.rejected,
        rejectionReason: reason,
      );
    }
  }

  @override
  Future<void> updateQuotationStatus(String id, QuotationStatus status) async {
    final index = _mockQuotations.indexWhere((q) => q.id == id);
    if (index != -1) {
      final current = _mockQuotations[index];
      _mockQuotations[index] = current.copyWith(status: status);
    }
  }
}

@riverpod
QuotationsRepository quotationsRepository(QuotationsRepositoryRef ref) {
  return QuotationsRepositoryImpl();
}


