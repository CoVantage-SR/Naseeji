import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/analytics_controller.dart';
import 'widgets/analytics_filter_row.dart';
import 'widgets/orders_distribution_card.dart';
import 'widgets/performance_metrics_grid.dart';
import 'widgets/revenue_growth_banner.dart';
import 'widgets/sales_trend_chart.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scaffoldKey = GlobalKey<ScaffoldState>();
    final analyticsAsync = ref.watch(analyticsControllerProvider);

    return Scaffold(
      key: scaffoldKey,
      // drawer: const NavigationDrawerView(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        title: const Text(
          'التقارير والإحصائيات',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new,
            color: AppColors.onSurfaceVariant,
            size: 20,
          ),
          onPressed: () => context.pop(),
        ),
      ),

      body: Container(
        color: const Color(0xFFF8F9FF),
        child: analyticsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (data) {
            return RefreshIndicator(
              onRefresh: () => ref
                  .read(analyticsControllerProvider.notifier)
                  .refreshAnalytics(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 20.0,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header title and subtitle
                    const Text(
                      'إحصائيات الأداء',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'نظرة شاملة على نمو أعمال نسيجي',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, color: AppColors.outline),
                    ),
                    const SizedBox(height: 20),

                    // Filter & Export buttons row
                    const AnalyticsFilterRow(),
                    const SizedBox(height: 24),

                    // Metric Cards Grid
                    PerformanceMetricsGrid(
                      totalSales: data.totalSales,
                      salesTrend: data.salesTrend,
                      isSalesPositive: data.isSalesTrendPositive,
                      netProfits: data.netProfits,
                      profitsTrend: data.profitsTrend,
                      isProfitsPositive: data.isProfitsTrendPositive,
                      totalCustomers: data.totalCustomers,
                      customersTrend: data.customersTrend,
                      isCustomersPositive: data.isCustomersTrendPositive,
                      completedOrders: data.completedOrders,
                      ordersTrend: data.ordersTrend,
                      isOrdersPositive: data.isOrdersTrendPositive,
                    ),
                    const SizedBox(height: 16),

                    // Sales Trend Bar Chart Card
                    SalesTrendChart(barData: data.barData),
                    const SizedBox(height: 24),

                    // Orders Distribution Donut Card
                    OrdersDistributionCard(
                      readyForShippingPercentage:
                          data.readyForShippingPercentage,
                      cottonOrders: data.cottonOrders,
                      silkOrders: data.silkOrders,
                      syntheticOrders: data.syntheticOrders,
                    ),
                    const SizedBox(height: 24),

                    // Revenue Growth Callout Banner
                    const RevenueGrowthBanner(),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
