import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../drawer/navigation_drawer_view.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_header.dart';
import 'widgets/recent_orders_table.dart';
import 'widgets/stats_grid.dart';
import 'widgets/weekly_sales_chart_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardControllerProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: HomeAppBar(scaffoldKey: scaffoldKey),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () => ref
                .read(dashboardControllerProvider.notifier)
                .refreshStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(12.0, 12.0, 12.0, 100.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const HomeHeader(),
                  const SizedBox(height: 20),
                  StatsGrid(stats: stats),
                  const SizedBox(height: 24),
                  WeeklySalesChartCard(weeklySales: stats.weeklySales),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الطلبات الأخيرة',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: const Text(
                          'عرض الكل',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.primary,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const RecentOrdersTable(),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavigationBar(currentIndex: 0),
    );
  }
}
