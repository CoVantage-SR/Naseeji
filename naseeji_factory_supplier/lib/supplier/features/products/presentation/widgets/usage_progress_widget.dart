import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class UsageProgressWidget extends StatelessWidget {
  final double used;
  final double max;
  final double height;

  const UsageProgressWidget({
    super.key,
    required this.used,
    required this.max,
    this.height = 8.0,
  });

  @override
  Widget build(BuildContext context) {
    final double percent = max > 0 ? (used / max) : 0.0;
    
    Color progressColor = const Color(0xFF0040E0);
    if (percent >= 1.0) {
      progressColor = const Color(0xFFBA1A1A);
    } else if (percent >= 0.95) {
      progressColor = const Color(0xFFFF9800);
    } else if (percent >= 0.80) {
      progressColor = const Color(0xFFFFC107);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(height / 2),
      child: SizedBox(
        height: height,
        child: LinearProgressIndicator(
          value: percent.clamp(0.0, 1.0),
          backgroundColor: AppColors.outlineVariant.withValues(alpha: 0.5),
          valueColor: AlwaysStoppedAnimation<Color>(progressColor),
        ),
      ),
    );
  }
}


