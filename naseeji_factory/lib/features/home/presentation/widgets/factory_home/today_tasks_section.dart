import 'package:flutter/material.dart';
import '../../../domain/entities/factory_home_models.dart';

class TodayTasksSection extends StatelessWidget {
  final List<TodayTaskItem> tasks;
  final ValueChanged<TodayTaskItem> onTaskTap;

  const TodayTasksSection({
    super.key,
    required this.tasks,
    required this.onTaskTap,
  });

  Color _getDotColor(String tag) {
    switch (tag) {
      case 'blue':
        return Colors.blue;
      case 'green':
        return const Color(0xFF10B981);
      case 'orange':
        return const Color(0xFFF59E0B);
      case 'red':
        return const Color(0xFFEF4444);
      default:
        return Colors.blue;
    }
  }

  IconData _getTaskIcon(String iconType) {
    switch (iconType) {
      case 'send':
        return Icons.note_alt_outlined;
      case 'quote':
        return Icons.auto_awesome_mosaic_outlined;
      case 'chat':
        return Icons.chat_bubble_outline_rounded;
      case 'approve':
        return Icons.assignment_turned_in_outlined;
      default:
        return Icons.description_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'مهام اليوم',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: tasks.map((task) {
              final dotColor = _getDotColor(task.colorTag);
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: InkWell(
                    onTap: () => onTaskTap(task),
                    borderRadius: BorderRadius.circular(14),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: theme.cardTheme.color ?? colorScheme.surface,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: theme.dividerColor.withValues(alpha: 0.25),
                          width: 1,
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: dotColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Center(
                            child: Text(
                              '${task.count}',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                child: Text(
                                  task.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    height: 1.2,
                                  ),
                                ),
                              ),
                              Icon(
                                _getTaskIcon(task.iconType),
                                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
                                size: 16,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}
