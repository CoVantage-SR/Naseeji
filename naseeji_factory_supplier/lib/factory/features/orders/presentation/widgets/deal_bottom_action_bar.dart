import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../providers/orders_provider.dart';

/// Sticky Bottom Actions Bar:
/// 1. بدء محادثة (Outlined Blue)
/// 2. تتبع الشحنة (Outlined Blue)
/// 3. تأكيد الاستلام (Filled Primary Blue)
class DealBottomActionBar extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onConfirmDelivery;

  const DealBottomActionBar({
    super.key,
    required this.order,
    required this.onConfirmDelivery,
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
            // 1. بدء محادثة (Outlined Blue)
            Expanded(
              flex: 3,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/chat/chat_1');
                },
                icon: const Icon(Icons.chat_outlined, size: 16),
                label: const Text(
                  'بدء محادثة',
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

            // 2. تتبع الشحنة (Outlined Blue)
            Expanded(
              flex: 3,
              child: OutlinedButton.icon(
                onPressed: () {
                  context.push('/orders/${order.id}/shipment');
                },
                icon: const Icon(Icons.location_on_outlined, size: 16),
                label: const Text(
                  'تتبع الشحنة',
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

            // 3. تأكيد الاستلام (Filled Primary Blue)
            Expanded(
              flex: 4,
              child: ElevatedButton.icon(
                onPressed: onConfirmDelivery,
                icon: const Icon(Icons.check_circle_outline_rounded, size: 18),
                label: const Text(
                  'تأكيد الاستلام',
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

