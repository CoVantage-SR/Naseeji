import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionLimitDialog extends StatelessWidget {
  final String message;

  const SubscriptionLimitDialog({super.key, required this.message});

  static void show(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (ctx) => SubscriptionLimitDialog(message: message),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.star_rounded, color: Colors.amber, size: 24),
            ),
            const SizedBox(width: 10),
            const Text(
              'وصلت للحد الأقصى للباقتك',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message,
              style: TextStyle(fontSize: 11.5, color: theme.colorScheme.onSurfaceVariant, height: 1.4),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, size: 16, color: Colors.amber),
                  SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      'ترقية الباقة تمنحك سعة منتجات وميديا غير محدودة وتمييز لمنتجاتك أمام كبار المشترين!',
                      style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إغلاق'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              context.push('/subscription/plans');
            },
            icon: const Icon(Icons.arrow_forward_rounded, size: 14),
            label: const Text('ترقية الباقة الآن'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 38),
            ),
          ),
        ],
      ),
    );
  }
}
