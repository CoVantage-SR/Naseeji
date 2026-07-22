import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementProgressWidget extends StatelessWidget {
  final B2BAgreement agreement;

  const AgreementProgressWidget({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    final status = agreement.status;

    final steps = [
      _ProgressStep(title: 'المسودة', completed: true),
      _ProgressStep(
        title: 'توقيع المورد', 
        completed: status != AgreementStatus.draft && status != AgreementStatus.awaitingSupplierSignature,
      ),
      _ProgressStep(
        title: 'توقيع المصنع', 
        completed: status == AgreementStatus.active || status == AgreementStatus.inProduction || status == AgreementStatus.completed,
      ),
      _ProgressStep(
        title: 'الإنتاج والتسليم', 
        completed: status == AgreementStatus.inProduction || status == AgreementStatus.completed,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'خطوات اعتماد وتفعيل العقد',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(steps.length, (index) {
              final step = steps[index];
              return Expanded(
                child: Row(
                  children: [
                    Column(
                      children: [
                        CircleAvatar(
                          radius: 10,
                          backgroundColor: step.completed ? AppColors.primary : Theme.of(context).colorScheme.surfaceContainerLow,
                          child: Icon(
                            step.completed ? Icons.check : Icons.circle_outlined,
                            size: 10,
                            color: step.completed ? Colors.white : AppColors.outline,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          step.title,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: step.completed ? AppColors.primary : AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          height: 2,
                          color: step.completed ? AppColors.primary : AppColors.outlineVariant,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _ProgressStep {
  final String title;
  final bool completed;

  const _ProgressStep({required this.title, required this.completed});
}
