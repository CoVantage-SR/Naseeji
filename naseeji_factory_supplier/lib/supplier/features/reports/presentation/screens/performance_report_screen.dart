import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_progress_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class PerformanceReportScreen extends ConsumerWidget {
  const PerformanceReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير الأداء العام',
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
          final acceptanceRate = data.totalOrders > 0
              ? data.completedOrders / data.totalOrders
              : 0.0;
          final cancellationRate = data.totalOrders > 0
              ? data.cancelledOrders / data.totalOrders
              : 0.0;
          final fulfillmentRate = 1.0 - cancellationRate;

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

                  // Score Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [AppColors.primary, AppColors.primary.withValues(alpha: 0.8)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('درجة الأداء العامة', style: TextStyle(color: Colors.white70, fontSize: 12)),
                            const SizedBox(height: 4),
                            Text(
                              '${(data.winRate * 0.95 + data.averageRating * 5).toStringAsFixed(0)} / 100',
                              style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        const Spacer(),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(children: [
                              const Icon(Icons.star, color: Colors.amber, size: 16),
                              Text(' ${data.averageRating.toStringAsFixed(1)}', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                            ]),
                            const Text('متوسط التقييم', style: TextStyle(color: Colors.white70, fontSize: 10)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // KPI Cards
                  ReportSectionHeader(title: 'مؤشرات الأداء', icon: Icons.speed_outlined, iconColor: const Color(0xFFB45309)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(title: 'معدل الفوز بالصفقات', value: data.winRate, currency: '%', icon: Icons.emoji_events_outlined, iconColor: const Color(0xFF00875A)),
                      FinancialSummaryCard(title: 'سرعة الاستجابة', value: data.averageResponseTimeHours, currency: 'ساعة', icon: Icons.flash_on_outlined, iconColor: const Color(0xFFD97706)),
                      FinancialSummaryCard(title: 'معدل نمو الإيرادات', value: data.revenueGrowth, currency: '%', icon: Icons.trending_up, iconColor: const Color(0xFF0040E0)),
                      FinancialSummaryCard(title: 'تقييم العملاء', value: data.averageRating, currency: '/ 5', icon: Icons.star_outline, iconColor: const Color(0xFFF59E0B)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Performance Rates
                  ReportSectionHeader(title: 'معدلات الأداء الشاملة', icon: Icons.bar_chart_outlined),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: [
                        ReportProgressBar(label: 'معدل قبول الطلبات', value: acceptanceRate, valueLabel: '${(acceptanceRate * 100).toStringAsFixed(1)}%', barColor: const Color(0xFF00875A)),
                        ReportProgressBar(label: 'معدل إتمام الطلبات', value: fulfillmentRate, valueLabel: '${(fulfillmentRate * 100).toStringAsFixed(1)}%', barColor: const Color(0xFF0040E0)),
                        ReportProgressBar(label: 'معدل الفوز بالمفاوضات', value: data.winRate / 100, valueLabel: '${data.winRate.toStringAsFixed(1)}%', barColor: const Color(0xFF7C3AED)),
                        ReportProgressBar(label: 'رضا العملاء', value: data.averageRating / 5, valueLabel: '${data.averageRating.toStringAsFixed(1)} / 5', barColor: const Color(0xFFF59E0B)),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Details
                  ReportSectionHeader(title: 'تفاصيل أخرى', icon: Icons.info_outline),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('حملات إعلانية نشطة', data.activeCampaigns.toString(), Icons.campaign_outlined, const Color(0xFFEC4899)),
                    _Stat('حملات منتهية', data.finishedCampaigns.toString(), Icons.check_circle_outline, const Color(0xFF6366F1)),
                    _Stat('أفضل شهر مبيعات', data.topSalesMonth, Icons.calendar_month_outlined, const Color(0xFF00875A)),
                    _Stat('أفضل يوم مبيعات', data.topSalesDay, Icons.today_outlined, const Color(0xFF0040E0)),
                  ]),
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

