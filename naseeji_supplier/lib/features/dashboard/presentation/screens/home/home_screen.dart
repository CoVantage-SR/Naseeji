import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/controllers/dashboard_controller.dart';
import '../drawer/navigation_drawer_view.dart';
import 'widgets/line_chart_painter.dart';
import 'widgets/quick_action_card.dart';
import 'widgets/stat_card.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardControllerProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavigationDrawerView(),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0.5,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: AppColors.onSurfaceVariant),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
        title: Row(
          children: [
            const Text(
              'نسيجي',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(
              Icons.verified,
              color: AppColors.primary,
              size: 16,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: AppColors.onSurfaceVariant),
            onPressed: () => context.push('/search'),
          ),
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_none, color: AppColors.onSurfaceVariant),
                onPressed: () => context.push('/notifications'),
              ),
              Positioned(
                top: 8,
                right: 8,
                child: Container(
                  padding: const EdgeInsets.all(2),
                  decoration: const BoxDecoration(
                    color: AppColors.error,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 14, minHeight: 14),
                  child: const Text(
                    '3',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (stats) {
          return RefreshIndicator(
            onRefresh: () => ref.read(dashboardControllerProvider.notifier).refreshStats(),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting
                  const Text(
                    'مرحبًا، أحمد 👋',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'نتمنى لك يومًا ناجحًا في التوريد.',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Stats Grid
                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.4,
                    children: [
                      StatCard(
                        title: 'مبيعات اليوم',
                        value: '\$${stats.todaySales.toStringAsFixed(0)}',
                        trend: '+12%',
                        color: AppColors.primary,
                        icon: Icons.trending_up,
                      ),
                      StatCard(
                        title: 'الإيرادات الشهرية',
                        value: '\$${(stats.monthlyEarnings / 1000).toStringAsFixed(0)}k',
                        trend: '+8%',
                        color: AppColors.secondary,
                        icon: Icons.trending_up,
                      ),
                      StatCard(
                        title: 'طلبات معلقة',
                        value: stats.pendingOrders.toString(),
                        trend: 'تحتاج انتباه',
                        color: AppColors.tertiary,
                        icon: Icons.priority_high,
                        isWarning: true,
                      ),
                      StatCard(
                        title: 'منتجات نشطة',
                        value: stats.activeProducts.toString(),
                        trend: 'مخزون جيد',
                        color: AppColors.outline,
                        icon: Icons.check_circle,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Weekly Sales Performance Chart
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.outlineVariant.withValues(alpha: 0.3),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'تحليل المبيعات الأسبوعي',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.onSurface,
                              ),
                            ),
                            TextButton.icon(
                              onPressed: () => context.push('/analytics'),
                              icon: const Text(
                                'التفاصيل',
                                style: TextStyle(fontSize: 13, color: AppColors.primary),
                              ),
                              label: const Icon(
                                Icons.arrow_back,
                                size: 16,
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          height: 140,
                          width: double.infinity,
                          child: CustomPaint(
                            painter: LineChartPainter(stats.weeklySales),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [
                            Text('السبت', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الأحد', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الاثنين', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الثلاثاء', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الأربعاء', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الخميس', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                            Text('الجمعة', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Quick Actions
                  const Text(
                    'الوصول السريع',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      QuickActionCard(
                        icon: Icons.add_box,
                        label: 'إضافة منتج',
                        backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.primary,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.shopping_bag,
                        label: 'الطلبات',
                        backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.secondary,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.request_quote,
                        label: 'الفواتير',
                        backgroundColor: AppColors.surfaceContainerHigh,
                        iconColor: AppColors.onSurfaceVariant,
                        onTap: () {},
                      ),
                      QuickActionCard(
                        icon: Icons.account_circle,
                        label: 'الملف الشخصي',
                        backgroundColor: AppColors.surfaceContainerHigh,
                        iconColor: AppColors.onSurfaceVariant,
                        onTap: () => context.push('/profile'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
