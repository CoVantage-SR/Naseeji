import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/progress_indicator_widget.dart';
import '../shared/dashboard_loading_widget.dart';

class SubscriptionOverviewWidget extends ConsumerWidget {
  const SubscriptionOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(subscriptionProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'حالة الاشتراك والباقة',
          subtitle: 'متابعة حدود الاستخدام والمنتجات والإعلانات المتاحة',
          icon: Icons.card_membership_rounded,
          actionText: 'التفاصيل',
          onActionTap: () => context.push('/subscription'),
        ),
        subAsync.when(
          loading: () => const DashboardLoadingWidget(height: 200),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل بيانات الاشتراك: $err'),
          ),
          data: (sub) {
            final String expiryFormatted =
                '${sub.expiryDate.year}/${sub.expiryDate.month}/${sub.expiryDate.day}';

            return DashboardCardWidget(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Plan Header Row & Upgrade Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'الباقة الحالية',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Text(
                                sub.currentPlan,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                  fontSize: 18,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(
                                Icons.stars_rounded,
                                color: Colors.amber.shade700,
                                size: 20,
                              ),
                            ],
                          ),
                        ],
                      ),
                      ElevatedButton.icon(
                        onPressed: () => context.push('/subscription/plans'),
                        icon: const Icon(Icons.bolt_rounded, size: 18),
                        label: const Text('ترقية الباقة'),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size(120, 42),
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Divider(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.4),
                  ),
                  const SizedBox(height: 12),

                  // Progress Indicators
                  ProgressIndicatorWidget(
                    label: 'المنتجات المسجلة',
                    used: sub.productsUsed,
                    limit: sub.productsLimit,
                    suffix: 'منتج',
                  ),
                  const SizedBox(height: 12),
                  ProgressIndicatorWidget(
                    label: 'الإعلانات النشطة',
                    used: sub.advertisementsUsed,
                    limit: sub.advertisementsLimit,
                    suffix: 'إعلان',
                    progressColor: Colors.orange.shade800,
                  ),
                  const SizedBox(height: 12),
                  ProgressIndicatorWidget(
                    label: 'المنتجات المميزة (Featured)',
                    used: sub.featuredProductsUsed,
                    limit: sub.featuredProductsLimit,
                    suffix: 'منتج',
                    progressColor: Colors.purple.shade700,
                  ),
                  const SizedBox(height: 12),
                  ProgressIndicatorWidget(
                    label: 'طلبات الأسعار (RFQs)',
                    used: sub.rfqsUsed,
                    limit: sub.rfqsLimit,
                    suffix: 'طلب',
                    progressColor: const Color(0xFF006B5F),
                  ),

                  const SizedBox(height: 16),
                  // Expiry Date Notice
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.event_available_rounded,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'تاريخ انتهاء الاشتراك: ',
                          style: TextStyle(
                            fontSize: 12,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          expiryFormatted,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}


