import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class InsufficientCreditsDialog extends StatelessWidget {
  final String? requiredActionName;
  final int? requiredCredits;

  const InsufficientCreditsDialog({
    super.key,
    this.requiredActionName,
    this.requiredCredits,
  });

  static Future<void> show(
    BuildContext context, {
    String? requiredActionName,
    int? requiredCredits,
  }) {
    return showDialog<void>(
      context: context,
      builder: (context) => InsufficientCreditsDialog(
        requiredActionName: requiredActionName,
        requiredCredits: requiredCredits,
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
      child: Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(22.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon Header
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.monetization_on_outlined,
                  color: Colors.amber,
                  size: 32,
                ),
              ),

              const SizedBox(height: 16),

              // Title
              Text(
                'رصيد النقاط غير كافٍ ⚠️',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: isDark ? Colors.white : const Color(0xFF0F172A),
                ),
              ),

              const SizedBox(height: 8),

              // Message
              Text(
                requiredActionName != null && requiredCredits != null
                    ? 'يتطلب إجراء "$requiredActionName" وجود $requiredCredits رصيد نقاط على الأقل.\nقُم بشراء باقة رصيد إضافية أو ترقية اشتراكك للاستمرار.'
                    : 'ليس لديك رصيد نقاط كافٍ لإتمام هذه العملية.\nقُم بشراء باقة رصيد إضافية أو قُم بترقية اشتراكك للاستمرار.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.5,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),

              const SizedBox(height: 22),

              // Action Buttons
              Row(
                children: [
                  // Buy Credits Button
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/supplier/credits/buy');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: const Text(
                        'شراء رصيد',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Upgrade Button
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push('/supplier/subscription');
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: isDark ? Colors.white : colorScheme.primary,
                        side: BorderSide(color: colorScheme.primary),
                        minimumSize: const Size(0, 42),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        'ترقية الاشتراك',
                        style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 8),

              // Cancel Button
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                style: TextButton.styleFrom(
                  minimumSize: const Size(double.infinity, 36),
                  foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                ),
                child: const Text(
                  'إلغاء',
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
