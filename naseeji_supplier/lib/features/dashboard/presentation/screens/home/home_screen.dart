import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../drawer/navigation_drawer_view.dart';
import 'widgets/home_app_bar.dart';
import 'widgets/home_header.dart';
import 'widgets/quick_actions_grid.dart';
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
          return Stack(
            children: [
              RefreshIndicator(
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
                      const Text(
                        'الوصول السريع',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      const QuickActionsGrid(),
                      const SizedBox(height: 28),
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
              ),

              // Bottom Smaller FAB (Floats to bottom-left)
              Positioned(
                bottom: 24,
                left: 16,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'إضافة منتج جديد',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: AppColors.outlineVariant.withValues(alpha: 0.3),
              width: 0.5,
            ),
          ),
        ),
        child: SafeArea(
          child: BottomNavigationBar(
            currentIndex: 0,
            backgroundColor: Colors.white,
            selectedItemColor: AppColors.primary,
            unselectedItemColor: AppColors.onSurfaceVariant,
            type: BottomNavigationBarType.fixed,
            selectedLabelStyle: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
            ),
            unselectedLabelStyle: const TextStyle(fontSize: 11),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.category_outlined),
                label: 'Products',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined),
                label: 'Orders',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.chat_bubble_outline),
                label: 'Messages',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Account',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
