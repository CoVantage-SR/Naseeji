import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementTimelineWidget extends StatelessWidget {
  final List<AgreementTimelineStep> timeline;

  const AgreementTimelineWidget({super.key, required this.timeline});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.timeline_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'الخط الزمني وسجل إجراءات الاتفاق',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),

          if (timeline.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Text(
                  'لا يوجد خط زمني مسجل حتى الآن.',
                  style: theme.textTheme.bodySmall?.copyWith(color: colorScheme.outline),
                ),
              ),
            )
          else
            Column(
              children: List.generate(timeline.length, (index) {
                final step = timeline[index];
                final isLast = index == timeline.length - 1;

                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: isLast ? AppColors.primary : colorScheme.outline,
                          ),
                        ),
                        if (index < timeline.length - 1)
                          Container(
                            width: 2,
                            height: 40,
                            color: colorScheme.outlineVariant,
                          ),
                      ],
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  step.status,
                                  style: theme.textTheme.bodySmall?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  '${step.date} • ${step.time}',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: colorScheme.outline,
                                    fontSize: 9,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'بواسطة: ${step.user}',
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (step.notes.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                step.notes,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontSize: 10,
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
            ),
        ],
      ),
    );
  }
}


