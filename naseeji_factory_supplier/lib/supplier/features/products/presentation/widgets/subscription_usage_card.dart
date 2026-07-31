import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'usage_progress_widget.dart';

class SubscriptionUsageCard extends StatelessWidget {
  final String title;
  final double used;
  final double max;
  final String unit;
  final VoidCallback? onActionTap;
  final String actionLabel;

  const SubscriptionUsageCard({
    super.key,
    required this.title,
    required this.used,
    required this.max,
    required this.unit,
    this.onActionTap,
    this.actionLabel = 'شراء ملحق التوسيع',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      margin: const EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${used.toStringAsFixed(used % 1 == 0 ? 0 : 1)} / ${max.toStringAsFixed(max % 1 == 0 ? 0 : 1)} $unit',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
              ],
            ),
            SizedBox(height: 10),
            UsageProgressWidget(
              used: used,
              max: max,
            ),
            if (used >= max && onActionTap != null) ...[
              SizedBox(height: 12),
              OutlinedButton(
                onPressed: onActionTap,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF0040E0),
                  side: const BorderSide(color: Color(0xFF0040E0)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  minimumSize: const Size(100, 36),
                ),
                child: Text(actionLabel, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ],
        ),
      ),
    );
  }
}



