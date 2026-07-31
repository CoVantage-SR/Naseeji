import 'package:flutter/material.dart';
import '../../domain/entities/subscription_models.dart';
import 'subscription_badge.dart';

class SubscriptionCard extends StatelessWidget {
  final SupplierSubscription subscription;
  final SubscriptionUsage usage;
  final VoidCallback? onManagePressed;
  final VoidCallback? onUpgradePressed;

  const SubscriptionCard({
    super.key,
    required this.subscription,
    required this.usage,
    this.onManagePressed,
    this.onUpgradePressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final limits = subscription.limits;

    // Formatting date
    final exp = subscription.expiryDate;
    final formattedDate =
        '${exp.day.toString().padLeft(2, '0')} / ${exp.month.toString().padLeft(2, '0')} / ${exp.year}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [
              colorScheme.primaryContainer.withValues(alpha: 0.8),
              colorScheme.surface,
            ],
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(
            color: colorScheme.primary.withValues(alpha: 0.2),
          ),
        ),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Header: Plan Name + Expiry Date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SubscriptionBadge(
                        tier: subscription.tier,
                        planName: subscription.planName,
                        status: subscription.status,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.calendar_month,
                            size: 14,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'ينتهي في  $formattedDate',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                if (onUpgradePressed != null) ...[
                  const SizedBox(width: 8),
                  ElevatedButton.icon(
                    onPressed: onUpgradePressed,
                    icon: const Icon(Icons.bolt, size: 16),
                    label: const Text('ترقية'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      minimumSize: const Size(0, 36),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1),
            ),

            // Usage Grid (Products, Ads, Video, PDF, RFQ)
            Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    title: 'المنتجات',
                    used: usage.productsUsed,
                    max: limits.maxProducts,
                    icon: Icons.inventory_2_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _MetricItem(
                    title: 'الإعلانات',
                    used: usage.advertisementsUsed,
                    max: limits.maxAdvertisements,
                    icon: Icons.campaign_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    title: 'الفيديو',
                    used: usage.videosUsed,
                    max: limits.maxVideosPerProduct,
                    icon: Icons.videocam_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _MetricItem(
                    title: 'PDF',
                    used: usage.pdfsUsed,
                    max: limits.maxPdfsPerProduct,
                    icon: Icons.picture_as_pdf_outlined,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _MetricItem(
                    title: 'RFQ الشهري',
                    used: usage.rfqsUsed,
                    max: limits.maxMonthlyRfqs,
                    icon: Icons.request_quote_outlined,
                  ),
                ),
                Container(
                  width: 1,
                  height: 36,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
                Expanded(
                  child: _MetricItem(
                    title: 'المنتجات المميزة',
                    used: usage.featuredProductsUsed,
                    max: limits.maxFeaturedProducts,
                    icon: Icons.star_outline,
                  ),
                ),
              ],
            ),

            if (onManagePressed != null) ...[
              const SizedBox(height: 12),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: onManagePressed,
                  icon: const Icon(Icons.settings, size: 16),
                  label: const Text('إدارة الاشتراك'),
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _MetricItem extends StatelessWidget {
  final String title;
  final int used;
  final int max;
  final IconData icon;

  const _MetricItem({
    required this.title,
    required this.used,
    required this.max,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlimited = max == -1;

    final displayString = isUnlimited ? '$used / غير محدود' : '$used / $max';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 14, color: theme.colorScheme.primary),
              const SizedBox(width: 4),
              Text(
                title,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            displayString,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}

