import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/messages/domain/services/content_moderation_service.dart';

class ModerationWarningDialog extends StatelessWidget {
  final String? matchedReason;

  const ModerationWarningDialog({super.key, this.matchedReason});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.security_rounded, color: Colors.red.shade800, size: 24),
            ),
            const SizedBox(width: 10),
            Text(
              'تنبيه أمان المراسلات',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Colors.red.shade900),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    ContentModerationService.warningMessage,
                    style: TextStyle(fontSize: 12, color: Colors.red.shade900, height: 1.4, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ),
            if (matchedReason != null) ...[
              const SizedBox(height: 10),
              Text(
                'تفاصيل التنبيه: $matchedReason',
                style: TextStyle(fontSize: 10.5, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.shade800,
              foregroundColor: Colors.white,
              minimumSize: const Size(0, 40),
            ),
            child: const Text('فهمت ذلك وتغيير الرسالة'),
          ),
        ],
      ),
    );
  }
}



