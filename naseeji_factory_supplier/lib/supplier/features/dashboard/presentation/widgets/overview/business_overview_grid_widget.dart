import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/loading_widget.dart';

class BusinessOverviewGridWidget extends ConsumerWidget {
  const BusinessOverviewGridWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasksAsync = ref.watch(todayTasksProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionTitle(
          title: 'نظرة عامة على الأعمال',
          subtitle: 'المؤشرات التشغيلية الفورية',
          icon: Icons.dashboard_customize_outlined,
        ),
        tasksAsync.when(
          loading: () => const LoadingWidget(height: 120),
          error: (err, stack) => Text('خطأ: $err'),
          data: (tasks) {
            return Text(
              'لديك ${tasks.length} مهام معلقة اليوم',
              style: TextStyle(color: colorScheme.onSurface),
            );
          },
        ),
      ],
    );
  }
}
