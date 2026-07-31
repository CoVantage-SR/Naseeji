import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Offer Score Cards ("تقييم العرض") Section matching Reference Image
class QuotationScoreCards extends StatelessWidget {
  final Quotation quotation;

  const QuotationScoreCards({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'تقييم العرض',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              // Card 1: Final Score Highlight
              Container(
                width: 110,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
                decoration: BoxDecoration(
                  color: primaryColor.withValues(alpha: isDark ? 0.2 : 0.08),
                  borderRadius: AppRadius.rSM,
                  border: Border.all(color: primaryColor.withValues(alpha: 0.3)),
                ),
                child: Column(
                  children: [
                    Text(
                      'التقييم النهائي',
                      style: TextStyle(fontSize: 11, color: primaryColor, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 4),
                    const Text('🏆', style: TextStyle(fontSize: 16)),
                    const SizedBox(height: 2),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${quotation.overallScore}',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: primaryColor),
                        ),
                        Text(
                          ' / 100',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'أفضل عرض',
                      style: TextStyle(fontSize: 10, color: AppColors.success, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Card 2: السعر
              _buildScoreCard(
                context,
                isDark: isDark,
                icon: Icons.payments_outlined,
                label: 'السعر',
                score: quotation.priceScore,
                color: Colors.green,
              ),
              const SizedBox(width: 8),

              // Card 3: مدة التسليم
              _buildScoreCard(
                context,
                isDark: isDark,
                icon: Icons.local_shipping_outlined,
                label: 'مدة التسليم',
                score: quotation.deliveryScore,
                color: Colors.blue,
              ),
              const SizedBox(width: 8),

              // Card 4: تقييم المورد
              _buildScoreCard(
                context,
                isDark: isDark,
                icon: Icons.star_border_rounded,
                label: 'تقييم المورد',
                score: quotation.supplierRatingScore,
                color: Colors.amber,
              ),
              const SizedBox(width: 8),

              // Card 5: الالتزام السابق
              _buildScoreCard(
                context,
                isDark: isDark,
                icon: Icons.verified_user_outlined,
                label: 'الالتزام السابق',
                score: quotation.previousCommitmentScore,
                color: primaryColor,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildScoreCard(
    BuildContext context, {
    required bool isDark,
    required IconData icon,
    required String label,
    required int score,
    required Color color,
  }) {
    return Container(
      width: 100,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        borderRadius: AppRadius.rSM,
        border: Border.all(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, size: 18, color: color),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(fontSize: 10, color: Colors.grey.shade600),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                '$score',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              Text(
                ' / 100',
                style: TextStyle(fontSize: 9, color: Colors.grey.shade500),
              ),
            ],
          ),
          const SizedBox(height: 6),

          // Progress line
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: score / 100,
              minHeight: 3,
              backgroundColor: isDark ? AppColors.backgroundDark : Colors.grey.shade200,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}

