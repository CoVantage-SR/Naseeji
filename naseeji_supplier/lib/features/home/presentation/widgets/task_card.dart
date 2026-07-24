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
        if (task.title.contains('تفاوض') || (task.description?.contains('مضاد') ?? false)) {
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
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border(
          right: BorderSide(color: accentColor, width: 3.5), // Right border indicator for RTL
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
          left: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
          bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Top Row: Status Badge (Left) & Title + Icon (Right)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Status Badge (Left)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: accentColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: accentColor,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Title & Icon (Right - RTL)
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Flexible(
                        child: Text(
                          task.title,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onSurface,
                          ),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.08),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Icon(
                          Icons.assignment_outlined,
                          size: 15,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Middle Text Description
            Text(
              task.description ?? '',
              style: TextStyle(
                fontSize: 11,
                color: colorScheme.onSurfaceVariant,
                height: 1.3,
              ),
              textAlign: TextAlign.right,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 10),

            // Bottom Row: Time Indicator (Right) & Action Button (Left)
            Row(
              children: [
                // Primary Action Button (Left)
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(82, 30),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
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
                      task.deadlineFormatted,
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
