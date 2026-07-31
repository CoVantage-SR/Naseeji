import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_chart_widget.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class SalesReportScreen extends ConsumerWidget {
  const SalesReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);
    final filter = ref.watch(analyticsReportFilterProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير المبيعات',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports'),
        ),
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) {
          final isCustom = filter.dateFilter == DateFilterType.custom;
          final filterLabel = isCustom ? 'نطاق مخصص' : _filterLabel(filter.dateFilter);

          return RefreshIndicator(
            color: AppColors.primary,
            onRefresh: () => ref.refresh(analyticsReportDataProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const ReportFilterBar(),
                  const SizedBox(height: 20),

                  // Summary Cards
                  ReportSectionHeader(title: 'ملخص المبيعات - $filterLabel', icon: Icons.show_chart, iconColor: AppColors.primary),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(
                        title: 'إجمالي المبيعات',
                        value: data.totalSales,
                        trend: '+${data.revenueGrowth.toStringAsFixed(1)}%',
                        isPositive: true,
                        icon: Icons.monetization_on_outlined,
                        iconColor: AppColors.primary,
                      ),
                      FinancialSummaryCard(
                        title: 'صافي الأرباح',
                        value: data.netProfit,
                        trend: '+12.5%',
                        isPositive: true,
                        icon: Icons.trending_up,
                        iconColor: const Color(0xFF00875A),
                      ),
                      FinancialSummaryCard(
                        title: 'إجمالي الأرباح',
                        value: data.grossProfit,
                        icon: Icons.bar_chart_outlined,
                        iconColor: const Color(0xFF6366F1),
                      ),
                      FinancialSummaryCard(
                        title: 'متوسط قيمة الطلب',
                        value: data.averageOrderValue,
                        icon: Icons.shopping_bag_outlined,
                        iconColor: const Color(0xFFD97706),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Stats
                  _buildStatCard(context, [
                    _StatEntry('أفضل يوم مبيعات', data.topSalesDay, Icons.calendar_today_outlined, const Color(0xFF0040E0)),
                    _StatEntry('أفضل شهر مبيعات', data.topSalesMonth, Icons.calendar_month_outlined, const Color(0xFF00875A)),
                    _StatEntry('نسبة النمو', '+${data.revenueGrowth.toStringAsFixed(1)}%', Icons.trending_up, const Color(0xFF16A34A)),
                    _StatEntry('الطلبات المكتملة', data.completedOrders.toString(), Icons.check_circle_outline, const Color(0xFF0891B2)),
                  ]),
                  const SizedBox(height: 20),

                  // Charts
                  ReportSectionHeader(title: 'مخطط المبيعات اليومية', icon: Icons.bar_chart_outlined),
                  const SizedBox(height: 12),
                  FinancialChartWidget(
                    title: 'اتجاه المبيعات خلال الفترة',
                    data: data.salesTrend.map((e) => {'month': e['label'] ?? '', 'value': e['value'] ?? 0.0}).toList(),
                    type: 'bar',
                  ),
                  const SizedBox(height: 16),
                  FinancialChartWidget(
                    title: 'الإيرادات مقابل المصروفات',
                    data: data.revenueExpensesTrend.map((e) => {
                      'label': e['label'] ?? '',
                      'inflow': e['revenue'] ?? 0.0,
                      'outflow': e['expenses'] ?? 0.0,
                    }).toList(),
                    type: 'double_bar',
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, List<_StatEntry> entries) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: entries.expand((e) => [
          ReportStatRow(label: e.label, value: e.value, icon: e.icon, iconColor: e.color),
          if (e != entries.last) const ReportStatDivider(),
        ]).toList(),
      ),
    );
  }

  String _filterLabel(DateFilterType type) {
    const map = {
      DateFilterType.today: 'اليوم',
      DateFilterType.yesterday: 'أمس',
      DateFilterType.last7Days: 'آخر 7 أيام',
      DateFilterType.last30Days: 'آخر 30 يوم',
      DateFilterType.last3Months: 'آخر 3 أشهر',
      DateFilterType.last6Months: 'آخر 6 أشهر',
      DateFilterType.currentYear: 'هذا العام',
      DateFilterType.custom: 'مخصص',
    };
    return map[type] ?? '';
  }
}

class _StatEntry {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatEntry(this.label, this.value, this.icon, this.color);
}



