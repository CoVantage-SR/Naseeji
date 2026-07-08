import 'package:flutter/material.dart';

class SubscriptionWarningBanner extends StatelessWidget {
  final String status;
  final int daysRemaining;
  final VoidCallback onActionTap;

  const SubscriptionWarningBanner({
    super.key,
    required this.status,
    required this.daysRemaining,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    if (status != 'expiring' && status != 'expired' && status != 'suspended') {
      return const SizedBox.shrink();
    }

    Color bgColor = const Color(0xFFBA1A1A).withValues(alpha: 0.1);
    Color textColor = const Color(0xFFBA1A1A);
    String message = 'اشتراكك منتهي حالياً. سيتم إخفاء منتجاتك مؤقتاً حتى تقوم بالتجديد.';
    String actionLabel = 'تجديد الاشتراك';

    if (status == 'expiring') {
      bgColor = const Color(0xFFFF9800).withValues(alpha: 0.1);
      textColor = const Color(0xFFFF9800);
      message = 'تحذير: ينتهي اشتراكك الحالي خلال $daysRemaining أيام. تجنب إيقاف مبيعاتك بتجديد الباقة.';
      actionLabel = 'تجديد مبكر';
    } else if (status == 'suspended') {
      message = 'تنبيه: تم تعليق حسابك التمويلي مؤقتاً. يرجى التواصل مع الدعم الفني لنسيجي.';
      actionLabel = 'تواصل معنا';
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: textColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: onActionTap,
            style: TextButton.styleFrom(
              foregroundColor: textColor,
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Row(
              children: [
                Text(
                  actionLabel,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward, size: 12),
              ],
            ),
          ),
          Expanded(
            child: Text(
              message,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: textColor,
              ),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
