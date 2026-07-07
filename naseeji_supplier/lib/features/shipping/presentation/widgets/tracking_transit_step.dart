import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class TrackingTransitStep extends StatelessWidget {
  final String title;
  final String desc;
  final String time;
  final bool completed;

  const TrackingTransitStep({
    super.key,
    required this.title,
    required this.desc,
    required this.time,
    required this.completed,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: completed ? const Color(0xFF0040E0) : Colors.grey.shade300,
                shape: BoxShape.circle,
              ),
              child: completed ? const Icon(Icons.check, size: 10, color: Colors.white) : null,
            ),
            Container(
              width: 2,
              height: 40,
              color: completed ? const Color(0xFF0040E0) : Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: completed ? AppColors.onSurface : AppColors.outline),
              ),
              const SizedBox(height: 2),
              Text(desc, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
        ),
        Text(time, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
      ],
    );
  }
}
