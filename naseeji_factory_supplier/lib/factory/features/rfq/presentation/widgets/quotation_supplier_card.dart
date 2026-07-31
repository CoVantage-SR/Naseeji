import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Supplier Profile Card matching Reference Image:
/// Top: Logo, Name, Verified Badge, Rating, Outlined Profile Button
/// Bottom: Last active dot, Completed deals count, Delivery commitment %
class QuotationSupplierCard extends StatelessWidget {
  final Quotation quotation;

  const QuotationSupplierCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Row(
            children: [
              // Logo
              ClipOval(
                child: SizedBox(
                  width: 48,
                  height: 48,
                  child: Image.network(
                    quotation.supplierLogo,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      color: Colors.grey.shade200,
                      child: Icon(Icons.factory_rounded, color: primaryColor),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Name & Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            quotation.supplierName,
                            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (quotation.supplierVerified) ...[
                          const SizedBox(width: 4),
                          const Icon(Icons.verified_rounded, color: AppColors.success, size: 16),
                        ],
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                        const SizedBox(width: 2),
                        Text(
                          '${quotation.supplierRating} ',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          '(${quotation.supplierReviewsCount} تقييم)',
                          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Profile Outlined Button
              OutlinedButton(
                onPressed: () => context.push('/suppliers/${quotation.supplierId}'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
                child: const Text('عرض الملف التعريفي', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Divider(color: isDark ? AppColors.borderDark : Colors.grey.shade200, height: 1),
          const SizedBox(height: 12),

          // Bottom Metric Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.circle, color: AppColors.success, size: 8),
                  const SizedBox(width: 4),
                  Text(
                    quotation.lastActive,
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.business_center_outlined, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'الصفقات المكتملة ',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${quotation.completedDealsCount}',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.local_shipping_outlined, size: 14, color: Colors.grey.shade600),
                  const SizedBox(width: 4),
                  Text(
                    'الالتزام بالتسليم ',
                    style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                  ),
                  Text(
                    quotation.deliveryCommitmentRate,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}



