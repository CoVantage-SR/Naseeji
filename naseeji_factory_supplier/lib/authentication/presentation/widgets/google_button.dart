import 'package:flutter/material.dart';
import '../login/widgets/naseeji_logo_painters.dart';

class GoogleButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool isLoading;

  const GoogleButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      height: 48,
      width: double.infinity,
      child: OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        style: OutlinedButton.styleFrom(
          backgroundColor: isDark ? colorScheme.surfaceContainer : Colors.white,
          side: BorderSide(
            color: isDark ? colorScheme.outline : const Color(0xFFCBD5E1),
            width: 1,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const GoogleLogoPainterWidget(size: 20),
            const SizedBox(width: 10),
            Text(
              'تسجيل الدخول بجوجل',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
