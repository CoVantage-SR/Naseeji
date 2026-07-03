import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../controllers/dashboard_controller.dart';

class AnalyticsScreen extends ConsumerWidget {
  const AnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statsAsync = ref.watch(dashboardControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('تحليل المبيعات'),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.onSurface,
        elevation: 0.5,
      ),
      body: statsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('خطأ: $err')),
        data: (stats) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Highlight Cards
                Row(
                  children: [
                    Expanded(
                      child: _buildMetricHighlight(
                        label: 'إجمالي الإيرادات',
                        value: '\$${stats.monthlyEarnings.toStringAsFixed(0)}',
                        icon: Icons.account_balance_wallet,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildMetricHighlight(
                        label: 'نسبة النمو الأسبوعي',
                        value: '12.4%',
                        icon: Icons.trending_up,
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Weekly Performance Chart Section
                const Text(
                  'أداء المبيعات الأسبوعي',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Container(
                  height: 200,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: CustomPaint(
                          size: Size.infinite,
                          painter: BarChartPainter(stats.weeklySales),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text('س', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('ح', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('ن', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('ث', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('ر', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('خ', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                          Text('ج', style: TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Top Categories
                const Text(
                  'أكثر الفئات طلباً هذا الشهر',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                _buildCategoryRow('أقمشة قطنية', '58% من إجمالي الطلبات', 0.58, AppColors.primary),
                const SizedBox(height: 12),
                _buildCategoryRow('أقمشة كتان', '24% من إجمالي الطلبات', 0.24, AppColors.secondary),
                const SizedBox(height: 12),
                _buildCategoryRow('خيوط وغزل', '18% من إجمالي الطلبات', 0.18, AppColors.tertiary),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMetricHighlight({
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryRow(String name, String desc, double percentage, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.between,
            children: [
              Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
              Text('${(percentage * 100).toStringAsFixed(0)}%', style: TextStyle(color: color, fontWeight: FontWeight.bold)),
            ],
          ),
          const SizedBox(height: 4),
          Text(desc, style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: percentage,
            color: color,
            backgroundColor: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }
}

class BarChartPainter extends CustomPainter {
  final List<double> data;

  BarChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    final maxVal = data.reduce((a, b) => a > b ? a : b);
    final range = maxVal == 0 ? 1 : maxVal;
    
    final barWidth = size.width / (data.length * 1.6);
    final spacing = (size.width - (barWidth * data.length)) / (data.length - 1);

    for (int i = 0; i < data.length; i++) {
      final height = (data[i] / range) * (size.height - 20);
      final left = i * (barWidth + spacing);
      final top = size.height - height;
      
      final rect = RRect.fromRectAndRadius(
        Rect.fromLTWH(left, top, barWidth, height),
        const Radius.circular(6),
      );

      // Alternate color style for accent look
      paint.color = i % 2 == 0 ? AppColors.primary : AppColors.secondary;
      canvas.drawRRect(rect, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
