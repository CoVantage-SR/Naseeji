import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../../../financial/presentation/widgets/financial_summary_card.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class AdvertisementReportScreen extends ConsumerWidget {
  const AdvertisementReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير الإعلانات',
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
          final totalViews = data.adPerformance.fold<int>(0, (s, e) => s + (e['views'] as int? ?? 0));
          final totalClicks = data.adPerformance.fold<int>(0, (s, e) => s + (e['clicks'] as int? ?? 0));
          final totalLeads = data.adPerformance.fold<int>(0, (s, e) => s + (e['leads'] as int? ?? 0));
          final totalOrders = data.adPerformance.fold<int>(0, (s, e) => s + (e['orders'] as int? ?? 0));
          final totalRevenue = data.adPerformance.fold<double>(0, (s, e) => s + ((e['revenue'] as num?)?.toDouble() ?? 0));
          final avgCtr = data.adPerformance.isNotEmpty
              ? data.adPerformance.fold<double>(0, (s, e) => s + ((e['ctr'] as num?)?.toDouble() ?? 0)) / data.adPerformance.length
              : 0.0;
          final avgRoi = data.adPerformance.isNotEmpty
              ? data.adPerformance.fold<double>(0, (s, e) => s + ((e['roi'] as num?)?.toDouble() ?? 0)) / data.adPerformance.length
              : 0.0;

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
                  ReportSectionHeader(title: 'ملخص الإعلانات', icon: Icons.campaign_outlined, iconColor: const Color(0xFFEC4899)),
                  const SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 1.35,
                    children: [
                      FinancialSummaryCard(title: 'إعلانات نشطة', value: data.activeAds.toDouble(), currency: 'إعلان', icon: Icons.play_circle_outline, iconColor: const Color(0xFF00875A)),
                      FinancialSummaryCard(title: 'إعلانات منتهية', value: data.finishedCampaigns.toDouble(), currency: 'إعلان', icon: Icons.stop_circle_outlined, iconColor: const Color(0xFF6366F1)),
                      FinancialSummaryCard(title: 'إجمالي المشاهدات', value: totalViews.toDouble(), currency: '', icon: Icons.visibility_outlined, iconColor: const Color(0xFF0040E0)),
                      FinancialSummaryCard(title: 'إجمالي النقرات', value: totalClicks.toDouble(), currency: '', icon: Icons.touch_app_outlined, iconColor: const Color(0xFF0891B2)),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Performance Stats
                  ReportSectionHeader(title: 'مؤشرات الأداء التسويقي', icon: Icons.analytics_outlined),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('معدل النقر (CTR)', '${avgCtr.toStringAsFixed(2)}%', Icons.ads_click_outlined, const Color(0xFF0891B2)),
                    _Stat('الاستفسارات (Leads)', totalLeads.toString(), Icons.contact_phone_outlined, const Color(0xFF7C3AED)),
                    _Stat('طلبات من الإعلانات', totalOrders.toString(), Icons.shopping_cart_outlined, const Color(0xFF00875A)),
                    _Stat('إيرادات الإعلانات', '${totalRevenue.toStringAsFixed(0)} ج', Icons.monetization_on_outlined, const Color(0xFFD97706)),
                    _Stat('متوسط العائد (ROI)', '${avgRoi.toStringAsFixed(1)}x', Icons.trending_up, const Color(0xFF00875A)),
                  ]),
                  const SizedBox(height: 20),

                  // Top Ads
                  ReportSectionHeader(title: 'أفضل الإعلانات أداءً', icon: Icons.workspace_premium_outlined, iconColor: const Color(0xFFEC4899)),
                  const SizedBox(height: 12),
                  ...data.adPerformance.asMap().entries.map((entry) {
                    final i = entry.key;
                    final ad = entry.value;
                    return _buildAdCard(context, i + 1, ad);
                  }),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAdCard(BuildContext context, int rank, Map<String, dynamic> ad) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEC4899).withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(ad['title'] as String? ?? '', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13), textAlign: TextAlign.right),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _AdStat('${ad['roi'] ?? 0}x', 'ROI', const Color(0xFF00875A)),
              _AdStat('${ad['ctr'] ?? 0}%', 'CTR', const Color(0xFF0040E0)),
              _AdStat('${ad['orders'] ?? 0}', 'طلبات', const Color(0xFF7C3AED)),
              _AdStat('${(ad['revenue'] as num? ?? 0).toStringAsFixed(0)} ج', 'إيراد', const Color(0xFFD97706)),
            ],
          ),
        ],
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

class _AdStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _AdStat(this.value, this.label, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: color)),
        Text(label, style: const TextStyle(fontSize: 10, color: AppColors.outline)),
      ],
    );
  }
}

class _Stat {
  final String label, value;
  final IconData icon;
  final Color color;
  const _Stat(this.label, this.value, this.icon, this.color);
}

