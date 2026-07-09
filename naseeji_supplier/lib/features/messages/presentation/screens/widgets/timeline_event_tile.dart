import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class TimelineEventTile extends StatelessWidget {
  final String stage;
  final String timestamp;
  final String user;
  final String? notes;
  final bool isActive;
  final bool isCompleted;
  final IconData icon;
  final bool isLast;

  const TimelineEventTile({
    super.key,
    required this.stage,
    required this.timestamp,
    required this.user,
    this.notes,
    required this.isActive,
    required this.isCompleted,
    required this.icon,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final dotColor = isActive
        ? AppColors.primary
        : isCompleted
            ? AppColors.secondary
            : AppColors.outlineVariant;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline column
          Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isActive ? AppColors.primary : isCompleted ? AppColors.secondary.withValues(alpha: 0.15) : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: isActive ? 0 : 2),
                  boxShadow: isActive
                      ? [BoxShadow(color: AppColors.primary.withValues(alpha: 0.4), blurRadius: 10, offset: const Offset(0, 3))]
                      : null,
                ),
                child: Icon(
                  isCompleted ? Icons.check_rounded : icon,
                  size: 20,
                  color: isActive ? Colors.white : isCompleted ? AppColors.secondary : AppColors.outline,
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.5,
                    color: isCompleted ? AppColors.secondary.withValues(alpha: 0.5) : AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
            ],
          ),
          SizedBox(width: 14),
          // Content
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 24, top: 4),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      if (isActive)
                        Container(
                          margin: const EdgeInsets.only(left: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text('الحالي', style: TextStyle(color: Theme.of(context).colorScheme.surface, fontSize: 9, fontWeight: FontWeight.bold)),
                        ),
                      Expanded(
                        child: Text(
                          stage,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
                            color: isActive ? AppColors.primary : Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.person_outline, size: 12, color: AppColors.outline),
                      SizedBox(width: 4),
                      Text(user, style: TextStyle(fontSize: 11, color: AppColors.outline)),
                      SizedBox(width: 12),
                      const Icon(Icons.access_time, size: 12, color: AppColors.outline),
                      SizedBox(width: 4),
                      Text(timestamp, style: TextStyle(fontSize: 11, color: AppColors.outline)),
                    ],
                  ),
                  if (notes != null) ...[
                    SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(notes!, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
