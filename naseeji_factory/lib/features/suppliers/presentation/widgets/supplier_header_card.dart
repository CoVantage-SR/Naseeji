import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';

/// Header Card displaying Supplier Logo, Name, Verified Badge, Rating, Location, Response Rate, Delivery Time
class SupplierHeaderCard extends StatelessWidget {
  final Supplier supplier;

  const SupplierHeaderCard({super.key, required this.supplier});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rMD,
        border: Border.all(
          color: isDark ? AppColors.borderDark : Colors.grey.shade200,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Side: Main Info (Logo + Title + Meta)
          Expanded(
            flex: 6,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Logo Circle Avatar
                Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.backgroundDark : Colors.grey.shade100,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey.shade300, width: 1.5),
                  ),
                  child: ClipOval(
                    child: supplier.logoUrl.isNotEmpty
                        ? Image.network(
                            supplier.logoUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => _buildLogoFallback(primaryColor),
                          )
                        : _buildLogoFallback(primaryColor),
                  ),
                ),
                const SizedBox(width: 12),

                // Name & Metadata
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Supplier Name + Blue Verified Check
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              supplier.name,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          if (supplier.isVerified) ...[
                            const SizedBox(width: 4),
                            const Icon(
                              Icons.verified_rounded,
                              color: AppColors.primary,
                              size: 18,
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Online Status Indicator
                      Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: supplier.isOnline ? AppColors.success : Colors.grey,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            supplier.isOnline ? 'متاح الآن' : 'غير متصل',
                            style: TextStyle(
                              fontSize: 11,
                              color: supplier.isOnline ? AppColors.success : Colors.grey,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Location Icon + Location
                      Row(
                        children: [
                          const Icon(Icons.location_on_outlined, size: 14, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            '${supplier.city}، ${supplier.governorate}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Calendar Icon + Member Since
                      Row(
                        children: [
                          const Icon(Icons.calendar_today_outlined, size: 13, color: Colors.grey),
                          const SizedBox(width: 4),
                          Text(
                            'عضو منذ ${supplier.memberSince}',
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Verified Supplier Pill Badge
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.verified_user_outlined, color: AppColors.primary, size: 12),
                            SizedBox(width: 4),
                            Text(
                              'مورد معتمد',
                              style: TextStyle(
                                fontSize: 10,
                                color: AppColors.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Vertical Separator
          Container(
            width: 1,
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            color: isDark ? AppColors.borderDark : Colors.grey.shade200,
          ),

          // Right Side: Rating & Performance Summary Box
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Big Rating Score
                Text(
                  supplier.rating.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight,
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    5,
                    (index) => const Icon(Icons.star_rounded, color: Colors.amber, size: 14),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  '(${supplier.reviewsCount} تقييم)',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),

                // Response Rate
                Text(
                  'معدل الاستجابة',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      supplier.responseSpeed,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.trending_up_rounded, color: AppColors.success, size: 14),
                  ],
                ),
                const SizedBox(height: 8),

                // Average Delivery Time
                Text(
                  'متوسط التسليم',
                  style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                ),
                Text(
                  supplier.avgDeliveryDays,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoFallback(Color primaryColor) {
    return Container(
      color: primaryColor.withValues(alpha: 0.1),
      child: Center(
        child: Icon(
          Icons.factory_rounded,
          size: 36,
          color: primaryColor,
        ),
      ),
    );
  }
}
