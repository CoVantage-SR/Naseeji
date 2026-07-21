import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/dashboard_loading_widget.dart';

class PerformanceOverviewWidget extends ConsumerWidget {
  const PerformanceOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final perfAsync = ref.watch(performanceProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'تقييم وأداء المورد',
          subtitle: 'مؤشرات التقييم، سرعة الاستجابة والجودة',
          icon: Icons.star_rate_rounded,
          actionText: 'تقرير الأداء',
          onActionTap: () => context.push('/analytics'),
        ),
        perfAsync.when(
          loading: () => const DashboardLoadingWidget(height: 180),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل بيانات الأداء: $err'),
          ),
          data: (perf) {
            return DashboardCardWidget(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Main Rating & Customer Satisfaction Header
                  Row(
                    children: [
                      // Overall Supplier Rating Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        decoration: BoxDecoration(
                          color: Colors.amber.shade50,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: Colors.amber.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.star_rounded, color: Colors.amber.shade800, size: 28),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${perf.supplierRating}',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.amber.shade900,
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  'التقييم العام للمورد',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.amber.shade900,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Customer Satisfaction Gauge
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'رضا العملاء (Satisfaction)',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${perf.customerSatisfaction}%',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 14),

                  // Metric Bars & Counts Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          context,
                          label: 'معدل سرعة الاستجابة',
                          value: '${perf.responseRate}%',
                          icon: Icons.speed_rounded,
                          color: const Color(0xFF009688),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricTile(
                          context,
                          label: 'الالتزام بمواعيد الشحن',
                          value: '${perf.onTimeDeliveryRate}%',
                          icon: Icons.timelapse_rounded,
                          color: const Color(0xFF0040E0),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          context,
                          label: 'عروض مقبولة / مرفوضة',
                          value: '${perf.acceptedQuotations} / ${perf.rejectedQuotations}',
                          icon: Icons.rate_review_outlined,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildMetricTile(
                          context,
                          label: 'إجمالي الطلبات المكتملة',
                          value: '${perf.completedOrders} طلب',
                          icon: Icons.task_alt_rounded,
                          color: const Color(0xFF673AB7),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
