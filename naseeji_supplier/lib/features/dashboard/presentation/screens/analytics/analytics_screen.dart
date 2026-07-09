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
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text(
          'تقارير الشغل وإحصائياتك',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurface,
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
          onPressed: () {
            if (context.canPop()) {
              context.pop();
            } else {
              context.go('/home');
            }
          },
        ),
      ),

      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: analyticsAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
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
                    Text(
                      'إحصائيات أداء شغلك',
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'نظرة شاملة على نمو وتطور شغلك في نسيجي',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 12, color: AppColors.outline),
                    ),
                    SizedBox(height: 20),

                    // Filter & Export buttons row
                    const AnalyticsFilterRow(),
                    SizedBox(height: 24),

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
                    SizedBox(height: 16),

                    // Sales Trend Bar Chart Card
                    SalesTrendChart(barData: data.barData),
                    SizedBox(height: 24),

                    // Orders Distribution Donut Card
                    OrdersDistributionCard(
                      readyForShippingPercentage:
                          data.readyForShippingPercentage,
                      cottonOrders: data.cottonOrders,
                      silkOrders: data.silkOrders,
                      syntheticOrders: data.syntheticOrders,
                    ),
                    SizedBox(height: 24),

                    // Revenue Growth Callout Banner
                    const RevenueGrowthBanner(),
                    SizedBox(height: 30),
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