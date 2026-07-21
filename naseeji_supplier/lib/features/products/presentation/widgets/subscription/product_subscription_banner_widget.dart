import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/products_providers.dart';

class ProductSubscriptionBannerWidget extends ConsumerWidget {
  const ProductSubscriptionBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final limitsAsync = ref.watch(productSubscriptionLimitsProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return limitsAsync.when(
      loading: () => const SizedBox(height: 60),
      error: (_, __) => const SizedBox.shrink(),
      data: (limits) {
        return Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row: Plan & Upgrade Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.workspace_premium_rounded,
                        color: Colors.amber.shade800,
                        size: 20,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        'الباقة الحالية: ${limits.currentPlan}',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () => context.push('/subscription/plans'),
                    icon: const Icon(Icons.bolt_rounded, size: 14),
                    label: const Text('ترقية الباقة'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      foregroundColor: colorScheme.primary,
                      textStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 6),

              // Summary Text
              Text(
                'يمكنك إضافة ${limits.remainingProducts} منتج جديد في باقتك الحالية',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 8),

              // Remaining Limits Row
              Wrap(
                spacing: 12,
                runSpacing: 6,
                children: [
                  _buildLimitTag(
                    context,
                    label: 'الصور',
                    value: '${limits.usedImages} / ${limits.maxImagesPerProduct}',
                  ),
                  _buildLimitTag(
                    context,
                    label: 'الفيديو',
                    value: '${limits.usedVideos} / ${limits.maxVideosPerProduct}',
                  ),
                  _buildLimitTag(
                    context,
                    label: 'ملفات PDF',
                    value: '${limits.usedPdfs} / ${limits.maxPdfsPerProduct}',
                  ),
                  _buildLimitTag(
                    context,
                    label: 'طلبات RFQ',
                    value: '${limits.usedRfqs} / ${limits.maxRfqs}',
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLimitTag(BuildContext context, {required String label, required String value}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: colorScheme.primary,
        ),
      ),
    );
  }
}
