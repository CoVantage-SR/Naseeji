import 'package:flutter/material.dart';
import '../../domain/entities/product_subscription_limit_model.dart';

class SubscriptionCardWidget extends StatelessWidget {
  final ProductSubscriptionLimitModel limits;
  final VoidCallback onUpgrade;

  const SubscriptionCardWidget({
    super.key,
    required this.limits,
    required this.onUpgrade,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header Row: Plan name + Upgrade Action Button
          Row(
            children: [
              Icon(Icons.workspace_premium_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                limits.currentPlan,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const Spacer(),
              ElevatedButton.icon(
                onPressed: onUpgrade,
                icon: const Icon(Icons.star_rounded, size: 12),
                label: const Text('ترقية الباقة', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(0, 28),
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  elevation: 0,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // Compact Quota Metrics Grid
          Row(
            children: [
              _buildQuotaChip(
                context,
                title: 'المنتجات',
                used: limits.usedProducts,
                max: limits.maxProducts,
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(width: 6),
              _buildQuotaChip(
                context,
                title: 'الصور/منتج',
                used: limits.usedImages,
                max: limits.maxImagesPerProduct,
                icon: Icons.image_outlined,
              ),
              const SizedBox(width: 6),
              _buildQuotaChip(
                context,
                title: 'الفيديو/منتج',
                used: limits.usedVideos,
                max: limits.maxVideosPerProduct,
                icon: Icons.videocam_outlined,
              ),
              const SizedBox(width: 6),
              _buildQuotaChip(
                context,
                title: 'PDF/منتج',
                used: limits.usedPdfs,
                max: limits.maxPdfsPerProduct,
                icon: Icons.picture_as_pdf_outlined,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuotaChip(
    BuildContext context, {
    required String title,
    required int used,
    required int max,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final isFull = used >= max;

    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
        decoration: BoxDecoration(
          color: isFull
              ? Colors.red.withValues(alpha: 0.08)
              : theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: isFull
                ? Colors.red.withValues(alpha: 0.3)
                : theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
          ),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(icon, size: 10, color: isFull ? Colors.red : theme.colorScheme.outline),
                const SizedBox(width: 2),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 8,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              '$used / $max',
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.bold,
                color: isFull ? Colors.red : theme.colorScheme.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

