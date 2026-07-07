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
      _ProgressStep(title: 'إنشاء المسودة', completed: true),
      _ProgressStep(
        title: 'موافقة المورد', 
        completed: status != AgreementStatus.pendingApproval,
      ),
      _ProgressStep(
        title: 'تفعيل العقد من المصنع', 
        completed: status == AgreementStatus.active || status == AgreementStatus.completed,
      ),
      _ProgressStep(
        title: 'التوريد والفسح المالي', 
        completed: status == AgreementStatus.completed,
      ),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('خطوات اعتماد وتفعيل العقد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface)),
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
                          backgroundColor: step.completed ? const Color(0xFF0040E0) : AppColors.surfaceContainerLow,
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
                            color: step.completed ? const Color(0xFF0040E0) : AppColors.outline,
                          ),
                        ),
                      ],
                    ),
                    if (index < steps.length - 1)
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          height: 2,
                          color: step.completed ? const Color(0xFF0040E0) : AppColors.outlineVariant,
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
