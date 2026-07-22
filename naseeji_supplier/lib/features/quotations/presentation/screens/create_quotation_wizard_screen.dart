import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/create_quotation_controller.dart';
import '../steps/step1_product_header_widget.dart';
import '../steps/step2_pricing_section_widget.dart';
import '../steps/step3_production_section_widget.dart';
import '../steps/step4_payment_section_widget.dart';
import '../steps/step5_delivery_section_widget.dart';
import '../steps/step6_terms_section_widget.dart';
import '../steps/step7_summary_review_widget.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class CreateQuotationWizardScreen extends ConsumerWidget {
  const CreateQuotationWizardScreen({super.key});

  Widget _buildActiveStepWidget(int step, CreateQuotationFormData formData) {
    switch (step) {
      case 1:
        return Step1ProductHeaderWidget(formData: formData);
      case 2:
        return Step2PricingSectionWidget(formData: formData);
      case 3:
        return Step3ProductionSectionWidget(formData: formData);
      case 4:
        return Step4PaymentSectionWidget(formData: formData);
      case 5:
        return Step5DeliverySectionWidget(formData: formData);
      case 6:
        return Step6TermsSectionWidget(formData: formData);
      case 7:
        return Step7SummaryReviewWidget(formData: formData);
      default:
        return Step1ProductHeaderWidget(formData: formData);
    }
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 1:
        return 'الخطوة الأولى: بيانات المنتج والـ RFQ';
      case 2:
        return 'الخطوة الثانية: التسعير وحساب الخصم';
      case 3:
        return 'الخطوة الثالثة: التصنيع والطاقة الإنتاجية';
      case 4:
        return 'الخطوة الرابعة: طرق ودفعات التسديد';
      case 5:
        return 'الخطوة الخامسة: مكان الاستلام والتسليم';
      case 6:
        return 'الخطوة السادسة: الشروط والمدة المعتمدة';
      case 7:
        return 'الخطوة السابعة: المراجعة وإنشاء الـ PDF';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formData = ref.watch(createQuotationControllerProvider);
    final controller = ref.read(createQuotationControllerProvider.notifier);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isFirstStep = formData.currentStep == 1;
    final isLastStep = formData.currentStep == 7;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('معالج إنشاء عرض سعر B2B', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_rounded),
            onPressed: () => context.pop(),
          ),
        ),
        body: Column(
          children: [
            // Top Progress Header Card
            Container(
              margin: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                              'الخطوة ${formData.currentStep} من 7',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onPrimary),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '${formData.completionPercentage.round()}% مكتمل',
                            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
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
                            formData.isDraftSaved ? 'حفظ تلقائي كمسودة' : 'جاري الحفظ...',
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
                  Text(_getStepTitle(formData.currentStep), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),

                  // Step Progress Squares
                  Row(
                    children: List.generate(7, (index) {
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
            ),

            // Active Step Form Body
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14.0),
                child: _buildActiveStepWidget(formData.currentStep, formData),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: colorScheme.surface,
                border: Border(top: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.4))),
              ),
              child: SafeArea(
                child: Row(
                  children: [
                    if (!isFirstStep)
                      OutlinedButton.icon(
                        onPressed: () => controller.previousStep(),
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16),
                        label: const Text('السابق'),
                        style: OutlinedButton.styleFrom(minimumSize: const Size(0, 42)),
                      ),
                    if (!isFirstStep) const SizedBox(width: 8),

                    TextButton.icon(
                      onPressed: () => controller.saveDraftManual(context),
                      icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                      label: const Text('حفظ مسودة'),
                      style: TextButton.styleFrom(
                        foregroundColor: colorScheme.onSurfaceVariant,
                        minimumSize: const Size(0, 42),
                      ),
                    ),
                    const Spacer(),

                    ElevatedButton.icon(
                      onPressed: () {
                        if (isLastStep) {
                          controller.submitQuotation(context);
                        } else {
                          controller.nextStep(context);
                        }
                      },
                      icon: Icon(isLastStep ? Icons.picture_as_pdf_rounded : Icons.arrow_back_rounded, size: 18),
                      label: Text(
                        isLastStep ? 'إنشاء PDF وإرسال العرض' : 'التالي',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: isLastStep ? const Color(0xFF2E7D32) : colorScheme.primary,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(0, 42),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
