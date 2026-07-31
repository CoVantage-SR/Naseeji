import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/rfq_provider.dart';

/// Sticky Bottom Actions Bar for RFQ Details Screen:
/// 1. تعديل الطلب (Filled Primary Blue)
/// 2. نسخ الرابط (Outlined Blue)
/// 3. المزيد ... (Outlined Blue)
class RFQBottomActionBar extends StatelessWidget {
  final RFQ rfq;
  final VoidCallback onEditTap;
  final VoidCallback onMoreTap;

  const RFQBottomActionBar({
    super.key,
    required this.rfq,
    required this.onEditTap,
    required this.onMoreTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
            // 1. المزيد ... (Outlined Blue)
            Expanded(
              flex: 3,
              child: OutlinedButton(
                onPressed: onMoreTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.more_horiz_rounded, size: 16),
                    SizedBox(width: 4),
                    Text(
                      'المزيد',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 2. نسخ الرابط (Outlined Blue)
            Expanded(
              flex: 4,
              child: OutlinedButton.icon(
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: 'https://naseeji.com/rfq/${rfq.id}'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم نسخ رابط الطلب (${rfq.rfqNumber}) بنجاح!')),
                  );
                },
                icon: const Icon(Icons.link_rounded, size: 16),
                label: const Text(
                  'نسخ الرابط',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(color: primaryColor, width: 1.2),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
              ),
            ),
            const SizedBox(width: 8),

            // 3. تعديل الطلب (Filled Primary Blue)
            Expanded(
              flex: 5,
              child: ElevatedButton.icon(
                onPressed: onEditTap,
                icon: const Icon(Icons.edit_outlined, size: 18),
                label: const Text(
                  'تعديل الطلب',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}



