import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/deals/domain/entities/deal_model.dart';

class TimelineWidget extends StatelessWidget {
  final DealModel deal;

  const TimelineWidget({super.key, required this.deal});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final timeline = deal.timeline;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.history_rounded, size: 18, color: colorScheme.primary),
              const SizedBox(width: 6),
              Text(
                'الخط الزمني وسجل مراقبة الصفقة (Audit Log)',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: timeline.length,
            itemBuilder: (context, index) {
              final step = timeline[index];
              final isLast = index == timeline.length - 1;

              return IntrinsicHeight(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Dot & Line
                    Column(
                      children: [
                        Container(
                          width: 14,
                          height: 14,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: step.isCurrent ? colorScheme.primary : (step.isCompleted ? Colors.green : colorScheme.outlineVariant),
                            border: Border.all(color: Colors.white, width: 2),
                          ),
                        ),
                        if (!isLast)
                          Expanded(
                            child: Container(
                              width: 2,
                              color: step.isCompleted ? Colors.green.withValues(alpha: 0.5) : colorScheme.outlineVariant,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(width: 10),

                    // Step Info
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step.title,
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: step.isCurrent ? colorScheme.primary : colorScheme.onSurface,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(step.description, style: TextStyle(fontSize: 9.5, color: colorScheme.onSurfaceVariant, height: 1.3)),
                            const SizedBox(height: 2),
                            Text(
                              '${step.timestamp.hour}:${step.timestamp.minute.toString().padLeft(2, '0')} - ${step.timestamp.day}/${step.timestamp.month}/${step.timestamp.year}',
                              style: TextStyle(fontSize: 8.5, color: colorScheme.outline),
                            ),
                          ],
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
