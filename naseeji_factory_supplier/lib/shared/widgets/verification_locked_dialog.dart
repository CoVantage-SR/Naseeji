import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class VerificationLockedDialog extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback? onCompleteVerification;

  const VerificationLockedDialog({
    super.key,
    this.title = 'تأكيد التوثيق مطلوب',
    this.message = 'هذا الإجراء يتطلب توثيق الحساب.',
    this.onCompleteVerification,
  });

  static Future<void> show(BuildContext context, {String? title, String? message}) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => VerificationLockedDialog(
        title: title ?? 'تأكيد التوثيق مطلوب',
        message: message ?? 'هذا الإجراء يتطلب توثيق الحساب.',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDark ? colorScheme.surface : Colors.white,
        contentPadding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.verified_user_outlined,
                color: AppColors.primary,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 17,
                color: isDark ? colorScheme.onSurface : const Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                fontSize: 13.5,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      side: BorderSide(
                        color: isDark ? colorScheme.outline : const Color(0xFFCBD5E1),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Text(
                      'لاحقاً',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isDark ? colorScheme.onSurface : const Color(0xFF475569),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  flex: 2,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      if (onCompleteVerification != null) {
                        onCompleteVerification!();
                      } else {
                        context.push('/auth/complete-profile');
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      'توثيق الحساب الآن',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
