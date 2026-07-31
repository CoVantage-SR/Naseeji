import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_form_data.dart';

class WizardProgressHeader extends StatelessWidget {
  final ProductFormData formData;

  const WizardProgressHeader({
    super.key,
    required this.formData,
  });

  String get _stepTitle {
    switch (formData.currentStep) {
      case 1:
        return 'الخطوة الأولى: المعلومات الأساسية للمنتج';
      case 2:
        return 'الخطوة الثانية: المواصفات الفنية للنسيج والخامة';
      case 3:
        return 'الخطوة الثالثة: الصور الرئيسية والمعرض';
      case 4:
        return 'الخطوة الرابعة: فيديو استعراض تصنيع المنتج';
      case 5:
        return 'الخطوة الخامسة: الكتالوج وملفات المواصفات (PDF)';
      case 6:
        return 'الخطوة السادسة: الأسعار وشرائح الجملة (MOQ)';
      case 7:
        return 'الخطوة السابعة: الطاقة الإنتاجية واللوجستيات';
      case 8:
        return 'الخطوة الثامنة: المراجعة النهائية والنشر';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row: Step count & Auto-save status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'الخطوة ${formData.currentStep} من 8',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '${formData.completionPercentage.round()}% مكتمل',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    formData.isDraftSaved ? Icons.cloud_done_outlined : Icons.cloud_upload_outlined,
                    size: 14,
                    color: formData.isDraftSaved ? Colors.green.shade800 : colorScheme.outline,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    formData.isDraftSaved ? 'تم الحفظ مسودة' : 'جاري الحفظ...',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: formData.isDraftSaved ? Colors.green.shade800 : colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Title
          Text(
            _stepTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 10),

          // Step Progress Squares (■■■■□□□□)
          Row(
            children: List.generate(8, (index) {
              final stepNum = index + 1;
              final isDone = stepNum < formData.currentStep;
              final isCurrent = stepNum == formData.currentStep;

              return Expanded(
                child: Container(
                  height: 6,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: isDone
                        ? const Color(0xFF2E7D32)
                        : isCurrent
                            ? colorScheme.primary
                            : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}
