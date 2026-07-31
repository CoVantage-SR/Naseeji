import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/task_card.dart';
import '../shared/loading_widget.dart';
import '../shared/empty_state_widget.dart';
import '../shared/error_state_widget.dart';

class TodayTasksWidget extends ConsumerWidget {
  const TodayTasksWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(todayTasksProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionTitle(
          title: 'مهام واجراءات اليوم',
          subtitle: 'الأعمال المطلوبة منك الآن لإنجاز معاملاتك فوراً',
          icon: Icons.task_alt_rounded,
        ),
        tasksAsync.when(
          loading: () => const LoadingWidget(height: 180),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل مهام اليوم: $err',
            onRetry: () => ref.invalidate(todayTasksProvider),
          ),
          data: (tasks) {
            if (tasks.isEmpty) {
              return const EmptyStateWidget(
                title: 'لا توجد مهام معلقة اليوم',
                description: 'ممتاز! لقد قمت بإنجاز كافة طلبات العمل والإجراءات المطلوبة.',
                icon: Icons.check_circle_outline_rounded,
              );
            }

            return ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tasks.length,
              separatorBuilder: (context, index) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final task = tasks[index];
                return TaskCard(task: task);
              },
            );
          },
        ),
      ],
    );
  }
}

