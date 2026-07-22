import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/messages/domain/entities/deal_timeline_model.dart';

class TimelineTabWidget extends StatelessWidget {
  final DealTimelineModel timeline;

  const TimelineTabWidget({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final steps = timeline.steps;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تتبع الرحلة الزمنية للصفقة بالكامل',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'سجل موثق زمني لحظة بلحظة لكل ما تم في هذا الطلب بدءاً من الـ RFQ وحتى تسليم المستحقات المالية.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: steps.length,
            itemBuilder: (context, index) {
              final step = steps[index];
              final isLast = index == steps.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 28,
                          height: 28,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: step.isCompleted
                                ? Colors.green.shade800
                                : step.isCurrent
                                    ? colorScheme.primary
                                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
                          ),
                          child: Icon(
                            step.isCompleted
                                ? Icons.check_rounded
                                : step.isCurrent
                                    ? Icons.autorenew_rounded
                                    : Icons.radio_button_unchecked_rounded,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: step.isCompleted
                                  ? Colors.green.shade700
                                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),

                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16.0),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: step.isCurrent ? colorScheme.primary.withValues(alpha: 0.05) : colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: step.isCurrent
                                  ? colorScheme.primary.withValues(alpha: 0.4)
                                  : colorScheme.outlineVariant.withValues(alpha: 0.3),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    step.title,
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.bold,
                                      color: step.isCompleted
                                          ? Colors.green.shade900
                                          : step.isCurrent
                                              ? colorScheme.primary
                                              : colorScheme.onSurface,
                                    ),
                                  ),
                                  if (step.isCurrent)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colorScheme.primary,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: const Text(
                                        'المرحلة الحالية ⚡',
                                        style: TextStyle(fontSize: 9, color: Colors.white, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              if (step.subtitle != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  step.subtitle!,
                                  style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
