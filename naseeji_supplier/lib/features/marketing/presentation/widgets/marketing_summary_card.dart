import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class MarketingSummaryCard extends StatelessWidget {
  final String title;
  final String value;
  final String? trendText;
  final bool? isPositiveTrend;
  final IconData icon;
  final Color iconColor;

  const MarketingSummaryCard({
    super.key,
    required this.title,
    required this.value,
    this.trendText,
    this.isPositiveTrend,
    required this.icon,
    required this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(icon, color: iconColor, size: 24),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
            textAlign: TextAlign.right,
          ),
          if (trendText != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  trendText!,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isPositiveTrend == true
                        ? const Color(0xFF006B5F)
                        : (isPositiveTrend == false ? const Color(0xFFBA1A1A) : AppColors.onSurfaceVariant),
                  ),
                ),
                if (isPositiveTrend != null) ...[
                  const SizedBox(width: 4),
                  Icon(
                    isPositiveTrend == true ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 10,
                    color: isPositiveTrend == true ? const Color(0xFF006B5F) : const Color(0xFFBA1A1A),
                  ),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}
