import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/financial_chart_widget.dart';

class EarningsScreen extends ConsumerWidget {
  const EarningsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(financialAnalyticsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'أرباح وإيرادات المؤسسة',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: analyticsAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (data) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () => ref.read(financialAnalyticsControllerProvider.notifier).refresh(),
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Grid of standard cards
                    Text(
                      'الملخص المالي للأرباح',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 1.5,
                      children: [
                        _buildEarningMetricCard('أرباح اليوم', '2,500.00 جنيه', const Color(0xFF00875A)),
                        _buildEarningMetricCard('أرباح هذا الأسبوع', '12,400.00 جنيه', const Color(0xFF0052CC)),
                        _buildEarningMetricCard('أرباح هذا الشهر', '${data.monthlyComparison[0]['revenue']?.toStringAsFixed(2)} جنيه', AppColors.primary),
                        _buildEarningMetricCard('أرباح العام الحالي', '${(data.totalRevenue * 0.85).toStringAsFixed(2)} جنيه', const Color(0xFF993100)),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Lifetime stats banner
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${data.totalRevenue.toStringAsFixed(2)} جنيه',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Text(
                            'إجمالي الأرباح منذ التأسيس',
                            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Bar Chart Revenue Trend
                    FinancialChartWidget(
                      title: 'اتجاه الإيرادات والنمو الشهري',
                      data: data.revenueTrend,
                      type: 'bar',
                    ),
                    SizedBox(height: 16),

                    // Donut Chart - Best selling products
                    FinancialChartWidget(
                      title: 'أعلى الفئات مبيعاً وتوريداً',
                      data: data.revenueByProduct,
                      type: 'donut',
                    ),
                    SizedBox(height: 16),

                    // Customer breakdowns
                    Text(
                      'أكبر المصانع المتعاملة والطلب',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: data.revenueByCustomer.map((cust) {
                          final valStr = '${(cust['value'] as double).toStringAsFixed(0)} جنيه';
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  valStr,
                                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                ),
                                Text(
                                  cust['customer'] as String,
                                  style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEarningMetricCard(String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(label, style: TextStyle(fontSize: 11, color: AppColors.outline)),
              SizedBox(width: 4),
              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
            ],
          ),
          SizedBox(height: 8),
          Text(
            value,
            textAlign: TextAlign.right,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}
