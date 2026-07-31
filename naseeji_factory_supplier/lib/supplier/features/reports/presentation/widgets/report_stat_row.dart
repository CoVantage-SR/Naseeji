import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class ReportStatRow extends StatelessWidget {
  final String label;
  final String value;
  final IconData? icon;
  final Color? iconColor;
  final String? trend;
  final bool? isTrendPositive;
  final VoidCallback? onTap;

  const ReportStatRow({
    super.key,
    required this.label,
    required this.value,
    this.icon,
    this.iconColor,
    this.trend,
    this.isTrendPositive,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        child: Row(
          children: [
            // Trend indicator
            if (trend != null && isTrendPositive != null) ...[
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isTrendPositive! ? Icons.trending_up : Icons.trending_down,
                    size: 12,
                    color: isTrendPositive! ? const Color(0xFF00875A) : const Color(0xFFDE350B),
                  ),
                  const SizedBox(width: 2),
                  Text(
                    trend!,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: isTrendPositive! ? const Color(0xFF00875A) : const Color(0xFFDE350B),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),
            ],
            // Value
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const Spacer(),
            // Label + icon
            Text(
              label,
              textAlign: TextAlign.right,
              style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
            ),
            if (icon != null) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: (iconColor ?? AppColors.primary).withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 14, color: iconColor ?? AppColors.primary),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class ReportStatDivider extends StatelessWidget {
  const ReportStatDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      color: AppColors.outlineVariant.withValues(alpha: 0.3),
    );
  }
}



