import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'home_provider.g.dart';

class HomeState {
  final Map<String, dynamic> summaryStats;
  final List<Map<String, dynamic>> latestRfqs;
  final List<Map<String, dynamic>> currentOrders;
  final List<Map<String, dynamic>> recommendedSuppliers;
  final List<Map<String, dynamic>> recentActivities;

  HomeState({
    required this.summaryStats,
    required this.latestRfqs,
    required this.currentOrders,
    required this.recommendedSuppliers,
    required this.recentActivities,
  });
}

@riverpod
class HomeData extends _$HomeData {
  @override
  HomeState build() {
    return HomeState(
      summaryStats: {
        'active_orders': 12,
        'completed_orders': 45,
        'new_rfqs': 8,
        'shipping_orders': 3,
      },
      latestRfqs: [
        {
          'id': 'RFQ-2026-001',
          'supplier_name': 'شركة غزل المحلة الكبرى',
          'price': '٢٥,٠٠٠ ج.م',
          'duration': '٥ أيام',
          'status': 'معلق',
        },
        {
          'id': 'RFQ-2026-002',
          'supplier_name': 'مصنع النيل للأقمشة الحديثة',
          'price': '١٨,٥٠٠ ج.م',
          'duration': '٣ أيام',
          'status': 'مقبول',
        },
        {
          'id': 'RFQ-2026-003',
          'supplier_name': 'الفتح لخيوط البوليستر ومستلزمات المصانع',
          'price': '١٢,٠٠٠ ج.م',
          'duration': '٧ أيام',
          'status': 'مرفوض',
        },
      ],
      currentOrders: [
        {
          'id': 'ORD-201',
          'supplier_name': 'مصنع غزل المحلة',
          'status': 'قيد التجهيز',
          'progress': 0.60,
          'expected_delivery': '٢٠ يوليو ٢٠٢٦',
        },
        {
          'id': 'ORD-203',
          'supplier_name': 'المصرية لإنتاج الكتان',
          'status': 'قيد الشحن',
          'progress': 0.95,
          'expected_delivery': '١٥ يوليو ٢٠٢٦',
        },
      ],
      recommendedSuppliers: [
        {
          'id': 'sup_1',
          'name': 'شركة غزل المحلة الكبرى',
          'rating': 4.8,
          'specialization': 'غزل ونسيج قطني وصباغة',
          'min_order': '٥,٠٠٠ ج.م',
          'logo_url': '',
        },
        {
          'id': 'sup_2',
          'name': 'مصنع النيل للأقمشة الحديثة',
          'rating': 4.6,
          'specialization': 'أقمشة الجينز والجبردين والتريكو',
          'min_order': '١٠,٠٠٠ ج.م',
          'logo_url': '',
        },
      ],
      recentActivities: [
        {
          'title': 'تم إنشاء الطلب',
          'description': 'تم اعتماد الاتفاق الفني وإصدار أمر الشراء ORD-201 بنجاح.',
          'time': 'منذ ١٠ دقائق',
          'type': 'order_accepted',
        },
        {
          'title': 'بدء الشحن',
          'description': 'تم شحن الخامات الخاصة بالطلب ORD-203 مع نقل سريع إكسبريس.',
          'time': 'منذ ساعتين',
          'type': 'shipment_started',
        },
        {
          'title': 'عرض سعر جديد',
          'description': 'أرسل المورد شركة غزل المحلة الكبرى عرض سعر جديد لطلبك.',
          'time': 'منذ ٥ ساعات',
          'type': 'new_quotation',
        },
        {
          'title': 'تأكيد التسليم',
          'description': 'تم تأكيد تسليم شحنة الأقمشة ORD-204 بنجاح.',
          'time': 'بالأمس',
          'type': 'delivery_confirmed',
        },
      ],
    );
  }
}
