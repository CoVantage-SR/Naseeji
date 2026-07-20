import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'timeline_widget.dart';

class RecentActivityWidget extends StatelessWidget {
  final List<RecentActivity> activities;
  final VoidCallback? onHeaderActionTap;

  const RecentActivityWidget({
    super.key,
    required this.activities,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'آخر النشاطات في المصنع',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        TimelineWidget(activities: activities),
      ],
    );
  }
}
