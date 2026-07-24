import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/dashboard/domain/entities/task_item_model.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'task_card.dart';
import 'home_loading.dart';
import 'home_empty_state.dart';
import 'home_error.dart';

class TodayTasksSection extends ConsumerWidget {
  const TodayTasksSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    final tasksAsync = ref.watch(todayTasksProvider);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header Row ──────────────────────────────────────────────────
          Row(
            children: [
              // "عرض الكل" Button (Left)
              TextButton(
                onPressed: () => context.push('/deals'),
                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 30),
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
                child: const Text(
                  'عرض الكل',
                  style: TextStyle(
                    fontSize: 12.5,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),

              const Spacer(),

              // Title & Urgent Badge (Right - RTL)
              tasksAsync.when(
                data: (tasks) {
                  final urgentCount = tasks.where((t) => t.priority == TaskPriority.urgent).length;
                  return Row(
                    children: [
                      if (urgentCount > 0) ...[
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  '$urgentCount',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text(
                                'مهام عاجلة',
                                style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                      Text(
                        'مهام اليوم',
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  );
                },
                loading: () => Text(
                  'مهام اليوم',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                error: (_, __) => const SizedBox.shrink(),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // ─── Task Cards List ──────────────────────────────────────────────
          tasksAsync.when(
            data: (tasks) {
              if (tasks.isEmpty) {
                return const HomeEmptyState();
              }

              // Display only top 3 or 4 tasks to keep the page short
              final displayTasks = tasks.take(3).toList();

              return Column(
                children: displayTasks.map((task) {
                  return TaskCard(
                    task: task,
                    onAction: () => _handleTaskAction(context, task.actionRoute),
                  );
                }).toList(),
              );
            },
            loading: () => const HomeLoading(),
            error: (err, stack) => HomeError(
              errorMessage: 'تعذر تحميل قائمة مهام اليوم',
              onRetry: () => ref.invalidate(todayTasksProvider),
            ),
          ),
        ],
      ),
    );
  }

  void _handleTaskAction(BuildContext context, String actionRoute) {
    if (actionRoute.isNotEmpty) {
      context.push(actionRoute);
    } else {
      context.push('/deals');
    }
  }
}
