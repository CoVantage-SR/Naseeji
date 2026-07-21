import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/task_item_model.dart';
import '../../domain/entities/active_order_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';

abstract class DashboardRemoteDatasource {
  Future<SupplierHeaderModel> fetchSupplierHeader();
  Future<List<TaskItemModel>> fetchTodayTasks();
  Future<List<ActiveOrderModel>> fetchActiveOrders();
  Future<List<RfqItemModel>> fetchRecentRfqs();
  Future<FinanceOverviewModel> fetchFinanceSummary();
  Future<SubscriptionOverviewModel> fetchSubscriptionOverview();
  Future<List<NotificationItemModel>> fetchRecentNotifications();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  @override
  Future<SupplierHeaderModel> fetchSupplierHeader() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const SupplierHeaderModel(
      greeting: 'السلام عليكم يا أ/ محمد',
      supplierName: 'محمد أحمد العرابي',
      companyName: 'شركة النسيج العربي',
      ratingStars: '★★★★★',
      subscriptionBadge: 'احترافي',
      isVerified: true,
      unreadNotificationCount: 3,
    );
  }

  @override
  Future<List<TaskItemModel>> fetchTodayTasks() async {
    await Future.delayed(const Duration(milliseconds: 250));
    final now = DateTime.now();

    return [
      TaskItemModel(
        id: 'TASK-1',
        title: 'لديك 3 طلبات RFQ تحتاج الرد',
        description: 'طلبات عروض أسعار عاجلة من مشتريين بانتظار تقديم تسعيرك.',
        priority: TaskPriority.urgent,
        statusLabel: 'عاجل جداً',
        actionLabel: 'عرض',
        actionRoute: '/orders',
        deadlineFormatted: 'متبقي ٣ ساعات',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      TaskItemModel(
        id: 'TASK-2',
        title: 'يوجد عرض يحتاج تفاوض',
        description: 'قدم المشتري عرضاً مضاداً على الطلب ORD-2304.',
        priority: TaskPriority.today,
        statusLabel: 'يحتاج تفاوض',
        actionLabel: 'فتح',
        actionRoute: '/orders',
        deadlineFormatted: 'اليوم ٥:٠٠ م',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      TaskItemModel(
        id: 'TASK-3',
        title: 'يوجد طلب جاهز للشحن',
        description: 'اكتمل تجهيز الطلب ORD-2305 في المصنع وبانتظار التغليف.',
        priority: TaskPriority.waiting,
        statusLabel: 'جاهز للشحن',
        actionLabel: 'إنشاء بوليصة',
        actionRoute: '/shipping',
        deadlineFormatted: 'غداً ١٢:٠٠ م',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
      TaskItemModel(
        id: 'TASK-4',
        title: 'تم تأكيد الاستلام',
        description: 'أكد العميل استلام الشحنة SHP-9081 ويمكنك سحب المبلغ.',
        priority: TaskPriority.informational,
        statusLabel: 'مستحقات محررة',
        actionLabel: 'استلام المستحقات',
        actionRoute: '/financial',
        deadlineFormatted: 'م متاح الآن',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<List<ActiveOrderModel>> fetchActiveOrders() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const [
      ActiveOrderModel(
        orderId: 'ORD-2304',
        buyerName: 'مجموعة المنسوجات الشرقية',
        currentStage: 'قيد الإنتاج',
        progressPercentage: 0.60,
        expectedDelivery: '٢٥ يوليو ٢٠٢٦',
        actionLabel: 'فتح الطلب',
        actionRoute: '/orders',
      ),
      ActiveOrderModel(
        orderId: 'ORD-2305',
        buyerName: 'مصانع الملابس الجاهزة',
        currentStage: 'جاهز للاستلام',
        progressPercentage: 1.00,
        expectedDelivery: 'اليوم',
        actionLabel: 'إنشاء شحنة',
        actionRoute: '/shipping',
      ),
      ActiveOrderModel(
        orderId: 'ORD-2308',
        buyerName: 'شركة النجم الفضي للتجارة',
        currentStage: 'جاري التغليف والفحص',
        progressPercentage: 0.85,
        expectedDelivery: 'غداً',
        actionLabel: 'فتح الطلب',
        actionRoute: '/orders',
      ),
    ];
  }

  @override
  Future<List<RfqItemModel>> fetchRecentRfqs() async {
    await Future.delayed(const Duration(milliseconds: 300));
    final now = DateTime.now();
    return [
      RfqItemModel(
        id: 'RFQ-2026-9081',
        title: 'طلب توريد قماش قطن مصري ممتاز ١٠٠٪',
        buyerName: 'مجموعة المنسوجات الشرقية',
        fabricType: 'قطن مصري 100%',
        quantity: '5,000 متر',
        status: RfqStatus.newRfq,
        priority: RfqPriority.urgent,
        deadline: now.add(const Duration(hours: 18)),
        remainingTimeFormatted: '١٨ ساعة متبقية',
        createdAt: now.subtract(const Duration(hours: 2)),
      ),
      RfqItemModel(
        id: 'RFQ-2026-9075',
        title: 'خيوط غزل صوف مصبوغ عالي الجودة',
        buyerName: 'مصانع الملابس الجاهزة',
        fabricType: 'صوف مصبوغ',
        quantity: '2,000 كجم',
        status: RfqStatus.underReview,
        priority: RfqPriority.high,
        deadline: now.add(const Duration(days: 2)),
        remainingTimeFormatted: 'يومان متبقيان',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
    ];
  }

  @override
  Future<FinanceOverviewModel> fetchFinanceSummary() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const FinanceOverviewModel(
      monthlyRevenue: 285400.00,
      pendingPayments: 42500.00,
      escrowBalance: 118200.00,
      releasedPayments: 242900.00,
      outstandingInvoices: 18500.00,
      currency: 'ج.م',
    );
  }

  @override
  Future<SubscriptionOverviewModel> fetchSubscriptionOverview() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SubscriptionOverviewModel(
      currentPlan: 'Professional',
      productsUsed: 58,
      productsLimit: 100,
      advertisementsUsed: 2,
      advertisementsLimit: 5,
      featuredProductsUsed: 1,
      featuredProductsLimit: 3,
      rfqsUsed: 34,
      rfqsLimit: 100,
      expiryDate: DateTime(2026, 9, 5),
      isExpiringSoon: false,
    );
  }

  @override
  Future<List<NotificationItemModel>> fetchRecentNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      NotificationItemModel(
        id: 'NOTIF-101',
        title: 'طلب أسعار جديد (RFQ)',
        message: 'تم استلام RFQ-2026-9081 من مجموعة المنسوجات الشرقية.',
        type: NotificationType.newRfq,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        targetRoute: '/orders',
      ),
      NotificationItemModel(
        id: 'NOTIF-102',
        title: 'عرض مضاد جديد',
        message: 'قدم العميل عرضاً مضاداً على الطلب ORD-2304.',
        type: NotificationType.counterOffer,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 40)),
        isRead: false,
        targetRoute: '/orders',
      ),
      NotificationItemModel(
        id: 'NOTIF-103',
        title: 'تم إنشاء الشحنة',
        message: 'تم استخراج بوليسة الشحن للطلب ORD-2305.',
        type: NotificationType.shipmentCreated,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        targetRoute: '/shipping',
      ),
      NotificationItemModel(
        id: 'NOTIF-104',
        title: 'تحرير مبلغ الضمان',
        message: 'تم تحويل مبلغ 42,900 ج.م لحسابك البنكي.',
        type: NotificationType.paymentReleased,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        targetRoute: '/financial',
      ),
    ];
  }
}
