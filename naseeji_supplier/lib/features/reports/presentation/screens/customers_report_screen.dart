import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_chart_widget.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class CustomersReportScreen extends ConsumerWidget {
  const CustomersReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير العملاء',
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
          final totalCustomers = data.newCustomers + data.returningCustomers;
          final repeatRate = totalCustomers > 0
              ? (data.returningCustomers / totalCustomers * 100).toStringAsFixed(1)
              : '0.0';
          final avgPurchase = data.totalOrders > 0
              ? data.averageOrderValue.toStringAsFixed(0)
              : '0';

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

                  // KPI Cards
                  ReportSectionHeader(title: 'ملخص العملاء', icon: Icons.people_outline, iconColor: const Color(0xFF0891B2)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(title: 'إجمالي العملاء', value: totalCustomers.toDouble(), currency: 'عميل', icon: Icons.people_outline, iconColor: const Color(0xFF0891B2)),
                      FinancialSummaryCard(title: 'عملاء جدد', value: data.newCustomers.toDouble(), currency: 'عميل', trend: '+15%', isPositive: true, icon: Icons.person_add_outlined, iconColor: const Color(0xFF00875A)),
                      FinancialSummaryCard(title: 'عملاء عائدون', value: data.returningCustomers.toDouble(), currency: 'عميل', icon: Icons.replay_outlined, iconColor: const Color(0xFF7C3AED)),
                      FinancialSummaryCard(title: 'متوسط قيمة الشراء', value: double.tryParse(avgPurchase) ?? 0, currency: 'ج', icon: Icons.shopping_cart_outlined, iconColor: const Color(0xFFD97706)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Performance Stats
                  ReportSectionHeader(title: 'مؤشرات ولاء العملاء', icon: Icons.loyalty_outlined),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('معدل التكرار', '$repeatRate%', Icons.repeat_outlined, const Color(0xFF7C3AED)),
                    _Stat('أعلى إنفاقاً', 'شركة الأقمشة المتطورة', Icons.emoji_events_outlined, const Color(0xFFD97706)),
                    _Stat('متوسط الطلبات/عميل', '${(data.totalOrders / (totalCustomers == 0 ? 1 : totalCustomers)).toStringAsFixed(1)}', Icons.analytics_outlined, const Color(0xFF0891B2)),
                  ]),
                  const SizedBox(height: 20),

                  // Growth Chart
                  ReportSectionHeader(title: 'نمو العملاء خلال الفترة', icon: Icons.trending_up),
                  const SizedBox(height: 12),
                  FinancialChartWidget(
                    title: 'نمو قاعدة العملاء',
                    data: data.customersGrowth.map((e) => {'month': e['label'] ?? '', 'value': (e['value'] as int? ?? 0).toDouble()}).toList(),
                    type: 'bar',
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

  Widget _buildStatCard(BuildContext context, List<_Stat> stats) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: stats.expand((s) => [
          ReportStatRow(label: s.label, value: s.value, icon: s.icon, iconColor: s.color),
          if (s != stats.last) const ReportStatDivider(),
        ]).toList(),
      ),
    );
  }
}

class _Stat {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
}
