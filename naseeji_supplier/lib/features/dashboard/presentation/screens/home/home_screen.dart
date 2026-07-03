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
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'نسيجي',
              style: TextStyle(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 4),
            Icon(
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
          return Stack(
            children: [
              RefreshIndicator(
                onRefresh: () => ref.read(dashboardControllerProvider.notifier).refreshStats(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 100.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مرحبًا، أحمد 👋',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'نتمنى لك يومًا ناجحًا.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                      const SizedBox(height: 20),

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
                            value: '\$${stats.todaySales.toStringAsFixed(0)}k',
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
                            trend: 'تحتاج انتباه !',
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

                      // Weekly Sales Chart
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
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.onSurface,
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerLow,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Row(
                                    children: const [
                                      Text(
                                        'آخر 7 أيام',
                                        style: TextStyle(fontSize: 11, color: AppColors.onSurfaceVariant),
                                      ),
                                      SizedBox(width: 4),
                                      Icon(Icons.expand_more, size: 14, color: AppColors.onSurfaceVariant),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              height: 120,
                              width: double.infinity,
                              child: CustomPaint(
                                painter: LineChartPainter(stats.weeklySales),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: const [
                                Text('السبت', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الأحد', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الاثنين', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الثلاثاء', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الأربعاء', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الخميس', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                                Text('الجمعة', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Quick Actions (2 Rows of 4 Cards)
                      const Text(
                        'الوصول السريع',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppColors.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Column(
                        children: [
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
                                icon: Icons.description,
                                label: 'عروض الأسعار',
                                backgroundColor: AppColors.surfaceContainerLow,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () {},
                              ),
                              QuickActionCard(
                                icon: Icons.local_shipping,
                                label: 'الشحن',
                                backgroundColor: AppColors.surfaceContainerLow,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () {},
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              QuickActionCard(
                                icon: Icons.groups,
                                label: 'العملاء',
                                backgroundColor: AppColors.surfaceContainerHigh,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () {},
                              ),
                              QuickActionCard(
                                icon: Icons.payments,
                                label: 'الأرباح',
                                backgroundColor: AppColors.surfaceContainerHigh,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () {},
                              ),
                              QuickActionCard(
                                icon: Icons.campaign,
                                label: 'الحملات',
                                backgroundColor: AppColors.surfaceContainerHigh,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () {},
                              ),
                              QuickActionCard(
                                icon: Icons.assessment,
                                label: 'التقارير',
                                backgroundColor: AppColors.surfaceContainerHigh,
                                iconColor: AppColors.onSurfaceVariant,
                                onTap: () => context.push('/analytics'),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Recent Orders Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الطلبات الأخيرة',
                            style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          TextButton(
                            onPressed: () {},
                            child: const Text('عرض الكل', style: TextStyle(fontSize: 12, color: AppColors.primary)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      _buildOrdersTable(),
                    ],
                  ),
                ),
              ),

              // Bottom FAB
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: FloatingActionButton.extended(
                  onPressed: () {},
                  backgroundColor: AppColors.primary,
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text(
                    'إضافة منتج جديد',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
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
            selectedLabelStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
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

  Widget _buildOrdersTable() {
    final List<Map<String, String>> mockOrders = [
      {
        'id': '#ORD-2934',
        'factory': 'مصنع الغزل الحديث',
        'date': '24 مايو 2024',
        'price': '\$1,200.00',
        'status': 'قيد المعالجة',
      },
      {
        'id': '#ORD-2811',
        'factory': 'شركة المنسوجات الراقية',
        'date': '22 مايو 2024',
        'price': '\$3,450.00',
        'status': 'تم التوصيل',
      },
      {
        'id': '#ORD-2756',
        'factory': 'أقمشة الشرق الأوسط',
        'date': '21 مايو 2024',
        'price': '\$890.00',
        'status': 'قيد المعالجة',
      },
    ];

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Expanded(
                  flex: 3,
                  child: Text(
                    'الطلب / المصنع',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'التاريخ',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'القيمة',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Text(
                    'الحالة',
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurfaceVariant),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.outlineVariant),
          ListView.separated(
            itemCount: mockOrders.length,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) => const Divider(height: 1, color: AppColors.outlineVariant),
            itemBuilder: (context, index) {
              final order = mockOrders[index];
              final isDelivered = order['status'] == 'تم التوصيل';
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order['factory']!,
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            order['id']!,
                            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        order['date']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Text(
                        order['price']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: isDelivered
                                ? AppColors.primaryContainer.withValues(alpha: 0.1)
                                : AppColors.secondaryContainer.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            order['status']!,
                            style: TextStyle(
                              fontSize: 9,
                              fontWeight: FontWeight.bold,
                              color: isDelivered ? AppColors.primary : AppColors.secondary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
