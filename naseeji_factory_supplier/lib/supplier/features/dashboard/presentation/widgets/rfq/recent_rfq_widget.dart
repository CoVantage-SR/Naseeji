import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/status_badge_widget.dart';
import '../shared/loading_widget.dart';
import '../shared/empty_state_widget.dart';
import '../shared/error_state_widget.dart';

class RecentRFQsWidget extends ConsumerWidget {
  const RecentRFQsWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final rfqAsync = ref.watch(rfqsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'طلبات الأسعار الحديثة (RFQs)',
          subtitle: 'فرص التوريد الجديدة الواردة من المشتريين',
          icon: Icons.request_quote_rounded,
          actionText: 'عرض الكل',
          onActionTap: () => context.push('/orders'),
        ),
        rfqAsync.when(
          loading: () => const LoadingWidget(height: 180),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل طلبات الأسعار: $err',
            onRetry: () => ref.invalidate(rfqsProvider),
          ),
          data: (rfqs) {
            if (rfqs.isEmpty) {
              return const EmptyStateWidget(
                title: 'لا توجد طلبات أسعار جارية',
                description: 'ستصلك طلبات التسعير فور إنشائها بواسطة المشتريين.',
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

                return DashboardCard(
                  padding: const EdgeInsets.all(14),
                  onTap: () => context.push('/orders/rfq-details/${rfq.id}'),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header ID & Badges
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
                              const SizedBox(width: 6),
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

                      // Details: Buyer, Quantity, Remaining Time
                      Wrap(
                        spacing: 14,
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
                      Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4), height: 1),
                      const SizedBox(height: 8),

                      // Actions: Accept, Reject, Counter Offer, Open
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        alignment: WrapAlignment.end,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('تم رفض الطلب ${rfq.id}')),
                              );
                            },
                            style: OutlinedButton.styleFrom(
                              foregroundColor: colorScheme.error,
                              side: BorderSide(color: colorScheme.error.withValues(alpha: 0.5)),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('رفض', style: TextStyle(fontSize: 11)),
                          ),
                          OutlinedButton(
                            onPressed: () => context.push('/orders/create-offer/${rfq.id}'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.orange.shade900,
                              side: BorderSide(color: Colors.orange.shade400),
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('عرض مضاد', style: TextStyle(fontSize: 11)),
                          ),
                          ElevatedButton(
                            onPressed: () => context.push('/orders/create-offer/${rfq.id}'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colorScheme.primary,
                              foregroundColor: colorScheme.onPrimary,
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: const Text('قبول وتقديم عرض', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
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

