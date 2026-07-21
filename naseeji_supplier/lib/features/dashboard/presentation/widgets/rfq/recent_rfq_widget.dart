import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/status_badge_widget.dart';
import '../shared/dashboard_loading_widget.dart';
import '../shared/dashboard_empty_state_widget.dart';

class RecentRFQWidget extends ConsumerWidget {
  const RecentRFQWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rfqAsync = ref.watch(rfqOverviewProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'أحدث طلبات عروض الأسعار (RFQs)',
          subtitle: 'طلبات التوريد الواردة من المشتريين',
          icon: Icons.request_quote_rounded,
          actionText: 'عرض الكل',
          onActionTap: () => context.push('/orders'),
        ),
        rfqAsync.when(
          loading: () => const DashboardLoadingWidget(height: 220),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل RFQs: $err'),
          ),
          data: (rfqs) {
            if (rfqs.isEmpty) {
              return const DashboardEmptyStateWidget(
                title: 'لا توجد طلبات أسعار جارية',
                description: 'سيتم ظهور طلبات التوريد الجديدة من العملاء هنا فور ورودها.',
                icon: Icons.assignment_outlined,
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: rfqs.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final rfq = rfqs[index];
                return DashboardCardWidget(
                  padding: const EdgeInsets.all(14),
                  onTap: () => context.push('/orders/rfq-details/${rfq.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ID & Badges
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                rfq.id,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 8),
                              StatusBadgeWidget.priority(rfq.priority.name),
                            ],
                          ),
                          StatusBadgeWidget.rfqStatus(rfq.status.name),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Title
                      Text(
                        rfq.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),

                      // Details Row: Buyer, Fabric, Quantity, Deadline
                      Wrap(
                        spacing: 16,
                        runSpacing: 6,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.business_rounded, size: 14, color: colorScheme.outline),
                              const SizedBox(width: 4),
                              Text(
                                rfq.buyerName,
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.inventory_rounded, size: 14, color: colorScheme.outline),
                              const SizedBox(width: 4),
                              Text(
                                '${rfq.fabricType} • ${rfq.quantity}',
                                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
                              ),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.timer_outlined, size: 14, color: Colors.orange.shade800),
                              const SizedBox(width: 4),
                              Text(
                                rfq.remainingTimeFormatted,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange.shade800,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),
                      Divider(
                        color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                      ),
                      const SizedBox(height: 6),

                      // Quick Action Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton.icon(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم رفض الطلب ${rfq.id}')),
                              );
                            },
                            icon: const Icon(Icons.close_rounded, size: 16),
                            label: const Text('رفض'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          ElevatedButton.icon(
                            onPressed: () => context.push('/orders/create-offer/${rfq.id}'),
                            icon: const Icon(Icons.send_rounded, size: 16),
                            label: const Text('تقديم عرض سعر'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                          ),
                          const SizedBox(width: 8),
                          IconButton(
                            onPressed: () => context.push('/orders/rfq-details/${rfq.id}'),
                            icon: const Icon(Icons.open_in_new_rounded, size: 18),
                            tooltip: 'فتح التفاصيل',
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
