import 'package:flutter/material.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementStatusWidget extends StatelessWidget {
  final AgreementStatus status;

  const AgreementStatusWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = status.color;

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.25)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Badge & Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                ),
                child: Icon(status.icon, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'حالة الاتفاق الحالية',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: theme.colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      status.titleAr,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: color,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            status.descriptionEg,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 14),

          // Workflow Step Progression Bar (If not cancelled or expired)
          if (status.stepIndex >= 0) ...[
            const Divider(height: 1),
            const SizedBox(height: 12),
            _buildProgressBar(context),
          ],
        ],
      ),
    );
  }

  Widget _buildProgressBar(BuildContext context) {
    final steps = [
      'مسودة',
      'توقيع المورد',
      'توقيع المصنع',
      'ساري',
      'قيد الإنتاج',
      'مكتمل',
    ];

    final currentStep = status.stepIndex;

    return Row(
      children: List.generate(steps.length, (index) {
        final isPassed = index <= currentStep;
        final isCurrent = index == currentStep;
        final color = isPassed ? status.color : Colors.grey.shade300;

        return Expanded(
          child: Column(
            children: [
              Row(
                children: [
                  if (index > 0)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index <= currentStep ? status.color : Colors.grey.shade300,
                      ),
                    ),
                  Container(
                    width: isCurrent ? 14 : 10,
                    height: isCurrent ? 14 : 10,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: color,
                      border: isCurrent ? Border.all(color: Colors.white, width: 2) : null,
                    ),
                  ),
                  if (index < steps.length - 1)
                    Expanded(
                      child: Container(
                        height: 3,
                        color: index < currentStep ? status.color : Colors.grey.shade300,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 6),
              Text(
                steps[index],
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 8,
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isPassed ? Theme.of(context).colorScheme.onSurface : Colors.grey,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
