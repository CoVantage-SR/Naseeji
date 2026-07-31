import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/task_item_model.dart';
import 'dashboard_card.dart';

class TaskCard extends StatelessWidget {
  final TaskItemModel task;

  const TaskCard({
    super.key,
    required this.task,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final Color priorityColor = _getPriorityColor(task.priority);
    final IconData priorityIcon = _getPriorityIcon(task.priority);

    return DashboardCard(
      padding: EdgeInsets.zero,
      onTap: () => context.push(task.actionRoute),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Priority Color Side Bar (🔴 / 🟠 / 🟡 / 🟢)
              Container(
                width: 6,
                color: priorityColor,
              ),

              // Task Main Content
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header: Priority Badge & Deadline
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: priorityColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  priorityIcon,
                                  size: 13,
                                  color: priorityColor,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  task.statusLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.bold,
                                    color: priorityColor,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.access_time_rounded,
                                size: 13,
                                color: colorScheme.outline,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                task.deadlineFormatted,
                                style: TextStyle(
                                  fontSize: 11,
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // Task Title
                      Text(
                        task.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),

                      if (task.description != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          task.description!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 12,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],

                      const SizedBox(height: 12),

                      // Action Button ("عرض", "فتح", "إنشاء بوليصة", "استلام المستحقات")
                      Align(
                        alignment: Alignment.centerLeft,
                        child: ElevatedButton(
                          onPressed: () => context.push(task.actionRoute),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: priorityColor,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 8,
                            ),
                            minimumSize: const Size(80, 36),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                task.actionLabel,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_back_ios_new_rounded,
                                size: 12,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return const Color(0xFFD32F2F); // 🔴 Red
      case TaskPriority.today:
        return const Color(0xFFE65100); // 🟠 Orange
      case TaskPriority.waiting:
        return const Color(0xFFF57F17); // 🟡 Yellow
      case TaskPriority.informational:
        return const Color(0xFF2E7D32); // 🟢 Green
    }
  }

  IconData _getPriorityIcon(TaskPriority priority) {
    switch (priority) {
      case TaskPriority.urgent:
        return Icons.error_rounded;
      case TaskPriority.today:
        return Icons.schedule_rounded;
      case TaskPriority.waiting:
        return Icons.hourglass_top_rounded;
      case TaskPriority.informational:
        return Icons.check_circle_rounded;
    }
  }
}

