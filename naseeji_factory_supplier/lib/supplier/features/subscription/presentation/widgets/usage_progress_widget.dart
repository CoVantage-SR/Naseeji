import 'package:flutter/material.dart';

class UsageProgressWidget extends StatelessWidget {
  final String label;
  final int usedCount;
  final int maxCount; // -1 for unlimited
  final IconData icon;
  final String? unit;
  final bool showPercentage;

  const UsageProgressWidget({
    super.key,
    required this.label,
    required this.usedCount,
    required this.maxCount,
    required this.icon,
    this.unit,
    this.showPercentage = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUnlimited = maxCount == -1;
    final ratio = isUnlimited
        ? 0.0
        : (maxCount > 0 ? (usedCount / maxCount).clamp(0.0, 1.0) : 1.0);

    Color progressColor = theme.colorScheme.primary;
    if (!isUnlimited) {
      if (ratio >= 1.0) {
        progressColor = theme.colorScheme.error;
      } else if (ratio >= 0.8) {
        progressColor = Colors.orange;
      }
    }

    final countDisplay = isUnlimited
        ? '$usedCount / غير محدود'
        : '$usedCount / $maxCount${unit != null ? ' $unit' : ''}';

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerLow,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(icon, size: 18, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    label,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  countDisplay,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: !isUnlimited && ratio >= 1.0
                        ? theme.colorScheme.error
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: isUnlimited ? 0.05 : ratio,
                minHeight: 6,
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                valueColor: AlwaysStoppedAnimation<Color>(progressColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

