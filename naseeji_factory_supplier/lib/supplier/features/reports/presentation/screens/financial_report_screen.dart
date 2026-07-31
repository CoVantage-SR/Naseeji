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

class FinancialReportScreen extends ConsumerWidget {
  const FinancialReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('التقرير المالي',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_outlined, color: AppColors.primary, size: 20),
            tooltip: 'لوحة المالية',
            onPressed: () => context.go('/finance'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) {
          final expenses = data.grossProfit - data.netProfit;
          final taxes = data.totalSales * 0.06;
          final fees = data.totalSales * 0.02;
          final commissions = data.totalSales * 0.03;
          final pendingPayments = data.pendingOrders * data.averageOrderValue;
          final refunds = data.cancelledOrders * data.averageOrderValue * 0.5;

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
                  ReportSectionHeader(title: 'الملخص المالي', icon: Icons.account_balance_outlined, iconColor: const Color(0xFF00875A)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(title: 'الإيرادات', value: data.totalSales, trend: '+${data.revenueGrowth.toStringAsFixed(1)}%', isPositive: true, icon: Icons.monetization_on_outlined, iconColor: const Color(0xFF00875A)),
                      FinancialSummaryCard(title: 'صافي الأرباح', value: data.netProfit, icon: Icons.trending_up, iconColor: const Color(0xFF0040E0)),
                      FinancialSummaryCard(title: 'مدفوعات معلقة', value: pendingPayments, icon: Icons.pending_outlined, iconColor: const Color(0xFFB45309)),
                      FinancialSummaryCard(title: 'رصيد المحفظة', value: data.walletBalance, icon: Icons.account_balance_wallet_outlined, iconColor: const Color(0xFF0284C7)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Detailed financials
                  ReportSectionHeader(title: 'تفاصيل المصروفات والرسوم', icon: Icons.list_alt_outlined),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('إجمالي المصروفات', '${expenses.toStringAsFixed(0)} ج', Icons.trending_down, const Color(0xFFDE350B)),
                    _Stat('الضرائب (6%)', '${taxes.toStringAsFixed(0)} ج', Icons.receipt_outlined, const Color(0xFFB45309)),
                    _Stat('رسوم المنصة (2%)', '${fees.toStringAsFixed(0)} ج', Icons.percent_outlined, const Color(0xFF6366F1)),
                    _Stat('العمولات (3%)', '${commissions.toStringAsFixed(0)} ج', Icons.handshake_outlined, const Color(0xFF0891B2)),
                    _Stat('مبالغ مستردة', '${refunds.toStringAsFixed(0)} ج', Icons.replay_outlined, const Color(0xFFD97706)),
                  ]),
                  const SizedBox(height: 20),

                  // Charts
                  ReportSectionHeader(title: 'الإيرادات مقابل المصروفات', icon: Icons.bar_chart_outlined),
                  const SizedBox(height: 12),
                  FinancialChartWidget(
                    title: 'التدفق النقدي خلال الفترة',
                    data: data.revenueExpensesTrend.map((e) => {
                      'label': e['label'] ?? '',
                      'inflow': e['revenue'] ?? 0.0,
                      'outflow': e['expenses'] ?? 0.0,
                    }).toList(),
                    type: 'double_bar',
                  ),
                  const SizedBox(height: 16),
                  FinancialChartWidget(
                    title: 'نمو الإيرادات',
                    data: data.salesTrend.map((e) => {'month': e['label'] ?? '', 'value': e['value'] ?? 0.0}).toList(),
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


