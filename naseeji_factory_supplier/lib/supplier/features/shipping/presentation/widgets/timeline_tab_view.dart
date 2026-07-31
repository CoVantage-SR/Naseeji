import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/shipment.dart';

class TimelineTabView extends StatelessWidget {
  final Shipment s;

  const TimelineTabView({super.key, required this.s});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(16.0),
      itemCount: s.timeline.length,
      itemBuilder: (context, index) {
        final ev = s.timeline[s.timeline.length - 1 - index]; // Show latest first
        final bool isFirst = index == 0;
        final bool isLast = index == s.timeline.length - 1;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Time & Date
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(ev.time, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface)),
                SizedBox(height: 2),
                Text(ev.date, style: TextStyle(fontSize: 9, color: AppColors.outline)),
              ],
            ),
            SizedBox(width: 16),
            
            // Timeline Line & Dot Indicator
            Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: isFirst ? const Color(0xFF0040E0) : Colors.transparent,
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF0040E0), width: 3),
                  ),
                ),
                if (!isLast)
                  Container(
                    width: 2,
                    height: 60,
                    color: AppColors.outlineVariant,
                  ),
              ],
            ),
            SizedBox(width: 16),

            // Event Details Card
            Expanded(
              child: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                  borderRadius: BorderRadius.all(Radius.circular(12)),
                  boxShadow: [BoxShadow(color: Color(0x03000000), blurRadius: 4)],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(ev.status, style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Color(0xFF0040E0))),
                    SizedBox(height: 2),
                    Text('بواسطة: ${ev.user}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                    SizedBox(height: 6),
                    Text(ev.notes, style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant)),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}



