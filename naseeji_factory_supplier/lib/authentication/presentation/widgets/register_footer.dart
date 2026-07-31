import 'package:flutter/material.dart';

class RegisterFooter extends StatelessWidget {
  final VoidCallback onLogin;

  const RegisterFooter({
    super.key,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Divider "أو"
        Row(
          children: [
            Expanded(
              child: Divider(
                color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                thickness: 1,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: Text(
                'أو',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF94A3B8),
                ),
              ),
            ),
            Expanded(
              child: Divider(
                color: isDark ? colorScheme.outlineVariant : const Color(0xFFE2E8F0),
                thickness: 1,
              ),
            ),
          ],
        ),

        const SizedBox(height: 12),

        // Already have an account row
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'لدي حساب بالفعل؟',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
              ),
            ),
            const SizedBox(width: 6),
            TextButton(
              onPressed: onLogin,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                'تسجيل الدخول',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
