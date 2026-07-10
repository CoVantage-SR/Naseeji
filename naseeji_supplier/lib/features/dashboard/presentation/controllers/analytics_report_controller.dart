import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

// Repositories
import '../../../customers/data/repositories/customers_repository_impl.dart';
import '../../../financial/data/repositories/financial_repository_impl.dart';
import '../../../subscription/presentation/controllers/subscription_controllers.dart';

part 'analytics_report_controller.g.dart';

enum DateFilterType {
  today,
  yesterday,
  last7Days,
  last30Days,
  last3Months,
  last6Months,
  currentYear,
  custom,
}

class ReportFilter {
  final DateFilterType dateFilter;
  final DateTime? startDate;
  final DateTime? endDate;
  final String selectedProductId;
  final String selectedCategory;
  final String selectedCustomerId;
  final String selectedOrderStatus;
  final String selectedShippingCompany;
  final String selectedAdId;
  final String selectedSubscriptionId;

  const ReportFilter({
    this.dateFilter = DateFilterType.last30Days,
    this.startDate,
    this.endDate,
    this.selectedProductId = 'الكل',
    this.selectedCategory = 'الكل',
    this.selectedCustomerId = 'الكل',
    this.selectedOrderStatus = 'الكل',
    this.selectedShippingCompany = 'الكل',
    this.selectedAdId = 'الكل',
    this.selectedSubscriptionId = 'الكل',
  });

  ReportFilter copyWith({
    DateFilterType? dateFilter,
    DateTime? startDate,
    DateTime? endDate,
    String? selectedProductId,
    String? selectedCategory,
    String? selectedCustomerId,
    String? selectedOrderStatus,
    String? selectedShippingCompany,
    String? selectedAdId,
    String? selectedSubscriptionId,
  }) {
    return ReportFilter(
      dateFilter: dateFilter ?? this.dateFilter,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      selectedProductId: selectedProductId ?? this.selectedProductId,
      selectedCategory: selectedCategory ?? this.selectedCategory,
      selectedCustomerId: selectedCustomerId ?? this.selectedCustomerId,
      selectedOrderStatus: selectedOrderStatus ?? this.selectedOrderStatus,
      selectedShippingCompany: selectedShippingCompany ?? this.selectedShippingCompany,
      selectedAdId: selectedAdId ?? this.selectedAdId,
      selectedSubscriptionId: selectedSubscriptionId ?? this.selectedSubscriptionId,
    );
  }
}

class ReportData {
  // General KPIs
  final double totalSales;
  final double netProfit;
  final double grossProfit;
  final int totalOrders;
  final int pendingOrders;
  final int completedOrders;
  final int cancelledOrders;
  final int newCustomers;
  final int returningCustomers;
  final int totalProducts;
  final int activeAds;
  final String currentSubscriptionPlan;
  final double walletBalance;
  final double averageRating;
  final double revenueGrowth;

  // Chart Data Lists
  final List<Map<String, dynamic>> salesTrend;
  final List<Map<String, dynamic>> ordersTrend;
  final List<Map<String, dynamic>> revenueExpensesTrend;
  final List<Map<String, dynamic>> customersGrowth;
  final List<Map<String, dynamic>> productPerformance;
  final List<Map<String, dynamic>> adPerformance;
  final List<Map<String, dynamic>> subscriptionUsage;
  final List<Map<String, dynamic>> orderStatusDistribution;

  // Details
  final double averageOrderValue;
  final String topSalesDay;
  final String topSalesMonth;
  final double winRate;
  final double averageResponseTimeHours;
  final int activeCampaigns;
  final int finishedCampaigns;
  final double avgShippingDays;
  final String topCarrier;

  const ReportData({
    required this.totalSales,
    required this.netProfit,
    required this.grossProfit,
    required this.totalOrders,
    required this.pendingOrders,
    required this.completedOrders,
    required this.cancelledOrders,
    required this.newCustomers,
    required this.returningCustomers,
    required this.totalProducts,
    required this.activeAds,
    required this.currentSubscriptionPlan,
    required this.walletBalance,
    required this.averageRating,
    required this.revenueGrowth,
    required this.salesTrend,
    required this.ordersTrend,
    required this.revenueExpensesTrend,
    required this.customersGrowth,
    required this.productPerformance,
    required this.adPerformance,
    required this.subscriptionUsage,
    required this.orderStatusDistribution,
    required this.averageOrderValue,
    required this.topSalesDay,
    required this.topSalesMonth,
    required this.winRate,
    required this.averageResponseTimeHours,
    required this.activeCampaigns,
    required this.finishedCampaigns,
    required this.avgShippingDays,
    required this.topCarrier,
  });
}

@riverpod
class AnalyticsReportFilter extends _$AnalyticsReportFilter {
  @override
  ReportFilter build() {
    return const ReportFilter();
  }

  void updateFilter(ReportFilter filter) {
    state = filter;
  }
}

@riverpod
class AnalyticsReportData extends _$AnalyticsReportData {
  @override
  FutureOr<ReportData> build() async {
    final filter = ref.watch(analyticsReportFilterProvider);

    // Watch repo providers
    final customersRepo = ref.watch(customersRepositoryProvider);
    final financialRepo = ref.watch(financialRepositoryProvider);
    final subscriptionRepo = ref.watch(subscriptionRepositoryProvider);

    // Fetch data concurrently
    final customers = await customersRepo.getCustomers();
    final financialData = await financialRepo.getDashboardData();
    
    final subscription = await subscriptionRepo.getSubscription();
    final subUsage = await subscriptionRepo.getUsage();

    // Map filters to filter simulated results
    double multiplier = 1.0;
    switch (filter.dateFilter) {
      case DateFilterType.today:
        multiplier = 0.05;
        break;
      case DateFilterType.yesterday:
        multiplier = 0.04;
        break;
      case DateFilterType.last7Days:
        multiplier = 0.25;
        break;
      case DateFilterType.last30Days:
        multiplier = 1.0;
        break;
      case DateFilterType.last3Months:
        multiplier = 2.8;
        break;
      case DateFilterType.last6Months:
        multiplier = 5.2;
        break;
      case DateFilterType.currentYear:
        multiplier = 9.5;
        break;
      case DateFilterType.custom:
        if (filter.startDate != null && filter.endDate != null) {
          final diffDays = filter.endDate!.difference(filter.startDate!).inDays;
          multiplier = (diffDays / 30.0).clamp(0.05, 12.0);
        }
        break;
    }

    // Secondary Filter Adjustments
    if (filter.selectedCategory != 'الكل') {
      multiplier *= 0.35;
    }
    if (filter.selectedCustomerId != 'الكل') {
      multiplier *= 0.15;
    }

    // Calculations based on actual repositories values
    final double computedSales = financialData.totalRevenue * multiplier;
    final double computedNetProfit = financialData.netProfit * multiplier;
    final double computedGrossProfit = computedSales * 1.25;
    final int computedTotalOrders = (120 * multiplier).round();
    final int computedPendingOrders = (financialData.pendingPayments * 0.1).round() + 2;
    final int computedCompletedOrders = (computedTotalOrders * 0.85).round();
    final int computedCancelledOrders = (computedTotalOrders * 0.05).round();

    int computedNewCustomers = (15 * multiplier).round();
    int computedReturningCustomers = (85 * multiplier).round();
    if (customers.isNotEmpty) {
      computedNewCustomers = (customers.length * 0.15 * multiplier).round().clamp(1, 100);
      computedReturningCustomers = (customers.length * 0.85 * multiplier).round().clamp(1, 500);
    }

    final double computedWalletBalance = financialData.availableBalance;
    const double computedRating = 4.75;
    const double computedGrowth = 18.4;

    // Build lists for charts based on time filter
    final List<Map<String, dynamic>> salesTrendData = [];
    final List<Map<String, dynamic>> ordersTrendData = [];
    final List<Map<String, dynamic>> revenueExpensesTrendData = [];
    final List<Map<String, dynamic>> customersGrowthData = [];

    // Depending on date range, make different intervals
    int dataPoints = 7;
    List<String> labels = ['السبت', 'الأحد', 'الاثنين', 'الثلاثاء', 'الأربعاء', 'الخميس', 'الجمعة'];
    if (filter.dateFilter == DateFilterType.last3Months || filter.dateFilter == DateFilterType.last6Months || filter.dateFilter == DateFilterType.currentYear) {
      dataPoints = 6;
      labels = ['يناير', 'فبراير', 'مارس', 'أبريل', 'مايو', 'يونيو'];
    }

    for (int i = 0; i < dataPoints; i++) {
      double salesFactor = (0.4 + (0.6 * (i % 3) / 2.0));
      salesTrendData.add({
        'label': labels[i],
        'value': computedSales / dataPoints * salesFactor,
      });

      ordersTrendData.add({
        'label': labels[i],
        'value': (computedTotalOrders / dataPoints * salesFactor).round().clamp(1, 1000),
      });

      revenueExpensesTrendData.add({
        'label': labels[i],
        'revenue': computedSales / dataPoints * salesFactor,
        'expenses': (computedSales / dataPoints * salesFactor) * 0.65,
      });

      customersGrowthData.add({
        'label': labels[i],
        'value': (computedNewCustomers / dataPoints * (i + 1) * 0.8).round().clamp(1, 500),
      });
    }

    // Product performance mock based on real items
    final List<Map<String, dynamic>> productPerf = [
      {
        'id': 'p1',
        'name': 'خيوط غزل القطن الفاخر',
        'sku': 'COT-YRN-001',
        'views': 4520,
        'visitors': 3120,
        'rfqs': 148,
        'negotiations': 94,
        'orders': 78,
        'revenue': 97500.0,
        'ctr': 4.8,
        'rating': 4.9,
      },
      {
        'id': 'p2',
        'name': 'قماش قطني طبيعي ١٠٠٪',
        'sku': 'COT-FAB-002',
        'views': 3180,
        'visitors': 2400,
        'rfqs': 92,
        'negotiations': 60,
        'orders': 45,
        'revenue': 38250.0,
        'ctr': 3.9,
        'rating': 4.7,
      },
      {
        'id': 'p3',
        'name': 'نسيج صوف مخلوط مميز',
        'sku': 'WOL-MIX-003',
        'views': 1240,
        'visitors': 950,
        'rfqs': 40,
        'negotiations': 25,
        'orders': 18,
        'revenue': 14400.0,
        'ctr': 2.5,
        'rating': 4.6,
      },
    ];

    final List<Map<String, dynamic>> adPerf = [
      {
        'id': 'ad1',
        'title': 'ترويج خيوط القطن الفاخر الممتاز',
        'views': 12400,
        'clicks': 1250,
        'ctr': 10.08,
        'leads': 85,
        'orders': 42,
        'revenue': 52500.0,
        'roi': 3.5,
      },
      {
        'id': 'ad2',
        'title': 'إعلان نسيج الصوف المخلوط الموسمي',
        'views': 5800,
        'clicks': 420,
        'ctr': 7.24,
        'leads': 30,
        'orders': 12,
        'revenue': 9600.0,
        'roi': 2.1,
      },
    ];

    final List<Map<String, dynamic>> subUsageData = [
      {'resource': 'المنتجات المسموحة', 'used': subUsage.productsUsed, 'max': subUsage.productsUsed + 5, 'percent': 0.8},
      {'resource': 'الإعلانات النشطة', 'used': subUsage.advertisementsUsed, 'max': 5, 'percent': 0.6},
      {'resource': 'مساحة التخزين (GB)', 'used': subUsage.storageUsedGb.round(), 'max': 20, 'percent': 0.45},
      {'resource': 'الموظفون المضافون', 'used': subUsage.employeesUsed, 'max': 10, 'percent': 0.3},
    ];

    // Status distributions
    final int preparingCount = (computedTotalOrders * 0.2).round();
    final int shippingCount = (computedTotalOrders * 0.15).round();
    final int deliveredCount = (computedTotalOrders * 0.6).round();
    final int cancelledCount = (computedTotalOrders * 0.05).round();

    final List<Map<String, dynamic>> statusDist = [
      {'status': 'تجهيز قيد التحضير', 'count': preparingCount, 'color': const Color(0xFF009688)},
      {'status': 'قيد الشحن والتوصيل', 'count': shippingCount, 'color': const Color(0xFFFF9800)},
      {'status': 'تم التوصيل للعميل', 'count': deliveredCount, 'color': const Color(0xFF4CAF50)},
      {'status': 'ملغي أو مرتجع', 'count': cancelledCount, 'color': const Color(0xFFF44336)},
    ];

    return ReportData(
      totalSales: computedSales,
      netProfit: computedNetProfit,
      grossProfit: computedGrossProfit,
      totalOrders: computedTotalOrders,
      pendingOrders: computedPendingOrders,
      completedOrders: computedCompletedOrders,
      cancelledOrders: computedCancelledOrders,
      newCustomers: computedNewCustomers,
      returningCustomers: computedReturningCustomers,
      totalProducts: 12 + (subUsage.productsUsed),
      activeAds: subUsage.advertisementsUsed,
      currentSubscriptionPlan: subscription.planName,
      walletBalance: computedWalletBalance,
      averageRating: computedRating,
      revenueGrowth: computedGrowth,
      salesTrend: salesTrendData,
      ordersTrend: ordersTrendData,
      revenueExpensesTrend: revenueExpensesTrendData,
      customersGrowth: customersGrowthData,
      productPerformance: productPerf,
      adPerformance: adPerf,
      subscriptionUsage: subUsageData,
      orderStatusDistribution: statusDist,
      averageOrderValue: computedSales / (computedTotalOrders == 0 ? 1 : computedTotalOrders),
      topSalesDay: 'الخميس',
      topSalesMonth: 'يونيو',
      winRate: 72.5,
      averageResponseTimeHours: 1.8,
      activeCampaigns: 3,
      finishedCampaigns: 14,
      avgShippingDays: 3.2,
      topCarrier: 'أرامكس Aramex',
    );
  }
}
