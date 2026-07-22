import 'package:flutter/material.dart';
import '../../domain/entities/subscription_models.dart';
import 'usage_progress_widget.dart';

class SubscriptionUsageCard extends StatelessWidget {
  final SupplierSubscription subscription;
  final SubscriptionUsage usage;

  const SubscriptionUsageCard({
    super.key,
    required this.subscription,
    required this.usage,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final limits = subscription.limits;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.6),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.donut_large_rounded,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'استهلاك ميزات الباقة الحالية',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              UsageProgressWidget(
                label: 'عدد المنتجات',
                usedCount: usage.productsUsed,
                maxCount: limits.maxProducts,
                icon: Icons.inventory_2_outlined,
              ),
              const SizedBox(height: 10),
              UsageProgressWidget(
                label: 'عدد الإعلانات',
                usedCount: usage.advertisementsUsed,
                maxCount: limits.maxAdvertisements,
                icon: Icons.campaign_outlined,
              ),
              const SizedBox(height: 10),
              UsageProgressWidget(
                label: 'فيديو المنتج',
                usedCount: usage.videosUsed,
                maxCount: limits.maxVideosPerProduct,
                icon: Icons.videocam_outlined,
              ),
              const SizedBox(height: 10),
              UsageProgressWidget(
                label: 'ملفات PDF لكل منتج',
                usedCount: usage.pdfsUsed,
                maxCount: limits.maxPdfsPerProduct,
                icon: Icons.picture_as_pdf_outlined,
              ),
              const SizedBox(height: 10),
              UsageProgressWidget(
                label: 'طلبات الأسعار (RFQ)',
                usedCount: usage.rfqsUsed,
                maxCount: limits.maxMonthlyRfqs,
                icon: Icons.request_quote_outlined,
              ),
              const SizedBox(height: 10),
              UsageProgressWidget(
                label: 'المنتجات المميزة',
                usedCount: usage.featuredProductsUsed,
                maxCount: limits.maxFeaturedProducts,
                icon: Icons.star_outline,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
