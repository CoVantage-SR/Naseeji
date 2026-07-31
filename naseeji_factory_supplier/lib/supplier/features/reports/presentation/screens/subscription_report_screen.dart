import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../../dashboard/presentation/controllers/analytics_report_controller.dart';
import '../widgets/report_filter_bar.dart';
import '../widgets/report_progress_bar.dart';
import '../widgets/report_section_header.dart';
import '../widgets/report_stat_row.dart';

class SubscriptionReportScreen extends ConsumerWidget {
  const SubscriptionReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dataAsync = ref.watch(analyticsReportDataProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0.5,
        title: Text('تقرير الاشتراك',
            style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16)),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.canPop() ? context.pop() : context.go('/reports'),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.workspace_premium_outlined, color: AppColors.primary, size: 20),
            tooltip: 'لوحة الاشتراك',
            onPressed: () => context.go('/subscription'),
          ),
        ],
      ),
      body: dataAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(color: AppColors.primary)),
        error: (e, _) => Center(child: Text('خطأ: $e')),
        data: (data) {
          final usageItems = data.subscriptionUsage;

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

                  // Plan Info Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF059669), Color(0xFF047857)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text('نشط', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                            ),
                            const Icon(Icons.workspace_premium, color: Colors.white, size: 28),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(data.currentSubscriptionPlan, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        const Text('الخطة الحالية', style: TextStyle(color: Colors.white70, fontSize: 12)),
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('تجديد: 2026-08-01', style: TextStyle(color: Colors.white.withValues(alpha: 0.8), fontSize: 11)),
                            const Text('متبقي: 20 يوم', style: TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Usage section
                  ReportSectionHeader(title: 'استخدام الموارد والحدود', icon: Icons.data_usage_outlined, iconColor: const Color(0xFF059669)),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surface,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                    ),
                    child: Column(
                      children: usageItems.map((item) {
                        final percent = (item['percent'] as num?)?.toDouble() ?? 0.0;
                        final label = item['resource'] as String? ?? '';
                        final used = item['used'];
                        final max = item['max'];
                        return ReportProgressBar(
                          label: label,
                          value: percent,
                          valueLabel: '$used / $max',
                          barColor: percent >= 0.8
                              ? const Color(0xFFDE350B)
                              : percent >= 0.6
                                  ? const Color(0xFFD97706)
                                  : const Color(0xFF059669),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Summary Stats
                  ReportSectionHeader(title: 'تفاصيل الخطة', icon: Icons.info_outline),
                  const SizedBox(height: 12),
                  _buildStatCard(context, [
                    _Stat('الخطة الحالية', data.currentSubscriptionPlan, Icons.workspace_premium_outlined, const Color(0xFF059669)),
                    _Stat('تاريخ التجديد', '2026-08-01', Icons.calendar_today_outlined, const Color(0xFF0040E0)),
                    _Stat('الأيام المتبقية', '20 يوم', Icons.hourglass_bottom_outlined, const Color(0xFFD97706)),
                    _Stat('الإعلانات النشطة', data.activeAds.toString(), Icons.campaign_outlined, const Color(0xFFEC4899)),
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


