import 'package:flutter/material.dart';

class ProductLimitBanner extends StatelessWidget {
  final double used;
  final double max;
  final VoidCallback onActionTap;

  const ProductLimitBanner({
    super.key,
    required this.used,
    required this.max,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = max > 0 ? (used / max) : 0.0;
    
    if (percent < 0.80) return const SizedBox.shrink();

    final isCritical = percent >= 0.95;
    final Color bgColor = isCritical ? const Color(0xFFBA1A1A).withValues(alpha: 0.1) : const Color(0xFFFFC107).withValues(alpha: 0.1);
    final Color textColor = isCritical ? const Color(0xFFBA1A1A) : const Color(0xFF664D03);
    final String message = isCritical
        ? 'تحذير حرج: لقد استهلكت ${(percent * 100).toStringAsFixed(0)}% من حدود باقتك للمنتجات!'
        : 'تنبيه: لقد استهلكت ${(percent * 100).toStringAsFixed(0)}% من المنتجات المتاحة في باقتك.';

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
                  isCritical ? 'ترقية الآن' : 'زيادة الحد',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
                ),
                SizedBox(width: 4),
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

