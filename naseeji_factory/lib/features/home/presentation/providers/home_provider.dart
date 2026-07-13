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
          'id': 'rfq_101',
          'supplier_name': 'شركة مصر للغزل والنسيج',
          'price': '٢٥,٠٠٠ ج.م',
          'duration': '٥ أيام',
          'status': 'معلق',
        },
        {
          'id': 'rfq_102',
          'supplier_name': 'مصنع النيل للأقمشة',
          'price': '١٨,٥٠٠ ج.م',
          'duration': '٣ أيام',
          'status': 'مقبول',
        },
        {
          'id': 'rfq_103',
          'supplier_name': 'الفتح للمستلزمات',
          'price': '١٢,٠٠٠ ج.م',
          'duration': '٧ أيام',
          'status': 'مرفوض',
        },
      ],
      currentOrders: [
        {
          'id': 'ORD-9843',
          'supplier_name': 'الشركة الدولية للخيوط',
          'status': 'قيد التصنيع',
          'progress': 0.65,
          'expected_delivery': '٢٠ يوليو ٢٠٢٦',
        },
        {
          'id': 'ORD-9721',
          'supplier_name': 'مصنع الأمل للتطريز',
          'status': 'قيد الشحن',
          'progress': 0.90,
          'expected_delivery': '١٦ يوليو ٢٠٢٦',
        },
      ],
      recommendedSuppliers: [
        {
          'name': 'الشرق للأقمشة الفاخرة',
          'rating': 4.8,
          'specialization': 'أقمشة قطنية وحرير',
          'min_order': '٥,٠٠٠ ج.م',
          'logo_url': '',
        },
        {
          'name': 'التقوى لماكينات النسيج',
          'rating': 4.5,
          'specialization': 'قطع غيار وصيانة ماكينات',
          'min_order': '١٠,٠٠٠ ج.م',
          'logo_url': '',
        },
      ],
      recentActivities: [
        {
          'title': 'تم قبول الطلب',
          'description': 'وافق مصنع النيل للأقمشة على طلب التوريد ORD-9843.',
          'time': 'منذ ١٠ دقائق',
          'type': 'order_accepted',
        },
        {
          'title': 'بدء الشحن',
          'description': 'تم شحن الخامات الخاصة بالطلب ORD-9721 مع شركة أرامكس.',
          'time': 'منذ ساعتين',
          'type': 'shipment_started',
        },
        {
          'title': 'عرض سعر جديد',
          'description': 'أرسل المورد شركة مصر للغزل عرض سعر جديد لطلبك.',
          'time': 'منذ ٥ ساعات',
          'type': 'new_quotation',
        },
        {
          'title': 'تأكيد التسليم',
          'description': 'تم تأكيد تسليم شحنة الإكسسوارات ORD-9610 بنجاح.',
          'time': 'بالأمس',
          'type': 'delivery_confirmed',
        },
      ],
    );
  }
}
