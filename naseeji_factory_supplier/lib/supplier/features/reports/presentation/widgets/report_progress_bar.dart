import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class ReportProgressBar extends StatelessWidget {
  final String label;
  final double value; // 0.0 to 1.0
  final String valueLabel;
  final Color? barColor;

  const ReportProgressBar({
    super.key,
    required this.label,
    required this.value,
    required this.valueLabel,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    final color = barColor ?? AppColors.primary;
    final clampedValue = value.clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            children: [
              Text(
                valueLabel,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              const Spacer(),
              Text(
                label,
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: clampedValue,
              minHeight: 8,
              backgroundColor: AppColors.surfaceContainerHighest,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ],
      ),
    );
  }
}


