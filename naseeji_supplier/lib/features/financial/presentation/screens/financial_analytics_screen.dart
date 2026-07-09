import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/financial_chart_widget.dart';
import '../widgets/financial_summary_card.dart';

class FinancialAnalyticsScreen extends ConsumerWidget {
  const FinancialAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsAsync = ref.watch(financialAnalyticsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'التحليلات والمؤشرات المالية',
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
                    // Summary grid
                    Text(
                      'مؤشرات الأداء المالي الرئيسيّة (KPIs)',
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
                      childAspectRatio: 1.35,
                      children: [
                        FinancialSummaryCard(
                          title: 'إجمالي الإيرادات',
                          value: data.totalRevenue,
                          trend: '+${data.revenueGrowth}%',
                          isPositive: true,
                          icon: Icons.monetization_on_outlined,
                        ),
                        FinancialSummaryCard(
                          title: 'صافي الأرباح',
                          value: data.netProfit,
                          trend: '+${data.profitGrowth}%',
                          isPositive: true,
                          icon: Icons.trending_up,
                        ),
                        FinancialSummaryCard(
                          title: 'متوسط قيمة الطلب',
                          value: data.averageOrderValue,
                          icon: Icons.shopping_basket_outlined,
                        ),
                        FinancialSummaryCard(
                          title: 'هامش الربح التشغيلي',
                          value: data.profitMargin,
                          currency: '٪',
                          icon: Icons.pie_chart_outline,
                        ),
                      ],
                    ),
                    SizedBox(height: 20),

                    // Additional KPIs card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildKpiRow('متوسط فترة التسوية البنكية', '${data.averageSettlementTime} أيام', Icons.calendar_month, const Color(0xFF0052CC)),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildKpiRow('معدل نجاح الدفعات الإلكترونية', '${data.paymentSuccessRate}٪', Icons.check_circle_outline, const Color(0xFF00875A)),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildKpiRow('معدل تحصيل الفواتير المفتوحة', '${data.collectionRate}٪', Icons.account_balance_wallet_outlined, const Color(0xFFB17000)),
                          const Divider(height: 24, color: AppColors.outlineVariant),
                          _buildKpiRow('نسبة طلبات المرتجعات والتعويض', '${data.refundRate}٪', Icons.assignment_return_outlined, const Color(0xFFBA1A1A)),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),

                    // Charts
                    FinancialChartWidget(
                      title: 'إيرادات المبيعات مقابل صافي الربح',
                      data: data.revenueTrend,
                      type: 'bar',
                    ),
                    SizedBox(height: 16),

                    FinancialChartWidget(
                      title: 'التدفقات النقدية اليومية (صادر / وارد)',
                      data: data.cashFlow,
                      type: 'double_bar',
                    ),
                    SizedBox(height: 16),

                    FinancialChartWidget(
                      title: 'توزيع المبيعات بحسب فئة المنتج',
                      data: data.revenueByProduct,
                      type: 'donut',
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

  Widget _buildKpiRow(String label, String value, IconData icon, Color color) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        Row(
          children: [
            Text(
              label,
              style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
            SizedBox(width: 8),
            Icon(icon, color: color, size: 18),
          ],
        ),
      ],
    );
  }
}