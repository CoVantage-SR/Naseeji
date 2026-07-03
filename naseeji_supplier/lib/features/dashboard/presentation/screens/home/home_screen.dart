import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/dashboard_controller.dart';
import '../drawer/navigation_drawer_view.dart';

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
                      _buildStatCard(
                        title: 'مبيعات اليوم',
                        value: '\$${stats.todaySales.toStringAsFixed(0)}',
                        trend: '+12%',
                        color: AppColors.primary,
                        icon: Icons.trending_up,
                      ),
                      _buildStatCard(
                        title: 'الإيرادات الشهرية',
                        value: '\$${(stats.monthlyEarnings / 1000).toStringAsFixed(0)}k',
                        trend: '+8%',
                        color: AppColors.secondary,
                        icon: Icons.trending_up,
                      ),
                      _buildStatCard(
                        title: 'طلبات معلقة',
                        value: stats.pendingOrders.toString(),
                        trend: 'تحتاج انتباه',
                        color: AppColors.tertiary,
                        icon: Icons.priority_high,
                        isWarning: true,
                      ),
                      _buildStatCard(
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
                      _buildQuickAction(
                        icon: Icons.add_box,
                        label: 'إضافة منتج',
                        backgroundColor: AppColors.primaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.primary,
                        onTap: () {},
                      ),
                      _buildQuickAction(
                        icon: Icons.shopping_bag,
                        label: 'الطلبات',
                        backgroundColor: AppColors.secondaryContainer.withValues(alpha: 0.1),
                        iconColor: AppColors.secondary,
                        onTap: () {},
                      ),
                      _buildQuickAction(
                        icon: Icons.request_quote,
                        label: 'الفواتير',
                        backgroundColor: AppColors.surfaceContainerHigh,
                        iconColor: AppColors.onSurfaceVariant,
                        onTap: () {},
                      ),
                      _buildQuickAction(
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

  Widget _buildStatCard({
    required String title,
    required String value,
    required String trend,
    required Color color,
    required IconData icon,
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: color, width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isWarning ? AppColors.tertiary : color,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                icon,
                size: 12,
                color: isWarning ? AppColors.error : AppColors.secondary,
              ),
              const SizedBox(width: 4),
              Text(
                trend,
                style: TextStyle(
                  fontSize: 10,
                  color: isWarning ? AppColors.error : AppColors.secondary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildQuickAction({
    required IconData icon,
    required String label,
    required Color backgroundColor,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 24),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}

class LineChartPainter extends CustomPainter {
  final List<double> data;

  LineChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paintLine = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;

    final paintFill = Paint()
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppColors.primary.withValues(alpha: 0.25),
          AppColors.primary.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));

    final path = Path();
    final stepX = size.width / (data.length - 1);
    
    // Normalize data points to fit scale
    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final minVal = data.reduce((a, b) => a < b ? a : b);
    final range = maxVal - minVal == 0 ? 1 : maxVal - minVal;

    double getX(int index) => index * stepX;
    double getY(double val) {
      final normalized = (val - minVal) / range;
      // Invert Y axis for screen space
      return size.height - (normalized * (size.height - 20) + 10);
    }

    path.moveTo(getX(0), getY(data[0]));
    for (int i = 1; i < data.length; i++) {
      path.lineTo(getX(i), getY(data[i]));
    }

    final fillPath = Path.from(path);
    fillPath.lineTo(size.width, size.height);
    fillPath.lineTo(0, size.height);
    fillPath.close();

    canvas.drawPath(fillPath, paintFill);
    canvas.drawPath(path, paintLine);

    // Draw bullet points on lines
    final paintCircle = Paint()..color = AppColors.primary;
    for (int i = 0; i < data.length; i += 2) {
      canvas.drawCircle(Offset(getX(i), getY(data[i])), 4, paintCircle);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
