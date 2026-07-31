import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_result.dart';

class ContentModerationDialog extends StatelessWidget {
  final ContentModerationResult result;
  final VoidCallback? onEditContent;

  const ContentModerationDialog({
    super.key,
    required this.result,
    this.onEditContent,
  });

  static Future<void> show(
    BuildContext context, {
    required ContentModerationResult result,
    VoidCallback? onEditContent,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => ContentModerationDialog(
        result: result,
        onEditContent: onEditContent,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEscalated = result.attemptCount >= 2;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isEscalated ? Colors.red.shade100 : Colors.orange.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(
                isEscalated ? Icons.gavel_rounded : Icons.shield_rounded,
                color: isEscalated ? Colors.red.shade900 : Colors.orange.shade900,
                size: 24,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              result.userMessageTitle,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isEscalated ? Colors.red.shade900 : Colors.orange.shade900,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: isEscalated ? Colors.red.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isEscalated ? Colors.red.shade300 : Colors.orange.shade300,
                ),
              ),
              child: Text(
                result.userMessageBody,
                style: TextStyle(
                  fontSize: 13,
                  height: 1.5,
                  color: isEscalated ? Colors.red.shade900 : Colors.orange.shade900,
                ),
              ),
            ),
            if (isEscalated) ...[
              const SizedBox(height: 10),
              Row(
                children: [
                  Icon(Icons.warning_amber_rounded, size: 14, color: Colors.red.shade800),
                  const SizedBox(width: 4),
                  Text(
                    'تكرار المخالفة قد يعرض طلبك للمراجعة من قبل الدعم.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.red.shade800),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              if (onEditContent != null) onEditContent!();
            },
            child: const Text('تعديل المحتوى'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: isEscalated ? Colors.red.shade800 : Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 40),
            ),
            child: const Text('حسنًا'),
          ),
        ],
      ),
    );
  }
}



