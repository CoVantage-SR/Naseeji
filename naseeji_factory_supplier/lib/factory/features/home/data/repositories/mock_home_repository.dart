import '../../domain/entities/home_entities.dart';
import '../../domain/repositories/home_repository.dart';

class MockHomeRepository implements HomeRepository {
  static const Duration _delay = Duration(milliseconds: 500);

  @override
  Future<HomeStatistics> getHomeStatistics() async {
    await Future.delayed(_delay);
    return const HomeStatistics(
      completedOrders: 45,
      pendingOrders: 12,
      newQuotations: 8,
      shipments: 3,
      monthlyPurchases: 240000.0,
      favoriteSuppliers: 6,
    );
  }

  @override
  Future<List<LatestRFQ>> getLatestRFQs() async {
    await Future.delayed(_delay);
    return const [
      LatestRFQ(
        id: 'RFQ-2026-001',
        product: 'خيوط قطن ممشط 30/1 للموسم الشتوي',
        quantity: 10000,
        budget: 250000.0,
        status: 'معلق',
        supplierCount: 5,
      ),
      LatestRFQ(
        id: 'RFQ-2026-002',
        product: 'طلب أقمشة جبردين متينة لبنطلونات العمل الكاجوال',
        quantity: 15000,
        budget: 450000.0,
        status: 'تحت التفاوض',
        supplierCount: 3,
      ),
      LatestRFQ(
        id: 'RFQ-2026-003',
        product: 'علب كرتون لتغليف قمصان التصدير الجاهزة',
        quantity: 50000,
        budget: 60000.0,
        status: 'مقبول',
        supplierCount: 4,
      ),
    ];
  }

  @override
  Future<List<LatestQuotation>> getLatestQuotations() async {
    await Future.delayed(_delay);
    return const [
      LatestQuotation(
        id: 'QT-901',
        supplier: 'شركة غزل المحلة الكبرى',
        price: 245000.0,
        deliveryTime: '٥ أيام',
        rating: 4.8,
      ),
      LatestQuotation(
        id: 'QT-902',
        supplier: 'مصنع النيل للأقمشة الحديثة',
        price: 185000.0,
        deliveryTime: '٣ أيام',
        rating: 4.6,
      ),
      LatestQuotation(
        id: 'QT-903',
        supplier: 'الفتح لخيوط البوليستر ومستلزمات المصانع',
        price: 120000.0,
        deliveryTime: '٧ أيام',
        rating: 4.2,
      ),
    ];
  }

  @override
  Future<List<CurrentOrder>> getCurrentOrders() async {
    await Future.delayed(_delay);
    return const [
      CurrentOrder(
        orderNumber: 'ORD-201',
        supplier: 'مصنع غزل المحلة',
        status: 'قيد التجهيز',
        progress: 0.60,
        estimatedDelivery: '٢٠ يوليو ٢٠٢٦',
      ),
      CurrentOrder(
        orderNumber: 'ORD-203',
        supplier: 'المصرية لإنتاج الكتان',
        status: 'قيد الشحن',
        progress: 0.95,
        estimatedDelivery: '١٥ يوليو ٢٠٢٦',
      ),
      CurrentOrder(
        orderNumber: 'ORD-205',
        supplier: 'النساجون المتحدون صوف',
        status: 'طلب جديد',
        progress: 0.10,
        estimatedDelivery: '٢٨ يوليو ٢٠٢٦',
      ),
    ];
  }

  @override
  Future<List<Shipment>> getShipments() async {
    await Future.delayed(_delay);
    return const [
      Shipment(
        shippingCompany: 'نقل سريع إكسبريس',
        trackingNumber: 'TRK-771890',
        currentLocation: 'طريق القاهرة - الإسكندرية الصحراوي',
        eta: '١٥ يوليو ٢٠٢٦',
        progress: 0.95,
      ),
      Shipment(
        shippingCompany: 'أرامكس مصر (Aramex)',
        trackingNumber: 'TRK-990812',
        currentLocation: 'مركز فرز القاهرة الكبرى',
        eta: '٢٠ يوليو ٢٠٢٦',
        progress: 0.60,
      ),
      Shipment(
        shippingCompany: 'دي إتش إل (DHL)',
        trackingNumber: 'TRK-881245',
        currentLocation: 'مستودع الشحن الرئيسي بالإسكندرية',
        eta: '١٨ يوليو ٢٠٢٦',
        progress: 0.90,
      ),
    ];
  }

  @override
  Future<List<FavoriteSupplier>> getFavoriteSuppliers() async {
    await Future.delayed(_delay);
    return const [
      FavoriteSupplier(
        id: 'sup_1',
        logo: '',
        supplierName: 'شركة غزل المحلة الكبرى',
        rating: 4.8,
        lastDeal: 'منذ ١٠ أيام بقيمة ٢٤٠,٠٠٠ ج.م',
      ),
      FavoriteSupplier(
        id: 'sup_2',
        logo: '',
        supplierName: 'مصنع النيل للأقمشة الحديثة',
        rating: 4.6,
        lastDeal: 'منذ ٣ أيام بقيمة ١٨,٥٠٠ ج.م',
      ),
      FavoriteSupplier(
        id: 'sup_3',
        logo: '',
        supplierName: 'المصرية لإنتاج الكتان',
        rating: 4.7,
        lastDeal: 'منذ أسبوع بقيمة ١٢٠,٠٠٠ ج.م',
      ),
    ];
  }

  @override
  Future<MonthlyStatistics> getMonthlyStatistics() async {
    await Future.delayed(_delay);
    return const MonthlyStatistics(
      purchaseSummary: 240000.0,
      growthPercentage: 12.5,
      chartData: [45.0, 60.0, 55.0, 75.0, 85.0, 110.0, 95.0, 120.0],
    );
  }

  @override
  Future<List<RecentActivity>> getRecentActivities() async {
    await Future.delayed(_delay);
    return const [
      RecentActivity(
        id: 'act_1',
        title: 'تم إنشاء طلب عرض السعر',
        description: 'تم إرسال طلب RFQ-2026-001 إلى ٥ موردين بنجاح.',
        time: 'منذ ١٠ دقائق',
        type: 'rfq_created',
      ),
      RecentActivity(
        id: 'act_2',
        title: 'عرض سعر جديد مستلم',
        description: 'أرسلت شركة غزل المحلة الكبرى عرضاً جديداً لطلبكم.',
        time: 'منذ ساعتين',
        type: 'quotation_received',
      ),
      RecentActivity(
        id: 'act_3',
        title: 'تم اعتماد أمر الشراء',
        description: 'تم اعتماد الاتفاق الفني وإصدار أمر الشراء ORD-201.',
        time: 'منذ ٥ ساعات',
        type: 'order_approved',
      ),
      RecentActivity(
        id: 'act_4',
        title: 'شحنة المواد الخام بدأت',
        description: 'تم شحن الخامات الخاصة بالطلب ORD-203 مع نقل سريع إكسبريس.',
        time: 'بالأمس',
        type: 'shipment_started',
      ),
      RecentActivity(
        id: 'act_5',
        title: 'تم تسليم الشحنة وتأكيدها',
        description: 'أكد مشرف الجودة استلام شحنة الأقمشة ORD-204 بنجاح.',
        time: 'قبل يومين',
        type: 'shipment_delivered',
      ),
    ];
  }

  @override
  Future<List<SmartRecommendation>> getSmartRecommendations() async {
    await Future.delayed(_delay);
    return const [
      SmartRecommendation(
        id: 'rec_1',
        title: 'مورد بديل أرخص متوفر',
        description: 'مصنع الفتح يعرض خيوط قطنية بخصم ١٢% لنفس مواصفات طلبك الحالي.',
        type: 'cheaper_supplier',
        actionLabel: 'قارن العروض',
        routePath: '/search?type=suppliers',
      ),
      SmartRecommendation(
        id: 'rec_2',
        title: 'شحن أسرع متوفر للغربية',
        description: 'شركة أرامكس توفر شحن أسرع بـ ٢٤ ساعة لنفس التكلفة الحالية للطلبات.',
        type: 'faster_delivery',
        actionLabel: 'تعديل الشحن',
        routePath: '/orders',
      ),
      SmartRecommendation(
        id: 'rec_3',
        title: 'الكتان العضوي يرتفع في الطلب',
        description: 'توصية بزيادة مخزون الكتان بنسبة ٢٠% استعداداً للربع السنوي القادم.',
        type: 'trending_product',
        actionLabel: 'عرض إحصاءات السوق',
        routePath: '/statistics',
      ),
      SmartRecommendation(
        id: 'rec_4',
        title: 'مورد موصى به لك',
        description: 'حلوان لصناعة الغزل حصلت على تقييم ٤.٩ في الالتزام بمواعيد التسليم.',
        type: 'recommended_supplier',
        actionLabel: 'الملف الشخصي',
        routePath: '/suppliers/sup_4',
      ),
    ];
  }

  @override
  Future<List<ActionCenterAlert>> getActionCenterAlerts() async {
    await Future.delayed(_delay);
    return const [
      ActionCenterAlert(
        id: 'alert_1',
        title: 'موافقة معلقة لطلب عرض السعر',
        description: 'طلب عرض السعر RFQ-2026-001 بانتظار موافقتك النهائية.',
        type: 'pending_rfq',
        isClickable: true,
        routePath: '/rfq/RFQ-2026-001',
      ),
      ActionCenterAlert(
        id: 'alert_2',
        title: 'شحنة تصل اليوم',
        description: 'شحنة المواد الخام للطلب ORD-203 تصل اليوم الساعة ٤ مساءً.',
        type: 'shipment_today',
        isClickable: true,
        routePath: '/orders/ORD-203',
      ),
      ActionCenterAlert(
        id: 'alert_3',
        title: 'تم استلام رد المورد',
        description: 'أرسل المورد شركة غزل المحلة عرضاً جديداً رداً على تعديلاتك.',
        type: 'supplier_replied',
        isClickable: true,
        routePath: '/rfq/RFQ-2026-001',
      ),
      ActionCenterAlert(
        id: 'alert_4',
        title: 'فاتورة معلقة الدفع',
        description: 'هناك فاتورة معلقة بقيمة ١٢,٠٠٠ ج.م لطلب ORD-201.',
        type: 'invoice_pending',
        isClickable: true,
        routePath: '/mini-profile',
      ),
      ActionCenterAlert(
        id: 'alert_5',
        title: 'تأخير محتمل في الشحنة',
        description: 'تم رصد تأخير في شحنة الطلب ORD-205 بسبب أحوال الطقس بقبيسنا.',
        type: 'delayed_shipment',
        isClickable: true,
        routePath: '/orders/ORD-205',
      ),
    ];
  }
}



