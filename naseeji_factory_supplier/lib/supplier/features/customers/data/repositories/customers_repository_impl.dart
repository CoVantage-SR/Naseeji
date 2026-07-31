import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../domain/entities/customer_model.dart';
import '../../domain/repositories/customers_repository.dart';

part 'customers_repository_impl.g.dart';

// ─── Mock Implementation ──────────────────────────────────────────────────────
class CustomersRepositoryImpl implements CustomersRepository {
  final List<CustomerModel> _customers = [
    // ─── 1. VIP ──────────────────────────────────────────────────────────
    CustomerModel(
      id: 'CRM-001',
      logoText: 'RC',
      logoBgColorValue: 0xFF006B5F,
      factoryName: 'مصنع الرياض للملابس الجاهزة',
      contactPerson: 'المهندس أحمد مصطفى',
      phone: '+٩٦٦ ٥٥ ٧٦٥ ٤٣٢١',
      email: 'factory.riyadh@gmail.com',
      website: 'www.riyadhfactory.sa',
      country: 'المملكة العربية السعودية',
      city: 'الرياض',
      address: 'المنطقة الصناعية الأولى، الرياض',
      businessCategory: 'ملابس جاهزة',
      industry: 'الصناعة النسيجية',
      companyDescription: 'مصنع متخصص في إنتاج الملابس الرجالية والنسائية بجودة عالية، تأسس عام 2005.',
      isVerified: true,
      status: CustomerStatus.vip,
      rating: 4.8,
      totalOrders: 47,
      completedOrders: 44,
      cancelledOrders: 1,
      pendingOrders: 2,
      totalQuotations: 65,
      acceptedQuotations: 50,
      rejectedQuotations: 8,
      negotiationSuccessRate: 88.5,
      totalAgreements: 44,
      totalRevenue: 1250000,
      averageOrderValue: 26595,
      averagePaymentTime: 3.5,
      lastPurchaseDate: '2026-07-01',
      relationshipSince: '2022-03-15',
      activeOrdersCount: 2,
      pendingQuotationsCount: 3,
      pendingAgreementsCount: 1,
      currentShipmentCount: 1,
      pendingPaymentsCount: 1,
      supportTicketsCount: 0,
      tags: const [
        CustomerTag(id: 't1', label: 'VIP', colorValue: 0xFFFFB800),
        CustomerTag(id: 't2', label: 'سريع الدفع', colorValue: 0xFF00B894),
        CustomerTag(id: 't3', label: 'حجم مرتفع', colorValue: 0xFF0040E0),
      ],
      privateRating: const CustomerRating(
        paymentReliability: 5.0,
        communication: 4.8,
        negotiation: 4.5,
        responseSpeed: 4.9,
        orderFrequency: 5.0,
        deliveryCooperation: 4.7,
        overallRelationship: 4.8,
      ),
      notes: const [
        CustomerNote(
          id: 'n1',
          title: 'تفضيلات خاصة',
          description: 'يفضل التواصل عبر البريد الإلكتروني للموضوعات الرسمية وعبر واتساب للتحديثات السريعة.',
          priority: 'high',
          isPinned: true,
          createdDate: '2026-06-01',
          updatedDate: '2026-06-15',
        ),
      ],
      orders: const [
        CustomerOrder(
          orderNumber: 'ORD-4421',
          productName: 'قماش قطن 100٪',
          quantity: 5000,
          totalPrice: 67750,
          currency: 'جنيه',
          status: 'نشط',
          deliveryDate: '2026-07-20',
          paymentStatus: 'مدفوع جزئياً',
          shipmentStatus: 'قيد الشحن',
        ),
        CustomerOrder(
          orderNumber: 'ORD-4105',
          productName: 'أقمشة كتان فاخرة',
          quantity: 3000,
          totalPrice: 48500,
          currency: 'جنيه',
          status: 'مكتمل',
          deliveryDate: '2026-05-15',
          paymentStatus: 'مدفوع',
          shipmentStatus: 'تم التسليم',
        ),
      ],
      quotations: const [
        CustomerQuotation(
          quotationNumber: 'QT-8821',
          date: '2026-07-06',
          productName: 'قماش قطن 100٪',
          quantity: 5000,
          unitPrice: 12.5,
          currency: 'جنيه',
          status: 'مسودة',
        ),
        CustomerQuotation(
          quotationNumber: 'QT-8100',
          date: '2026-05-10',
          productName: 'أقمشة كتان',
          quantity: 3000,
          unitPrice: 16.2,
          currency: 'جنيه',
          status: 'مقبول',
        ),
      ],
      agreements: const [
        CustomerAgreement(
          agreementNumber: 'AGR-2201',
          agreementDate: '2026-05-12',
          status: 'نشط',
          grandTotal: 48500,
          currency: 'جنيه',
          paymentMethod: 'تحويل بنكي',
          deliveryDate: '2026-05-15',
        ),
      ],
      payments: const [
        CustomerPayment(
          invoiceNumber: 'INV-9901',
          amount: 48500,
          currency: 'جنيه',
          paymentMethod: 'تحويل بنكي',
          paymentDate: '2026-05-13',
          paymentStatus: 'مدفوع',
          outstandingBalance: 0,
          isLate: false,
          settlementTime: '1 يوم',
        ),
        CustomerPayment(
          invoiceNumber: 'INV-9750',
          amount: 20000,
          currency: 'جنيه',
          paymentMethod: 'تحويل بنكي',
          paymentDate: '2026-07-02',
          paymentStatus: 'مدفوع جزئياً',
          outstandingBalance: 47750,
          isLate: false,
          settlementTime: '–',
        ),
      ],
      shipments: const [
        CustomerShipment(
          shipmentNumber: 'SHP-5512',
          shippingCompany: 'أرامكس',
          trackingNumber: 'ARX-7782991',
          status: 'قيد الشحن',
          estimatedDelivery: '2026-07-20',
        ),
        CustomerShipment(
          shipmentNumber: 'SHP-5201',
          shippingCompany: 'DHL',
          trackingNumber: 'DHL-4419822',
          status: 'تم التسليم',
          estimatedDelivery: '2026-05-14',
          deliveredDate: '2026-05-15',
        ),
      ],
      documents: const [
        CustomerDocument(
          name: 'عقد الشراكة 2026',
          type: 'contract',
          uploadedAt: '2026-01-10',
          url: '',
        ),
        CustomerDocument(
          name: 'فاتورة ORD-4105',
          type: 'invoice',
          uploadedAt: '2026-05-12',
          url: '',
        ),
      ],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te1',
          title: 'تسجيل العميل في المنصة',
          date: '2022-03-15',
          time: '09:00 ص',
          responsibleUser: 'النظام',
          category: 'general',
        ),
        CustomerTimelineEvent(
          id: 'te2',
          title: 'أول طلب عرض أسعار RFQ-1001',
          date: '2022-04-01',
          time: '11:30 ص',
          responsibleUser: 'أحمد مصطفى',
          category: 'quotation',
        ),
        CustomerTimelineEvent(
          id: 'te3',
          title: 'أول اتفاقية AGR-1001 موقعة',
          date: '2022-04-10',
          time: '02:00 م',
          responsibleUser: 'مورد نسيجي',
          category: 'agreement',
        ),
        CustomerTimelineEvent(
          id: 'te4',
          title: 'إتمام الطلب ORD-4105 بنجاح',
          date: '2026-05-15',
          time: '04:00 م',
          responsibleUser: 'النظام',
          category: 'order',
        ),
      ],
      monthlyRevenue: const [
        MonthlyRevenue(month: 'يناير', amount: 95000),
        MonthlyRevenue(month: 'فبراير', amount: 78000),
        MonthlyRevenue(month: 'مارس', amount: 112000),
        MonthlyRevenue(month: 'أبريل', amount: 89000),
        MonthlyRevenue(month: 'مايو', amount: 134000),
        MonthlyRevenue(month: 'يونيو', amount: 98000),
        MonthlyRevenue(month: 'يوليو', amount: 67750),
      ],
      topProducts: const ['قماش قطن 100٪', 'أقمشة كتان فاخرة', 'خيوط بوليستر'],
    ),
    // ─── 2. Active ────────────────────────────────────────────────────────
    CustomerModel(
      id: 'CRM-002',
      logoText: 'JF',
      logoBgColorValue: 0xFF0040E0,
      factoryName: 'مصنع جدة للنسيج',
      contactPerson: 'سارة العمري',
      phone: '+٩٦٦ ٥٤ ٨٨٢ ١١٢٢',
      email: 'jeddah.factory@naseeji.com',
      website: 'www.jeddahtex.sa',
      country: 'المملكة العربية السعودية',
      city: 'جدة',
      address: 'المنطقة الصناعية، جدة',
      businessCategory: 'نسيج وأقمشة',
      industry: 'الصناعة النسيجية',
      companyDescription: 'مصنع متخصص في أقمشة الصيف والملابس الخفيفة منذ عام 2010.',
      isVerified: true,
      status: CustomerStatus.active,
      rating: 4.2,
      totalOrders: 23,
      completedOrders: 20,
      cancelledOrders: 2,
      pendingOrders: 1,
      totalQuotations: 30,
      acceptedQuotations: 22,
      rejectedQuotations: 5,
      negotiationSuccessRate: 73.3,
      totalAgreements: 20,
      totalRevenue: 485000,
      averageOrderValue: 21087,
      averagePaymentTime: 7,
      lastPurchaseDate: '2026-06-15',
      relationshipSince: '2023-08-01',
      activeOrdersCount: 1,
      pendingQuotationsCount: 1,
      pendingAgreementsCount: 0,
      currentShipmentCount: 1,
      pendingPaymentsCount: 0,
      supportTicketsCount: 1,
      tags: const [
        CustomerTag(id: 't4', label: 'عميل مفضل', colorValue: 0xFF993100),
        CustomerTag(id: 't5', label: 'مشتري قطن', colorValue: 0xFF006B5F),
      ],
      privateRating: const CustomerRating(
        paymentReliability: 4.0,
        communication: 4.5,
        negotiation: 3.8,
        responseSpeed: 4.2,
        orderFrequency: 4.0,
        deliveryCooperation: 4.3,
        overallRelationship: 4.2,
      ),
      orders: const [
        CustomerOrder(
          orderNumber: 'ORD-4390',
          productName: 'أقمشة صيفية خفيفة',
          quantity: 2000,
          totalPrice: 32000,
          currency: 'جنيه',
          status: 'نشط',
          deliveryDate: '2026-07-25',
          paymentStatus: 'لم يُسدَّد',
          shipmentStatus: 'في الإعداد',
        ),
      ],
      quotations: const [
        CustomerQuotation(
          quotationNumber: 'QT-8750',
          date: '2026-06-10',
          productName: 'أقمشة صيفية',
          quantity: 2000,
          unitPrice: 16.0,
          currency: 'جنيه',
          status: 'مقبول',
        ),
      ],
      agreements: const [],
      payments: const [],
      shipments: const [
        CustomerShipment(
          shipmentNumber: 'SHP-5600',
          shippingCompany: 'فيدكس',
          trackingNumber: 'FDX-9918811',
          status: 'في الإعداد',
          estimatedDelivery: '2026-07-25',
        ),
      ],
      documents: const [],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te10',
          title: 'تسجيل العميل',
          date: '2023-08-01',
          time: '10:00 ص',
          responsibleUser: 'النظام',
          category: 'general',
        ),
        CustomerTimelineEvent(
          id: 'te11',
          title: 'أول طلب ORD-4390',
          date: '2026-06-12',
          time: '09:00 ص',
          responsibleUser: 'سارة العمري',
          category: 'order',
        ),
      ],
      monthlyRevenue: const [
        MonthlyRevenue(month: 'أبريل', amount: 55000),
        MonthlyRevenue(month: 'مايو', amount: 60000),
        MonthlyRevenue(month: 'يونيو', amount: 70000),
        MonthlyRevenue(month: 'يوليو', amount: 32000),
      ],
      topProducts: const ['أقمشة صيفية خفيفة', 'قماش قطن مطبوع'],
    ),
    // ─── 3. New Customer ─────────────────────────────────────────────────
    CustomerModel(
      id: 'CRM-003',
      logoText: 'MK',
      logoBgColorValue: 0xFF993100,
      factoryName: 'مصنع مكة للملابس',
      contactPerson: 'خالد الزهراني',
      phone: '+٩٦٦ ٥٦ ٤٥٦ ٧٨٩٠',
      email: 'makkah.garments@mail.com',
      website: '',
      country: 'المملكة العربية السعودية',
      city: 'مكة المكرمة',
      address: 'المنطقة الصناعية الجديدة، مكة المكرمة',
      businessCategory: 'ملابس دينية وتقليدية',
      industry: 'الصناعة النسيجية',
      companyDescription: 'مصنع حديث متخصص في الملابس الدينية والتقليدية.',
      isVerified: false,
      status: CustomerStatus.newCustomer,
      rating: 3.5,
      totalOrders: 1,
      completedOrders: 0,
      cancelledOrders: 0,
      pendingOrders: 1,
      totalQuotations: 2,
      acceptedQuotations: 1,
      rejectedQuotations: 0,
      negotiationSuccessRate: 50.0,
      totalAgreements: 0,
      totalRevenue: 0,
      averageOrderValue: 0,
      averagePaymentTime: 0,
      lastPurchaseDate: '',
      relationshipSince: '2026-06-28',
      activeOrdersCount: 1,
      pendingQuotationsCount: 1,
      pendingAgreementsCount: 1,
      currentShipmentCount: 0,
      pendingPaymentsCount: 0,
      supportTicketsCount: 0,
      tags: const [
        CustomerTag(id: 't6', label: 'جديد', colorValue: 0xFF0040E0),
      ],
      privateRating: const CustomerRating(),
      orders: const [],
      quotations: const [
        CustomerQuotation(
          quotationNumber: 'QT-8900',
          date: '2026-06-29',
          productName: 'قماش أبيض للثياب',
          quantity: 1000,
          unitPrice: 18.0,
          currency: 'جنيه',
          status: 'تحت التفاوض',
        ),
      ],
      agreements: const [],
      payments: const [],
      shipments: const [],
      documents: const [],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te20',
          title: 'تسجيل العميل',
          date: '2026-06-28',
          time: '03:00 م',
          responsibleUser: 'النظام',
          category: 'general',
        ),
        CustomerTimelineEvent(
          id: 'te21',
          title: 'أول طلب عرض أسعار QT-8900',
          date: '2026-06-29',
          time: '11:00 ص',
          responsibleUser: 'خالد الزهراني',
          category: 'quotation',
        ),
      ],
      monthlyRevenue: const [],
      topProducts: const ['قماش أبيض للثياب'],
    ),
    // ─── 4. Inactive ─────────────────────────────────────────────────────
    CustomerModel(
      id: 'CRM-004',
      logoText: 'DA',
      logoBgColorValue: 0xFF747688,
      factoryName: 'مصنع الدمام للأقمشة',
      contactPerson: 'محمد الدوسري',
      phone: '+٩٦٦ ٥٠ ٣٣٣ ٥٥٥٥',
      email: 'dammam.fabrics@mail.com',
      website: '',
      country: 'المملكة العربية السعودية',
      city: 'الدمام',
      address: 'المنطقة الصناعية، الدمام',
      businessCategory: 'أقمشة صناعية',
      industry: 'الصناعة النسيجية',
      companyDescription: 'مصنع متخصص في الأقمشة الصناعية الثقيلة.',
      isVerified: true,
      status: CustomerStatus.inactive,
      rating: 3.8,
      totalOrders: 15,
      completedOrders: 13,
      cancelledOrders: 2,
      pendingOrders: 0,
      totalQuotations: 18,
      acceptedQuotations: 14,
      rejectedQuotations: 3,
      negotiationSuccessRate: 66.7,
      totalAgreements: 13,
      totalRevenue: 290000,
      averageOrderValue: 19333,
      averagePaymentTime: 12,
      lastPurchaseDate: '2025-11-20',
      relationshipSince: '2022-09-01',
      activeOrdersCount: 0,
      pendingQuotationsCount: 0,
      pendingAgreementsCount: 0,
      currentShipmentCount: 0,
      pendingPaymentsCount: 0,
      supportTicketsCount: 0,
      tags: const [
        CustomerTag(id: 't7', label: 'غير نشط', colorValue: 0xFF747688),
      ],
      privateRating: const CustomerRating(
        paymentReliability: 3.5,
        communication: 3.8,
        negotiation: 3.5,
        responseSpeed: 3.2,
        orderFrequency: 3.0,
        deliveryCooperation: 4.0,
        overallRelationship: 3.5,
      ),
      orders: const [],
      quotations: const [],
      agreements: const [],
      payments: const [],
      shipments: const [],
      documents: const [],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te30',
          title: 'تسجيل العميل',
          date: '2022-09-01',
          time: '10:00 ص',
          responsibleUser: 'النظام',
          category: 'general',
        ),
        CustomerTimelineEvent(
          id: 'te31',
          title: 'آخر طلب ORD-3800',
          date: '2025-11-20',
          time: '02:00 م',
          responsibleUser: 'النظام',
          category: 'order',
        ),
      ],
      monthlyRevenue: const [
        MonthlyRevenue(month: 'أغسطس', amount: 40000),
        MonthlyRevenue(month: 'سبتمبر', amount: 35000),
        MonthlyRevenue(month: 'أكتوبر', amount: 28000),
        MonthlyRevenue(month: 'نوفمبر', amount: 22000),
      ],
      topProducts: const ['أقمشة صناعية ثقيلة'],
    ),
    // ─── 5. Blocked ───────────────────────────────────────────────────────
    CustomerModel(
      id: 'CRM-005',
      logoText: 'TR',
      logoBgColorValue: 0xFFBA1A1A,
      factoryName: 'مصنع الطائف للتريكو',
      contactPerson: 'فهد العتيبي',
      phone: '+٩٦٦ ٥٨ ٩٩٩ ١٢١٢',
      email: 'taif.tricot@mail.com',
      website: '',
      country: 'المملكة العربية السعودية',
      city: 'الطائف',
      address: 'المنطقة الصناعية، الطائف',
      businessCategory: 'تريكو وملابس شتوية',
      industry: 'الصناعة النسيجية',
      companyDescription: 'مصنع تريكو قديم مع سجل دفع متأخر.',
      isVerified: false,
      status: CustomerStatus.blocked,
      rating: 2.1,
      totalOrders: 8,
      completedOrders: 5,
      cancelledOrders: 3,
      pendingOrders: 0,
      totalQuotations: 10,
      acceptedQuotations: 7,
      rejectedQuotations: 2,
      negotiationSuccessRate: 40.0,
      totalAgreements: 5,
      totalRevenue: 95000,
      averageOrderValue: 11875,
      averagePaymentTime: 45,
      lastPurchaseDate: '2025-08-10',
      relationshipSince: '2023-01-20',
      activeOrdersCount: 0,
      pendingQuotationsCount: 0,
      pendingAgreementsCount: 0,
      currentShipmentCount: 0,
      pendingPaymentsCount: 2,
      supportTicketsCount: 3,
      tags: const [
        CustomerTag(id: 't8', label: 'دفع متأخر', colorValue: 0xFFBA1A1A),
        CustomerTag(id: 't9', label: 'محظور', colorValue: 0xFF434656),
      ],
      privateRating: const CustomerRating(
        paymentReliability: 1.5,
        communication: 2.5,
        negotiation: 2.0,
        responseSpeed: 2.0,
        orderFrequency: 2.5,
        deliveryCooperation: 2.5,
        overallRelationship: 2.0,
      ),
      orders: const [],
      quotations: const [],
      agreements: const [],
      payments: const [],
      shipments: const [],
      documents: const [],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te40',
          title: 'تسجيل العميل',
          date: '2023-01-20',
          time: '08:00 ص',
          responsibleUser: 'النظام',
          category: 'general',
        ),
        CustomerTimelineEvent(
          id: 'te41',
          title: 'تم حظر العميل بسبب التأخر في السداد',
          date: '2025-09-01',
          time: '12:00 م',
          responsibleUser: 'مورد نسيجي',
          category: 'general',
          notes: 'تراكمت مدفوعات متأخرة بقيمة تتجاوز 30 يوماً.',
        ),
      ],
      monthlyRevenue: const [],
      topProducts: const ['تريكو شتوي'],
    ),
    // ─── 6. Active (International) ────────────────────────────────────────
    CustomerModel(
      id: 'CRM-006',
      logoText: 'EG',
      logoBgColorValue: 0xFF006B5F,
      factoryName: 'مصنع القاهرة للغزل والنسيج',
      contactPerson: 'د. محمود إبراهيم',
      phone: '+٢٠ ١٠ ٢٢٣ ٤٤٥٥',
      email: 'cairo.spinning@mail.eg',
      website: 'www.cairotex.eg',
      country: 'مصر',
      city: 'القاهرة',
      address: 'المنطقة الصناعية، ١٠ رمضان، القاهرة',
      businessCategory: 'غزل ونسيج',
      industry: 'الصناعة النسيجية',
      companyDescription: 'شركة رائدة في مجال الغزل والنسيج في مصر، تصدر لأكثر من 15 دولة.',
      isVerified: true,
      status: CustomerStatus.active,
      rating: 4.5,
      totalOrders: 31,
      completedOrders: 29,
      cancelledOrders: 0,
      pendingOrders: 2,
      totalQuotations: 40,
      acceptedQuotations: 32,
      rejectedQuotations: 5,
      negotiationSuccessRate: 80.0,
      totalAgreements: 29,
      totalRevenue: 680000,
      averageOrderValue: 21935,
      averagePaymentTime: 5,
      lastPurchaseDate: '2026-06-28',
      relationshipSince: '2023-02-10',
      activeOrdersCount: 2,
      pendingQuotationsCount: 2,
      pendingAgreementsCount: 0,
      currentShipmentCount: 1,
      pendingPaymentsCount: 1,
      supportTicketsCount: 0,
      tags: const [
        CustomerTag(id: 't10', label: 'عميل دولي', colorValue: 0xFF0040E0),
        CustomerTag(id: 't11', label: 'عميل متكرر', colorValue: 0xFF006B5F),
      ],
      privateRating: const CustomerRating(
        paymentReliability: 4.5,
        communication: 4.7,
        negotiation: 4.2,
        responseSpeed: 4.6,
        orderFrequency: 4.5,
        deliveryCooperation: 4.4,
        overallRelationship: 4.5,
      ),
      orders: const [
        CustomerOrder(
          orderNumber: 'ORD-4400',
          productName: 'خيوط قطن مصري',
          quantity: 10000,
          totalPrice: 95000,
          currency: 'جنيه',
          status: 'نشط',
          deliveryDate: '2026-08-01',
          paymentStatus: 'لم يُسدَّد',
          shipmentStatus: 'في الإعداد',
        ),
      ],
      quotations: const [],
      agreements: const [],
      payments: const [],
      shipments: const [],
      documents: const [],
      timeline: const [
        CustomerTimelineEvent(
          id: 'te50',
          title: 'تسجيل العميل',
          date: '2023-02-10',
          time: '09:00 ص',
          responsibleUser: 'النظام',
          category: 'general',
        ),
      ],
      monthlyRevenue: const [
        MonthlyRevenue(month: 'يناير', amount: 75000),
        MonthlyRevenue(month: 'فبراير', amount: 82000),
        MonthlyRevenue(month: 'مارس', amount: 90000),
        MonthlyRevenue(month: 'أبريل', amount: 95000),
        MonthlyRevenue(month: 'مايو', amount: 88000),
        MonthlyRevenue(month: 'يونيو', amount: 95000),
      ],
      topProducts: const ['خيوط قطن مصري', 'قماش كتان'],
    ),
  ];

  @override
  Future<List<CustomerModel>> getCustomers() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_customers);
  }

  @override
  Future<CustomerModel?> getCustomer(String id) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveCustomer(CustomerModel customer) async {
    final idx = _customers.indexWhere((c) => c.id == customer.id);
    if (idx >= 0) {
      _customers[idx] = customer;
    } else {
      _customers.add(customer);
    }
  }

  @override
  Future<void> addNote(String customerId, CustomerNote note) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final notes = List<CustomerNote>.from(_customers[idx].notes)..add(note);
      _customers[idx] = _customers[idx].copyWith(notes: notes);
    }
  }

  @override
  Future<void> updateNote(String customerId, CustomerNote note) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final notes = _customers[idx].notes.map((n) => n.id == note.id ? note : n).toList();
      _customers[idx] = _customers[idx].copyWith(notes: notes);
    }
  }

  @override
  Future<void> deleteNote(String customerId, String noteId) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final notes = _customers[idx].notes.where((n) => n.id != noteId).toList();
      _customers[idx] = _customers[idx].copyWith(notes: notes);
    }
  }

  @override
  Future<void> pinNote(String customerId, String noteId, bool pinned) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final notes = _customers[idx].notes
          .map((n) => n.id == noteId ? n.copyWith(isPinned: pinned) : n)
          .toList();
      _customers[idx] = _customers[idx].copyWith(notes: notes);
    }
  }

  @override
  Future<void> addTag(String customerId, CustomerTag tag) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final tags = List<CustomerTag>.from(_customers[idx].tags)..add(tag);
      _customers[idx] = _customers[idx].copyWith(tags: tags);
    }
  }

  @override
  Future<void> removeTag(String customerId, String tagId) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      final tags = _customers[idx].tags.where((t) => t.id != tagId).toList();
      _customers[idx] = _customers[idx].copyWith(tags: tags);
    }
  }

  @override
  Future<void> updateRating(String customerId, CustomerRating rating) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      _customers[idx] = _customers[idx].copyWith(privateRating: rating);
    }
  }

  @override
  Future<void> blockCustomer(String customerId, String reason) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      _customers[idx] = _customers[idx].copyWith(status: CustomerStatus.blocked);
    }
  }

  @override
  Future<void> unblockCustomer(String customerId) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      _customers[idx] = _customers[idx].copyWith(status: CustomerStatus.active);
    }
  }

  @override
  Future<void> archiveCustomer(String customerId) async {
    final idx = _customers.indexWhere((c) => c.id == customerId);
    if (idx >= 0) {
      _customers[idx] = _customers[idx].copyWith(status: CustomerStatus.inactive);
    }
  }
}

// ─── Riverpod Provider ───────────────────────────────────────────────────────
@riverpod
CustomersRepository customersRepository(CustomersRepositoryRef ref) {
  return CustomersRepositoryImpl();
}

