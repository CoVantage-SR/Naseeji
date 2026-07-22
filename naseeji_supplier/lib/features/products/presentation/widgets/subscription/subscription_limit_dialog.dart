import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SubscriptionLimitDialog extends StatelessWidget {
  final String title;
  final String message;

  const SubscriptionLimitDialog({
    super.key,
    this.title = 'لقد وصلت للحد الأقصى في باقتك الحالية',
    this.message = 'يمكنك ترقية الباقة لإضافة منتجات أو صور أو ملفات أكثر.',
  });

  static void show(BuildContext context, {String? title, String? message}) {
    showDialog(
      context: context,
      builder: (context) => SubscriptionLimitDialog(
        title: title ?? 'لقد وصلت للحد الأقصى في باقتك الحالية',
        message: message ?? 'يمكنك ترقية الباقة لإضافة منتجات أو صور أو ملفات أكثر.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor: colorScheme.surface,
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.amber.shade100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.stars_rounded,
              color: Colors.amber.shade900,
              size: 24,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
      content: Text(
        message,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
          fontSize: 13,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            'إغلاق',
            style: TextStyle(color: colorScheme.outline),
          ),
        ),
        ElevatedButton.icon(
          onPressed: () {
            Navigator.of(context).pop();
            context.push('/subscription/plans');
          },
          icon: const Icon(Icons.bolt_rounded, size: 16),
          label: const Text('ترقية الباقة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: colorScheme.primary,
            foregroundColor: colorScheme.onPrimary,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            minimumSize: const Size(0, 36),
          ),
        ),
      ],
    );
  }
}
