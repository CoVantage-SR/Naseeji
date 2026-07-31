import 'package:flutter/material.dart';

class ResendButton extends StatelessWidget {
  final VoidCallback? onResend;
  final bool canResend;
  final int secondsRemaining;

  const ResendButton({
    super.key,
    required this.onResend,
    required this.canResend,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'لم يصلك الرمز؟',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(width: 6),
        TextButton(
          onPressed: canResend ? onResend : null,
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            canResend ? 'إعادة الإرسال' : 'إعادة الإرسال بعد $secondsRemaining ثانية',
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: canResend
                  ? colorScheme.primary
                  : (isDark ? colorScheme.outline : const Color(0xFF94A3B8)),
            ),
          ),
        ),
      ],
    );
  }
}
