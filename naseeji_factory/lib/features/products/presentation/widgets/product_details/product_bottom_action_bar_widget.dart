import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';

/// Sticky bottom action bar with two procurement actions.
/// Replaces the inline action buttons row that was previously in the screen.
class ProductBottomActionBarWidget extends StatelessWidget {
  final VoidCallback onFavoriteSupplier;
  final VoidCallback onRequestQuote;

  const ProductBottomActionBarWidget({
    super.key,
    required this.onFavoriteSupplier,
    required this.onRequestQuote,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF151B2C) : Colors.white,
        border: Border(
          top: BorderSide(
            color: isDark ? AppColors.borderDark : AppColors.borderLight,
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 12,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onFavoriteSupplier,
              icon: const Icon(Icons.favorite_border_rounded, size: 18),
              label: const Text('مفضلة الموردين'),
              style: OutlinedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 14),
                side: const BorderSide(color: AppColors.primary),
                foregroundColor: AppColors.primary,
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: onRequestQuote,
              icon: const Icon(Icons.request_quote_rounded, size: 18),
              label: const Text('طلب عرض سعر'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
