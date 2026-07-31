import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/financial_models.dart';

class EscrowProgressWidget extends StatelessWidget {
  final EscrowStage currentStage;

  const EscrowProgressWidget({super.key, required this.currentStage});

  @override
  Widget build(BuildContext context) {
    final stages = [
      _EscrowStep(EscrowStage.paymentReceived, 'تم استلام الدفعة من العميل', 'المال دخل حساب الضمان المشترك'),
      _EscrowStep(EscrowStage.moneyHeld, 'حجز الأموال في الضمان', 'الرصيد يظهر معلقاً في حسابك'),
      _EscrowStep(EscrowStage.shipmentDelivered, 'تأكيد تسليم الشحنة للموقع', 'تم استلام الشحنة من شركة الشحن'),
      _EscrowStep(EscrowStage.factoryInspection, 'فحص الجودة والمطابقة الفنية', 'جاري التحقق من المواد والمقاسات'),
      _EscrowStep(EscrowStage.factoryApproval, 'اعتماد المصنع والقبول الفني', 'الموافقة على مطابقة الشحنة للمواصفات'),
      _EscrowStep(EscrowStage.paymentReleased, 'الإفراج عن الدفعة وتغذية المحفظة', 'الأموال متاحة للسحب البنكي الآن'),
    ];

    final currentIndex = currentStage.index;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: List.generate(stages.length, (index) {
        final step = stages[index];
        final isCompleted = index < currentIndex;
        final isActive = index == currentIndex;

        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 24.0, right: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      step.title,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: isActive
                            ? AppColors.primary
                            : (isCompleted ? Theme.of(context).colorScheme.onSurface : AppColors.outline),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      step.description,
                      style: TextStyle(
                        fontSize: 10,
                        color: AppColors.outline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Timeline line and circle
            Column(
              children: [
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? const Color(0xFFE3FCEF)
                        : (isActive ? AppColors.primary.withValues(alpha: 0.1) : Colors.grey.shade100),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isCompleted
                          ? const Color(0xFF00875A)
                          : (isActive ? AppColors.primary : Colors.grey.shade300),
                      width: 2,
                    ),
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(Icons.check, size: 14, color: Color(0xFF00875A))
                        : (isActive
                            ? Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              )
                            : null),
                  ),
                ),
                if (index < stages.length - 1)
                  Container(
                    width: 2,
                    height: 36,
                    color: isCompleted ? const Color(0xFF00875A) : Colors.grey.shade300,
                  ),
              ],
            ),
          ],
        );
      }),
    );
  }
}

class _EscrowStep {
  final EscrowStage stage;
  final String title;
  final String description;

  const _EscrowStep(this.stage, this.title, this.description);
}
