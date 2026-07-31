import 'package:flutter/material.dart';

class ProgressIndicatorWidget extends StatelessWidget {
  final String label;
  final int used;
  final int limit;
  final String? suffix;
  final Color? progressColor;
  final double height;

  const ProgressIndicatorWidget({
    super.key,
    required this.label,
    required this.used,
    required this.limit,
    this.suffix,
    this.progressColor,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final double progress = limit == 0 ? 0.0 : (used / limit).clamp(0.0, 1.0);
    final bool isWarning = progress > 0.8 && progress < 1.0;
    final bool isDanger = progress >= 1.0;

    final Color effectiveColor = progressColor ??
        (isDanger
            ? colorScheme.error
            : isWarning
                ? Colors.amber.shade700
                : colorScheme.primary);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurface,
                fontSize: 13,
              ),
            ),
            Text(
              '$used / $limit ${suffix ?? ''}',
              style: theme.textTheme.bodySmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: effectiveColor,
                fontSize: 12,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(height / 2),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: height,
            backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
            valueColor: AlwaysStoppedAnimation<Color>(effectiveColor),
          ),
        ),
      ],
    );
  }
}


