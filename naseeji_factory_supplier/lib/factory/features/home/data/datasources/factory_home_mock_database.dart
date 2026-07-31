import '../../domain/entities/factory_home_models.dart';

class MockDatabase {
  MockDatabase._();

  static Future<FactoryDashboardData> getDashboardData() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const FactoryDashboardData(
      factoryName: 'مصنع النسيج الحديث',
      isVerified: true,
      unreadNotificationsCount: 4,
      greeting: 'صباح الخير،',
      todayTasks: [
        TodayTaskItem(
          id: 'task_1',
          count: 8,
          title: 'RFQs\nتحتاج الإرسال',
          colorTag: 'blue',
          iconType: 'send',
          routePath: '/rfq',
        ),
        TodayTaskItem(
          id: 'task_2',
          count: 5,
          title: 'عروض أسعار\nجديدة',
          colorTag: 'green',
          iconType: 'quote',
          routePath: '/rfq',
        ),
        TodayTaskItem(
          id: 'task_3',
          count: 3,
          title: 'تفاوضات\nتحتاج رد',
          colorTag: 'orange',
          iconType: 'chat',
          routePath: '/chat',
        ),
        TodayTaskItem(
          id: 'task_4',
          count: 2,
          title: 'طلبات\nتحتاج اعتماد',
          colorTag: 'red',
          iconType: 'approve',
          routePath: '/orders',
        ),
      ],
    );
  }

  static Future<List<RecentQuotationItem>> getRecentQuotations() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      RecentQuotationItem(
        id: 'quote_1',
        supplierName: 'النساجون المصريون',
        supplierLogo: 'assets/images/suppliers/nassagoon.png',
        productName: 'قماش قطن 100%',
        price: '125.50 ج/متر',
        deliveryTime: '7 أيام',
        validity: 'صالح حتى 25 مايو',
        status: 'جديد',
      ),
      RecentQuotationItem(
        id: 'quote_2',
        supplierName: 'الهرم للغزول',
        supplierLogo: 'assets/images/suppliers/haram.png',
        productName: 'خيوط بوليستر',
        price: '98.75 ج/كجم',
        deliveryTime: '10 أيام',
        validity: 'صالح حتى 27 مايو',
        status: 'قيد التفاوض',
      ),
      RecentQuotationItem(
        id: 'quote_3',
        supplierName: 'الدلتا للمنسوجات',
        supplierLogo: 'assets/images/suppliers/delta.png',
        productName: 'قماش تريكو',
        price: '110.00 ج/متر',
        deliveryTime: '5 أيام',
        validity: 'صالح حتى 24 مايو',
        status: 'تم استلامه',
      ),
      RecentQuotationItem(
        id: 'quote_4',
        supplierName: 'الوطنية للأقمشة',
        supplierLogo: 'assets/images/suppliers/wataniya.png',
        productName: 'قماش قطن مخلوط',
        price: '95.25 ج/متر',
        deliveryTime: '8 أيام',
        validity: 'صالح حتى 24 مايو',
        status: 'منتهي',
      ),
    ];
  }

  static Future<List<ActiveDealItem>> getActiveDeals() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      ActiveDealItem(
        dealId: '#DEAL-2504-0012',
        supplierName: 'النساجون المصريون',
        productName: 'قماش قطن 100%',
        expectedDelivery: '15 مايو 2025',
        status: 'في الإنتاج',
        progress: 0.60,
      ),
      ActiveDealItem(
        dealId: '#DEAL-2504-0011',
        supplierName: 'الهرم للغزول',
        productName: 'خيوط بوليستر',
        expectedDelivery: '20 مايو 2025',
        status: 'تم الاتفاق',
        progress: 0.40,
      ),
      ActiveDealItem(
        dealId: '#DEAL-2504-0010',
        supplierName: 'الدلتا للمنسوجات',
        productName: 'قماش تريكو',
        expectedDelivery: '25 مايو 2025',
        status: 'قيد التفاوض',
        progress: 0.20,
      ),
    ];
  }

  static Future<List<RecentRFQItem>> getRecentRFQs() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      RecentRFQItem(
        id: 'rfq_101',
        productName: 'قماش قطن 100%',
        quantity: '5,000 متر',
        sentToCount: '12 مورد',
        status: 'بانتظار العروض',
        createdAt: '15 مايو 2025',
      ),
      RecentRFQItem(
        id: 'rfq_102',
        productName: 'خيوط بوليستر',
        quantity: '2,000 كجم',
        sentToCount: '8 مورد',
        status: 'عروض مستلمة',
        createdAt: '14 مايو 2025',
      ),
      RecentRFQItem(
        id: 'rfq_103',
        productName: 'قماش تريكو',
        quantity: '3,000 متر',
        sentToCount: '10 مورد',
        status: 'قيد التفاوض',
        createdAt: '13 مايو 2025',
      ),
      RecentRFQItem(
        id: 'rfq_104',
        productName: 'سوست وسحابات',
        quantity: '1,500 قطعة',
        sentToCount: '6 مورد',
        status: 'بانتظار العروض',
        createdAt: '12 مايو 2025',
      ),
      RecentRFQItem(
        id: 'rfq_105',
        productName: 'أزرار بلاستيك',
        quantity: '10,000 قطعة',
        sentToCount: '5 مورد',
        status: 'عروض مستلمة',
        createdAt: '11 مايو 2025',
      ),
    ];
  }

  static Future<List<FavoriteSupplierItem>> getFavoriteSuppliers() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      FavoriteSupplierItem(
        id: 'sup_1',
        supplierName: 'الوطنية للأقمشة',
        isVerified: true,
        rating: 4.5,
        country: 'تركيا',
        flagEmoji: '🇹🇷',
      ),
      FavoriteSupplierItem(
        id: 'sup_2',
        supplierName: 'الدلتا للمنسوجات',
        isVerified: true,
        rating: 4.6,
        country: 'مصر',
        flagEmoji: '🇪🇬',
      ),
      FavoriteSupplierItem(
        id: 'sup_3',
        supplierName: 'الهرم للغزول',
        isVerified: true,
        rating: 4.6,
        country: 'مصر',
        flagEmoji: '🇪🇬',
      ),
      FavoriteSupplierItem(
        id: 'sup_4',
        supplierName: 'النساجون المصريون',
        isVerified: true,
        rating: 4.8,
        country: 'مصر',
        flagEmoji: '🇪🇬',
      ),
    ];
  }

  static Future<List<NotificationPreviewItem>> getNotifications() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      NotificationPreviewItem(
        id: 'notif_1',
        title: 'شحنة جاهزة',
        description: 'شحنة طلب #DEAL-2504-0012 جاهزة للشحن',
        timeAgo: 'منذ 30 دقيقة',
        type: 'shipment',
      ),
      NotificationPreviewItem(
        id: 'notif_2',
        title: 'تم تحديث الصفقة',
        description: 'تم تحديث حالة الصفقة #DEAL-2504-0011',
        timeAgo: 'منذ ساعة',
        type: 'deal',
      ),
      NotificationPreviewItem(
        id: 'notif_3',
        title: 'رسالة جديدة',
        description: 'لديك رسالة جديدة من الهرم للغزول',
        timeAgo: 'منذ 2 ساعة',
        type: 'chat',
      ),
      NotificationPreviewItem(
        id: 'notif_4',
        title: 'عرض سعر جديد',
        description: 'عرض سعر جديد من النساجون المصريون',
        timeAgo: 'منذ 3 ساعة',
        type: 'quotation',
      ),
    ];
  }
}
