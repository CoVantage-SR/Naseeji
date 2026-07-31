import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/quotations_provider.dart';

/// Sticky Bottom Action Bar containing 4 Action Buttons matching Reference Image:
/// 1. مقارنة بالعروض (Outlined Blue)
/// 2. رفض العرض (Red Filled)
/// 3. بدء تفاوض (Orange Filled)
/// 4. قبول العرض (Green Filled)
class QuotationBottomActionBar extends StatelessWidget {
  final Quotation quotation;
  final VoidCallback onCompareTap;
  final VoidCallback onRejectTap;
  final VoidCallback onNegotiateTap;
  final VoidCallback onAcceptTap;

  const QuotationBottomActionBar({
    super.key,
    required this.quotation,
    required this.onCompareTap,
    required this.onRejectTap,
    required this.onNegotiateTap,
    required this.onAcceptTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
        border: Border(
          top: BorderSide(color: isDark ? AppColors.borderDark : Colors.grey.shade200),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            // 1. مقارنة بالعروض (Outlined Blue)
            Expanded(
              flex: 3,
              child: OutlinedButton(
                onPressed: onCompareTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.bar_chart_rounded, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'مقارنة بالعروض',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // 2. رفض العرض (Red Filled)
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: onRejectTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.cancel_outlined, size: 14),
                        SizedBox(width: 4),
                        Text('رفض العرض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    Text('رفض هذا العرض فقط', style: TextStyle(fontSize: 8, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // 3. بدء تفاوض (Orange Filled)
            Expanded(
              flex: 3,
              child: ElevatedButton(
                onPressed: onNegotiateTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange.shade800,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.forum_outlined, size: 14),
                        SizedBox(width: 4),
                        Text('بدء تفاوض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
                      ],
                    ),
                    Text('إرسال عرض مضاد', style: TextStyle(fontSize: 8, color: Colors.white70)),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 6),

            // 4. قبول العرض (Green Filled - Primary)
            Expanded(
              flex: 4,
              child: ElevatedButton(
                onPressed: onAcceptTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.success,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline_rounded, size: 14),
                        SizedBox(width: 4),
                        Text('قبول العرض', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                    Text('إنشاء اتفاقية وصفقة', style: TextStyle(fontSize: 8, color: Colors.white70)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
  


