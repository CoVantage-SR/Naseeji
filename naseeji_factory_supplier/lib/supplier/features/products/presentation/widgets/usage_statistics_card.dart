import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import 'usage_progress_widget.dart';

class UsageStatisticsCard extends StatelessWidget {
  final String title;
  final double used;
  final double max;
  final String unit;

  const UsageStatisticsCard({
    super.key,
    required this.title,
    required this.used,
    required this.max,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0.5,
      color: Theme.of(context).colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${used.toStringAsFixed(used % 1 == 0 ? 0 : 1)}/${max.toStringAsFixed(max % 1 == 0 ? 0 : 1)}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                ),
                Text(
                  title,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ],
            ),
            SizedBox(height: 8),
            UsageProgressWidget(
              used: used,
              max: max,
              height: 6,
            ),
          ],
        ),
      ),
    );
  }
}



