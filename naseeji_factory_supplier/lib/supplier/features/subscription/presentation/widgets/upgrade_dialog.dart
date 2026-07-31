import 'package:flutter/material.dart';

class UpgradeDialog extends StatelessWidget {
  final String title;
  final String message;
  final String upgradeButtonText;
  final String cancelButtonText;
  final VoidCallback onUpgrade;
  final VoidCallback? onCancel;

  const UpgradeDialog({
    super.key,
    this.title = 'لقد وصلت للحد الأقصى',
    this.message =
        'لقد استخدمت جميع المنتجات المتاحة في باقتك الحالية.\nيمكنك ترقية الباقة لإضافة المزيد.',
    this.upgradeButtonText = 'ترقية الباقة',
    this.cancelButtonText = 'إلغاء',
    required this.onUpgrade,
    this.onCancel,
  });

  /// Static helper to quickly display the upgrade dialog with standard Arabic copy.
  static Future<void> show(
    BuildContext context, {
    String? title,
    String? message,
    required VoidCallback onUpgrade,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) => UpgradeDialog(
        title: title ?? 'لقد وصلت للحد الأقصى',
        message: message ??
            'لقد استخدمت جميع المنتجات المتاحة في باقتك الحالية.\nيمكنك ترقية الباقة لإضافة المزيد.',
        onUpgrade: () {
          Navigator.of(ctx).pop();
          onUpgrade();
        },
        onCancel: () => Navigator.of(ctx).pop(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        icon: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.workspace_premium_rounded,
            size: 36,
            color: colorScheme.primary,
          ),
        ),
        title: Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
            color: colorScheme.onSurface,
          ),
        ),
        content: Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
        actionsAlignment: MainAxisAlignment.spaceEvenly,
        actionsPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        actions: [
          OutlinedButton(
            onPressed: () {
              if (onCancel != null) {
                onCancel!();
              } else {
                Navigator.of(context).pop();
              }
            },
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: Text(cancelButtonText),
          ),
          FilledButton.icon(
            onPressed: onUpgrade,
            icon: const Icon(Icons.bolt, size: 18),
            label: Text(
              upgradeButtonText,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              backgroundColor: colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}


