import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/statistics_provider.dart';
import '../widgets/statistics_widgets.dart';

class QuickStatisticsScreen extends ConsumerWidget {
  const QuickStatisticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(statisticsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('التقارير والإحصائيات'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              StatisticsHeaderWidget(
                monthlyPurchases: stats.monthlyPurchases,
                averageCost: stats.averagePurchaseCost,
              ),
              AppSpacing.hLG,
              // Detailed mini metric grid
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: context.responsiveValue(mobile: 1.35, tablet: 1.5),
                children: [
                  StatisticsCard(
                    label: 'إجمالي الطلبات',
                    value: stats.totalOrders.toString(),
                    icon: Icons.receipt_long_outlined,
                    color: Colors.blue,
                  ),
                  StatisticsCard(
                    label: 'طلبات مكتملة',
                    value: stats.completedOrders.toString(),
                    icon: Icons.check_circle_outline_rounded,
                    color: Colors.green,
                  ),
                  StatisticsCard(
                    label: 'طلبات معلقة',
                    value: stats.pendingOrders.toString(),
                    icon: Icons.pending_actions_rounded,
                    color: Colors.orange,
                  ),
                  StatisticsCard(
                    label: 'الموردين المفضلين',
                    value: stats.favoriteSuppliers.toString(),
                    icon: Icons.favorite_border_rounded,
                    color: Colors.red,
                  ),
                ],
              ),
              AppSpacing.hLG,
              OrdersChartWidget(chartData: stats.monthlyOrdersChart),
              AppSpacing.hLG,
              PurchaseChartWidget(distribution: stats.purchaseDistributionChart),
              AppSpacing.hLG,
              const TopSuppliersWidget(),
            ],
          ),
        ),
      ),
    );
  }
}


