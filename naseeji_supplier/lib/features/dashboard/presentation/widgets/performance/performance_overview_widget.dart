import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';

class PerformanceOverviewWidget extends ConsumerWidget {
  const PerformanceOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final headerAsync = ref.watch(supplierHeaderProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const DashboardSectionTitle(
          title: 'أداء المورد',
          icon: Icons.star_rate_rounded,
        ),
        headerAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (e, s) => const SizedBox.shrink(),
          data: (header) => Text('التقييم: ${header.ratingStars}'),
        ),
      ],
    );
  }
}
