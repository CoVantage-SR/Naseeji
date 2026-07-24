import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/dashboard/domain/entities/task_item_model.dart';
import 'package:naseeji_supplier/features/dashboard/presentation/providers/dashboard_providers.dart';
import 'task_card.dart';

class TodayTasksSection extends ConsumerWidget {
  const TodayTasksSection({super.key});

  List<TaskItemModel> _getDefaultMockTasks() {
    final now = DateTime.now();
    return [
      TaskItemModel(
        id: 'TASK-1',
        title: 'لديك 3 طلبات RFQ تحتاج الرد',
        description: 'طلبات عروض أسعار عاجلة من مشتريين بانتظار تقديم تسعيرك.',
        priority: TaskPriority.urgent,
        statusLabel: 'عاجل جداً',
        actionLabel: 'عرض',
        actionRoute: '/orders',
        deadlineFormatted: 'متبقي ٣ ساعات',
        createdAt: now.subtract(const Duration(hours: 1)),
      ),
      TaskItemModel(
        id: 'TASK-2',
        title: 'يوجد عرض يحتاج تفاوض',
        description: 'قدم المشتري عرضاً مضاداً على الطلب ORD-2304.',
        priority: TaskPriority.today,
        statusLabel: 'يحتاج تفاوض',
        actionLabel: 'فتح',
        actionRoute: '/orders',
        deadlineFormatted: 'اليوم ٥:٠٠ م',
        createdAt: now.subtract(const Duration(hours: 3)),
      ),
      TaskItemModel(
        id: 'TASK-3',
        title: 'يوجد طلب جاهز للشحن',
        description: 'اكتمل تجهيز الطلب ORD-2305 في المصنع وبانتظار التغليف.',
        priority: TaskPriority.waiting,
        statusLabel: 'جاهز للشحن',
        actionLabel: 'إنشاء بوليصة',
        actionRoute: '/shipping',
        deadlineFormatted: 'غداً ١٢:٠٠ م',
        createdAt: now.subtract(const Duration(hours: 5)),
      ),
    ];
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final tasksAsync = ref.watch(todayTasksProvider);

    final defaultTasks = _getDefaultMockTasks();
    final tasks = tasksAsync.asData?.value;
    final displayTasks = (tasks != null && tasks.isNotEmpty) ? tasks.take(3).toList() : defaultTasks;
    final urgentCount = displayTasks.where((t) => t.priority == TaskPriority.urgent).length;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Outer Container Header Row ─────────────────────────────────
            Row(
              children: [
                // Title & Urgent Count Badge (Right in RTL)
                Row(
                  children: [
                    Text(
                      'مهام اليوم',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.5,
                      ),
                    ),
                    if (urgentCount > 0) ...[
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF2F2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFFCA5A5)),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Color(0xFFDC2626),
                                shape: BoxShape.circle,
                              ),
                              child: Text(
                                '$urgentCount',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '$urgentCount مهام عاجلة',
                              style: const TextStyle(
                                color: Color(0xFFDC2626),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),

                const Spacer(),

                // "عرض الكل" Text Button (Left in RTL)
                TextButton(
                  onPressed: () => context.push('/deals'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 28),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    'عرض الكل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2563EB),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 10),

            // ─── Task Cards List ────────────────────────────────────────────
            Column(
              children: displayTasks.map((task) {
                return TaskCard(
                  task: task,
                  onAction: () => _handleTaskAction(context, task.actionRoute),
                );
              }).toList(),
            ),
          ],
        ),
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
