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

  Color _getStatusBgColor(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return const Color(0xFFFEF2F2);
      case TaskStatusType.negotiation:
        return const Color(0xFFFFF7ED);
      case TaskStatusType.ready:
        return const Color(0xFFF0FDF4);
      case TaskStatusType.completed:
        return const Color(0xFFEFF6FF);
      case TaskStatusType.waiting:
        return const Color(0xFFFFFBEB);
    }
  }

  String _getStatusLabel(TaskStatusType type) {
    switch (type) {
      case TaskStatusType.urgent:
        return 'عاجل';
      case TaskStatusType.negotiation:
        return 'يحتاج تفاوض';
      case TaskStatusType.ready:
        return 'جاهز للشحن 🚚';
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
    final statusBgColor = _getStatusBgColor(type);
    final statusLabel = _getStatusLabel(type);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          right: BorderSide(color: accentColor, width: 4.5), // Right colored accent bar (RTL)
          top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
          left: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
          bottom: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
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
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Left Side: Time (Top) & Action Button (Bottom) ───────────
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Time indicator (Top Left)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.access_time_rounded,
                      size: 13,
                      color: colorScheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      task.deadlineFormatted,
                      style: TextStyle(
                        fontSize: 10.5,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 18),

                // Action Button (Bottom Left)
                ElevatedButton(
                  onPressed: onAction,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: accentColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(90, 32),
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    elevation: 0,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.arrow_back_ios_new_rounded, size: 10, color: Colors.white),
                      const SizedBox(width: 4),
                      Text(
                        task.actionLabel,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(width: 12),

            // ─── Center/Right Side: Status Tag, Title, Subtitle (RTL) ────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // Status Pill Tag (Aligned Right)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: statusBgColor,
                      borderRadius: BorderRadius.circular(12),
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

                  const SizedBox(height: 4),

                  // Title Text
                  Text(
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

                  const SizedBox(height: 2),

                  // Description Text
                  Text(
                    task.description ?? '',
                    style: TextStyle(
                      fontSize: 10.5,
                      color: colorScheme.onSurfaceVariant,
                      height: 1.3,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),

            const SizedBox(width: 10),

            // ─── Right Far Edge: Building / Department Icon ────────────────
            Container(
              width: 40,
              height: 40,
              decoration: const BoxDecoration(
                color: Color(0xFFEFF6FF), // Soft light-blue circle
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.apartment_rounded,
                color: Color(0xFF2563EB),
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
