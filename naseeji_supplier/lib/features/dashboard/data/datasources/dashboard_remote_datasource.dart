import 'package:flutter/material.dart';
import '../../domain/entities/supplier_header_model.dart';
import '../../domain/entities/dashboard_stats_model.dart';
import '../../domain/entities/subscription_overview_model.dart';
import '../../domain/entities/rfq_item_model.dart';
import '../../domain/entities/orders_overview_model.dart';
import '../../domain/entities/finance_overview_model.dart';
import '../../domain/entities/performance_overview_model.dart';
import '../../domain/entities/notification_item_model.dart';
import '../../domain/entities/quick_action_item_model.dart';

abstract class DashboardRemoteDatasource {
  Future<SupplierHeaderModel> fetchSupplierHeader();
  Future<DashboardStatsModel> fetchDashboardStats();
  Future<SubscriptionOverviewModel> fetchSubscriptionOverview();
  Future<List<RfqItemModel>> fetchRecentRfqs();
  Future<OrdersOverviewModel> fetchOrdersOverview();
  Future<FinanceOverviewModel> fetchFinanceOverview();
  Future<PerformanceOverviewModel> fetchPerformanceOverview();
  Future<List<NotificationItemModel>> fetchRecentNotifications();
  Future<List<QuickActionItemModel>> fetchQuickActions();
}

class DashboardRemoteDatasourceImpl implements DashboardRemoteDatasource {
  @override
  Future<SupplierHeaderModel> fetchSupplierHeader() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const SupplierHeaderModel(
      supplierId: 'SUP-89421',
      supplierName: 'شركة النسيج العربي المتقدمة',
      companyName: 'مصانع نسيج القاهرة الكبرى',
      subscriptionBadge: 'احترافي',
      unreadNotificationCount: 6,
      rating: 4.9,
      isVerified: true,
    );
  }

  @override
  Future<DashboardStatsModel> fetchDashboardStats() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const DashboardStatsModel(
      newRfqs: 14,
      waitingQuotations: 8,
      ordersUnderNegotiation: 5,
      ordersInProduction: 12,
      readyForShipment: 4,
      delayedOrders: 1,
      completedOrders: 184,
      monthlyRevenue: 285400.00,
    );
  }

  @override
  Future<SubscriptionOverviewModel> fetchSubscriptionOverview() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return SubscriptionOverviewModel(
      currentPlan: 'Professional (احترافي)',
      productsUsed: 58,
      productsLimit: 100,
      advertisementsUsed: 2,
      advertisementsLimit: 5,
      featuredProductsUsed: 1,
      featuredProductsLimit: 3,
      rfqsUsed: 34,
      rfqsLimit: 100,
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      isExpiringSoon: false,
    );
  }

  @override
  Future<List<RfqItemModel>> fetchRecentRfqs() async {
    await Future.delayed(const Duration(milliseconds: 350));
    final now = DateTime.now();
    return [
      RfqItemModel(
        id: 'RFQ-2026-9081',
        title: 'طلب توريد قماش قطن مصري ممتاز ١٠٠٪ - ٥٠٠٠ متر',
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
        title: 'خيوط غزل صوف مصبوغ عالي الجودة - ٢000 كجم',
        buyerName: 'مصانع الملابس الجاهزة بالتحرير',
        fabricType: 'صوف مصبوغ',
        quantity: '2,000 كجم',
        status: RfqStatus.underReview,
        priority: RfqPriority.high,
        deadline: now.add(const Duration(days: 2)),
        remainingTimeFormatted: 'يومان متبقيان',
        createdAt: now.subtract(const Duration(hours: 8)),
      ),
      RfqItemModel(
        id: 'RFQ-2026-9062',
        title: 'أقمشة بوليستر عازلة للماء للأقمشة الخارجية',
        buyerName: 'شركة النجم الفضي للتجارة',
        fabricType: 'بوليستر معالج',
        quantity: '10,000 متر',
        status: RfqStatus.quoted,
        priority: RfqPriority.medium,
        deadline: now.add(const Duration(days: 4)),
        remainingTimeFormatted: '٤ أيام متبقية',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
    ];
  }

  @override
  Future<OrdersOverviewModel> fetchOrdersOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const OrdersOverviewModel(
      preparing: 6,
      readyForPickup: 4,
      waitingLogistics: 3,
      shipping: 5,
      delivered: 14,
      completed: 184,
      delayed: 1,
    );
  }

  @override
  Future<FinanceOverviewModel> fetchFinanceOverview() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return const FinanceOverviewModel(
      pendingPayments: 42500.00,
      escrowBalance: 118200.00,
      releasedPayments: 242900.00,
      monthlyRevenue: 285400.00,
      outstandingInvoices: 18500.00,
      currency: 'ج.م',
    );
  }

  @override
  Future<PerformanceOverviewModel> fetchPerformanceOverview() async {
    await Future.delayed(const Duration(milliseconds: 250));
    return const PerformanceOverviewModel(
      supplierRating: 4.9,
      responseRate: 98.4,
      onTimeDeliveryRate: 96.2,
      acceptedQuotations: 48,
      rejectedQuotations: 6,
      completedOrders: 184,
      customerSatisfaction: 97.8,
    );
  }

  @override
  Future<List<NotificationItemModel>> fetchRecentNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    final now = DateTime.now();
    return [
      NotificationItemModel(
        id: 'NOTIF-101',
        title: 'طلب عروض أسعار جديد (RFQ)',
        message: 'تم استلام RFQ-2026-9081 من مجموعة المنسوجات الشرقية.',
        type: NotificationType.newRfq,
        timestamp: now.subtract(const Duration(minutes: 15)),
        isRead: false,
        targetRoute: '/orders/rfq-details/RFQ-2026-9081',
      ),
      NotificationItemModel(
        id: 'NOTIF-102',
        title: 'استلام عرض مضاد (Counter Offer)',
        message: 'قدم العميل عرضاً مضاداً على الطلب ORD-4421 بقيمة 85,000 ج.م.',
        type: NotificationType.counterOffer,
        timestamp: now.subtract(const Duration(hours: 1, minutes: 40)),
        isRead: false,
        targetRoute: '/orders',
      ),
      NotificationItemModel(
        id: 'NOTIF-103',
        title: 'اعتماد الاتفاقية النهائية',
        message: 'تمت الموافقة والتوقيع الرقمي على الاتفاقية AGR-7720.',
        type: NotificationType.agreementApproved,
        timestamp: now.subtract(const Duration(hours: 3)),
        isRead: true,
        targetRoute: '/agreements',
      ),
      NotificationItemModel(
        id: 'NOTIF-104',
        title: 'إنشاء الشحنة وبوليسة الشحن',
        message: 'تم استخراج بوليصة الشحن مع أرامكس للطلب ORD-4390.',
        type: NotificationType.shipmentCreated,
        timestamp: now.subtract(const Duration(hours: 5)),
        isRead: true,
        targetRoute: '/shipping',
      ),
      NotificationItemModel(
        id: 'NOTIF-105',
        title: 'تحرير المستحقات المالية (Escrow)',
        message: 'تم إيداع مبلغ 64,500 ج.م في محفظتك الإلكترونية.',
        type: NotificationType.paymentReleased,
        timestamp: now.subtract(const Duration(days: 1)),
        isRead: true,
        targetRoute: '/financial',
      ),
      NotificationItemModel(
        id: 'NOTIF-106',
        title: 'تنبيه اشتراك الباقة',
        message: 'المتبقي من حصة RFQs الشهرية ٣٤ طلب فقط. يمكنك الترقية الآن.',
        type: NotificationType.subscriptionExpiring,
        timestamp: now.subtract(const Duration(days: 2)),
        isRead: true,
        targetRoute: '/subscription',
      ),
    ];
  }

  @override
  Future<List<QuickActionItemModel>> fetchQuickActions() async {
    return const [
      QuickActionItemModel(
        id: 'add_product',
        title: 'إضافة منتج',
        icon: Icons.add_circle_outline_rounded,
        route: '/add-product',
        iconColor: Color(0xFF0040E0),
      ),
      QuickActionItemModel(
        id: 'create_ad',
        title: 'إنشاء إعلان',
        icon: Icons.campaign_outlined,
        route: '/subscription/addons',
        iconColor: Color(0xFFE65100),
      ),
      QuickActionItemModel(
        id: 'view_products',
        title: 'المنتجات',
        icon: Icons.inventory_2_outlined,
        route: '/products',
        iconColor: Color(0xFF006B5F),
      ),
      QuickActionItemModel(
        id: 'view_rfqs',
        title: 'طلبات الأسعار',
        icon: Icons.request_quote_outlined,
        route: '/orders',
        iconColor: Color(0xFF673AB7),
        badgeCount: 14,
      ),
      QuickActionItemModel(
        id: 'orders',
        title: 'إدارة الطلبات',
        icon: Icons.shopping_bag_outlined,
        route: '/orders',
        iconColor: Color(0xFF0288D1),
      ),
      QuickActionItemModel(
        id: 'finance',
        title: 'المالية',
        icon: Icons.account_balance_wallet_outlined,
        route: '/financial',
        iconColor: Color(0xFF2E7D32),
      ),
      QuickActionItemModel(
        id: 'subscription',
        title: 'الاشتراك',
        icon: Icons.card_membership_outlined,
        route: '/subscription',
        iconColor: Color(0xFFC2185B),
      ),
      QuickActionItemModel(
        id: 'analytics',
        title: 'التحليلات',
        icon: Icons.insights_outlined,
        route: '/analytics',
        iconColor: Color(0xFFD81B60),
      ),
    ];
  }
}
