import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../domain/entities/home_entities.dart';
import 'timeline_item_widget.dart';

class TimelineWidget extends StatelessWidget {
  final List<RecentActivity> activities;

  const TimelineWidget({
    super.key,
    required this.activities,
  });

  @override
  Widget build(BuildContext context) {
    if (activities.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20.0),
        child: Center(child: Text('لا توجد أنشطة مؤخراً.')),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: activities.length,
      itemBuilder: (context, index) {
        final activity = activities[index];
        final isLast = index == activities.length - 1;

        IconData icon = Icons.notifications_none_rounded;
        Color color = AppColors.primary;

        switch (activity.type) {
          case 'rfq_created':
            icon = Icons.add_circle_outline_rounded;
            color = AppColors.primary;
            break;
          case 'quotation_received':
            icon = Icons.request_quote_outlined;
            color = AppColors.secondary;
            break;
          case 'order_approved':
            icon = Icons.check_circle_outline_rounded;
            color = AppColors.success;
            break;
          case 'shipment_started':
            icon = Icons.local_shipping_outlined;
            color = AppColors.info;
            break;
          case 'shipment_delivered':
            icon = Icons.done_all_rounded;
            color = AppColors.success;
            break;
        }

        return TimelineItemWidget(
          title: activity.title,
          description: activity.description,
          time: activity.time,
          icon: icon,
          color: color,
          isLast: isLast,
        );
      },
    );
  }
}
