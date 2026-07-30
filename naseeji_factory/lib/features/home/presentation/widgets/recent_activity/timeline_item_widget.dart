import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';

class TimelineItemWidget extends StatelessWidget {
  final String title;
  final String description;
  final String time;
  final IconData icon;
  final Color color;
  final bool isLast;

  const TimelineItemWidget({
    super.key,
    required this.title,
    required this.description,
    required this.time,
    required this.icon,
    required this.color,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return TimelineTile(
      title: title,
      description: description,
      time: time,
      icon: icon,
      color: color,
      isLast: isLast,
    );
  }
}
