import 'package:flutter/material.dart';

class PageHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const PageHeader({
    super.key,
    this.title = 'اختيار نوع الحساب',
    this.subtitle = 'اختر نوع الحساب الذي يناسبك للمتابعة',
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
            fontSize: 14,
          ),
        ),
      ],
    );
  }
}
