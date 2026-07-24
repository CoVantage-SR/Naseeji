import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/dashboard/domain/entities/task_item_model.dart';

enum TaskStatusType {
  urgent,
  negotiation,
  ready,
  completed,
  waiting,
}

class TaskCard extends StatelessWidget {
  final TaskItemModel task;
  final VoidCallback onAction;

  const TaskCard({
    super.key,
    required this.task,
    required this.onAction,
  });

  TaskStatusType _getTaskStatusType() {
    switch (task.priority) {
      case TaskPriority.urgent:
        return TaskStatusType.urgent;
      case TaskPriority.today:
        if (task.title.contains('تفاوض') || task.description.contains('مضاد')) {
          return TaskStatusType.negotiation;
        } else if (task.title.contains('شحن') || task.title.contains('تسليم')) {
          return TaskStatusType.ready;
        }
        return TaskStatusType.waiting;
      case TaskPriority.waiting:
        return TaskStatusType.waiting;
      case TaskPriority.informational:
        return TaskStatusType.completed;
    }
  }

  Color _getStatusColor(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return const Color(0xFFDC2626); // Red
      case TaskStatusType.negotiation:
        return const Color(0xFFEA580C); // Orange
      case TaskStatusType.ready:
        return const Color(0xFF16A34A); // Green
      case TaskStatusType.completed:
        return const Color(0xFF2563EB); // Blue
      case TaskStatusType.waiting:
        return const Color(0xFFD97706); // Amber
    }
  }

  String _getStatusLabel(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return 'عاجل 🚨';
      case TaskStatusType.negotiation:
        return 'يحتاج تفاوض 💬';
      case TaskStatusType.ready:
        return 'جاهز للشحن 🚛';
      case TaskStatusType.completed:
        return 'مكتمل ✅';
      case TaskStatusType.waiting:
        return 'بانتظار المصنع ⏳';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final type = _getTaskStatusType();
    final accentColor = _getStatusColor(type);
    final statusLabel = _getStatusLabel(type);

    return Container(
      height: 142,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: accentColor, width: 4), // Right border indicator for RTL
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          left: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Top Row: Status Badge (Left) & Icon + Title (Right)
            Row(
              children: [
                // Status Badge (Left)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 10.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const Spacer(),

                // Title & Icon (Right - RTL)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          task.title,
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.apartment_rounded,
                          size: 16,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Middle Text Description
            Text(
              task.description,
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),

            // Bottom Row: Time (Right) & Action Button (Left)
            Row(
              children: [
                // Primary Action Button (Left)
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(90, 34),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Text(
                    task.actionLabel,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),

                const Spacer(),

                // Time Indicator (Right)
                Row(
                  children: [
                    Text(
                      task.timeText,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
