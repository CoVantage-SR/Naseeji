import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'statistics_provider.g.dart';

class StatisticsState {
  final int totalOrders;
  final int completedOrders;
  final int pendingOrders;
  final int favoriteSuppliers;
  final String monthlyPurchases;
  final String averagePurchaseCost;
  final List<Map<String, dynamic>> monthlyOrdersChart;
  final List<Map<String, dynamic>> purchaseDistributionChart;
  final List<Map<String, dynamic>> orderStatusChart;

  StatisticsState({
    required this.totalOrders,
    required this.completedOrders,
    required this.pendingOrders,
    required this.favoriteSuppliers,
    required this.monthlyPurchases,
    required this.averagePurchaseCost,
    required this.monthlyOrdersChart,
    required this.purchaseDistributionChart,
    required this.orderStatusChart,
  });
}

@riverpod
class StatisticsNotifier extends _$StatisticsNotifier {
  @override
  StatisticsState build() {
    return StatisticsState(
      totalOrders: 57,
      completedOrders: 45,
      pendingOrders: 12,
      favoriteSuppliers: 8,
      monthlyPurchases: '٢٤٠,٠٠٠ ج.م',
      averagePurchaseCost: '١٨,٥٠٠ ج.م',
      monthlyOrdersChart: [
        {'month': 'يناير', 'value': 8},
        {'month': 'فبراير', 'value': 12},
        {'month': 'مارس', 'value': 10},
        {'month': 'أبريل', 'value': 15},
        {'month': 'مايو', 'value': 18},
        {'month': 'يونيو', 'value': 22},
      ],
      purchaseDistributionChart: [
        {'category': 'أقمشة', 'percent': 45.0},
        {'category': 'خيوط وغزل', 'percent': 30.0},
        {'category': 'إكسسوارات', 'percent': 15.0},
        {'category': 'خدمات طباعة', 'percent': 10.0},
      ],
      orderStatusChart: [
        {'status': 'مكتمل', 'value': 45},
        {'status': 'قيد الشحن', 'value': 3},
        {'status': 'قيد التصنيع', 'value': 9},
      ],
    );
  }
}


