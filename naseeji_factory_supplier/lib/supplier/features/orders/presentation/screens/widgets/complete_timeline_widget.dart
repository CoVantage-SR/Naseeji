import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';

class TimelineStepData {
  final String title;
  final String date;
  final String time;
  final String user;
  final String? notes;
  final List<String>? attachments;
  final bool isCompleted;
  final bool isActive;

  const TimelineStepData({
    required this.title,
    required this.date,
    required this.time,
    required this.user,
    this.notes,
    this.attachments,
    this.isCompleted = false,
    this.isActive = false,
  });
}

class CompleteTimelineWidget extends StatelessWidget {
  final List<TimelineStepData> steps;

  const CompleteTimelineWidget({super.key, required this.steps});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(steps.length, (index) {
        final step = steps[index];
        final isLast = index == steps.length - 1;
        return _buildStepItem(context, step, isLast);
      }),
    );
  }

  Widget _buildStepItem(BuildContext context, TimelineStepData step, bool isLast) {
    Color nodeColor = const Color(0xFFF1F1F5);
    Widget icon = const Icon(Icons.circle, color: AppColors.outline, size: 8);

    if (step.isCompleted) {
      nodeColor = const Color(0xFF0040E0);
      icon = Icon(Icons.check, color: AppColors.surface, size: 10);
    } else if (step.isActive) {
      nodeColor = const Color(0xFFE8F0FE);
      icon = SizedBox(
        width: 10,
        height: 10,
        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0040E0)),
      );
    }

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Time details (Left side)
          Container(
            width: 80,
            padding: const EdgeInsets.only(top: 2),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  step.date,
                  style: TextStyle(
                    fontSize: 9,
                    color: step.isCompleted || step.isActive ? Theme.of(context).colorScheme.onSurface : AppColors.outline,
                    fontWeight: step.isCompleted || step.isActive ? FontWeight.bold : FontWeight.normal,
                  ),
                ),
                Text(
                  step.time,
                  style: TextStyle(fontSize: 8, color: AppColors.outline),
                ),
              ],
            ),
          ),
          SizedBox(width: 8),

          // Circle & Connecting Line
          Column(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  color: step.isCompleted ? nodeColor : Colors.white,
                  border: Border.all(
                    color: step.isActive ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF),
                    width: 1.5,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Center(child: icon),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: step.isCompleted ? const Color(0xFF0040E0) : const Color(0xFFE2E1EF),
                  ),
                ),
            ],
          ),
          SizedBox(width: 12),

          // Content Box (Right side)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    step.title,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      color: step.isCompleted || step.isActive ? Theme.of(context).colorScheme.onSurface : AppColors.outline,
                    ),
                  ),
                  SizedBox(height: 2),
                  Text(
                    'بواسطة: ${step.user}',
                    style: TextStyle(fontSize: 9, color: AppColors.outline),
                  ),
                  if (step.notes != null) ...[
                    SizedBox(height: 4),
                    Text(
                      step.notes!,
                      style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                      textAlign: TextAlign.end,
                    ),
                  ],
                  if (step.attachments != null && step.attachments!.isNotEmpty) ...[
                    SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: step.attachments!.map((file) {
                        return Container(
                          margin: const EdgeInsets.only(left: 6),
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Theme.of(context).scaffoldBackgroundColor,
                            border: Border.all(color: const Color(0xFFE2E1EF)),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(file, style: TextStyle(fontSize: 9, color: Color(0xFF0040E0))),
                              SizedBox(width: 4),
                              const Icon(Icons.attach_file, size: 10, color: Color(0xFF0040E0)),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

