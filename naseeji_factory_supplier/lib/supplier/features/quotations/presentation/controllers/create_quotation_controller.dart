import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/core/services/moderation/content_moderation_service.dart';
import 'package:naseeji_factory/core/services/moderation/domain/entities/moderation_enums.dart';
import 'package:naseeji_factory/core/services/moderation/presentation/content_moderation_dialog.dart';
import 'package:naseeji_factory/supplier/features/quotations/domain/entities/create_quotation_form_data.dart';
import 'package:naseeji_factory/supplier/features/quotations/domain/services/quotation_pdf_generator_service.dart';

class CreateQuotationController extends StateNotifier<CreateQuotationFormData> {
  final ContentModerationService moderationService;
  final QuotationPdfGeneratorService pdfGeneratorService;

  CreateQuotationController({
    required this.moderationService,
    required this.pdfGeneratorService,
  }) : super(const CreateQuotationFormData());

  void updateProductHeaderInfo({
    String? productName,
    String? category,
    String? rfqId,
    String? factoryName,
  }) {
    state = state.copyWith(
      productName: productName ?? state.productName,
      category: category ?? state.category,
      rfqId: rfqId ?? state.rfqId,
      factoryName: factoryName ?? state.factoryName,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void updatePricingDetails({
    double? unitPrice,
    int? quantity,
    double? discountValue,
    bool? isDiscountPercentage,
  }) {
    state = state.copyWith(
      unitPrice: unitPrice ?? state.unitPrice,
      quantity: quantity ?? state.quantity,
      discountValue: discountValue ?? state.discountValue,
      isDiscountPercentage: isDiscountPercentage ?? state.isDiscountPercentage,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void updateProductionDetails({
    String? productionLeadTime,
    String? preparationTime,
    String? targetDeliveryDate,
    String? dailyCapacity,
  }) {
    state = state.copyWith(
      productionLeadTime: productionLeadTime ?? state.productionLeadTime,
      preparationTime: preparationTime ?? state.preparationTime,
      targetDeliveryDate: targetDeliveryDate ?? state.targetDeliveryDate,
      dailyCapacity: dailyCapacity ?? state.dailyCapacity,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void updatePaymentDetails({
    PaymentMethodType? paymentMethod,
    double? advancePaymentPercentage,
    String? balanceDueDate,
  }) {
    state = state.copyWith(
      paymentMethod: paymentMethod ?? state.paymentMethod,
      advancePaymentPercentage: advancePaymentPercentage ?? state.advancePaymentPercentage,
      balanceDueDate: balanceDueDate ?? state.balanceDueDate,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void updateDeliveryDetails({
    String? pickupLocation,
    int? readyForPickupHours,
    String? deliveryNotes,
  }) {
    state = state.copyWith(
      pickupLocation: pickupLocation ?? state.pickupLocation,
      readyForPickupHours: readyForPickupHours ?? state.readyForPickupHours,
      deliveryNotes: deliveryNotes ?? state.deliveryNotes,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void updateTermsDetails({
    String? validityPeriod,
    String? specialTerms,
    String? additionalNotes,
  }) {
    state = state.copyWith(
      validityPeriod: validityPeriod ?? state.validityPeriod,
      specialTerms: specialTerms ?? state.specialTerms,
      additionalNotes: additionalNotes ?? state.additionalNotes,
      isDraftSaved: false,
    );
    _autoSaveDraft();
  }

  void goToStep(int step) {
    if (step >= 1 && step <= 7) {
      state = state.copyWith(currentStep: step);
      _autoSaveDraft();
    }
  }

  void nextStep(BuildContext context) {
    if (_validateStep(state.currentStep, context)) {
      if (state.currentStep < 7) {
        state = state.copyWith(currentStep: state.currentStep + 1);
        _autoSaveDraft();
      }
    }
  }

  void previousStep() {
    if (state.currentStep > 1) {
      state = state.copyWith(currentStep: state.currentStep - 1);
      _autoSaveDraft();
    }
  }

  bool _validateStep(int step, BuildContext context) {
    if (step == 2) {
      if (state.unitPrice <= 0) {
        _showSnackBar(context, 'يرجى إدخال سعر وحدة صحيح أكبر من صفر.');
        return false;
      }
      if (state.quantity <= 0) {
        _showSnackBar(context, 'يرجى إدخال كمية صحيحة أكبر من صفر.');
        return false;
      }
    }
    if (step == 5) {
      if (state.pickupLocation.isEmpty) {
        _showSnackBar(context, 'يرجى تحديد عنوان ومكان الاستلام في المصنع أو المخزن.');
        return false;
      }
    }
    return true;
  }

  void _autoSaveDraft() {
    Future.delayed(const Duration(milliseconds: 300), () {
      state = state.copyWith(isDraftSaved: true);
    });
  }

  void saveDraftManual(BuildContext context) {
    state = state.copyWith(isDraftSaved: true);
    _showSnackBar(context, 'تم حفظ مسودة عرض السعر بنجاح 💾');
  }

  Future<void> submitQuotation(BuildContext context) async {
    // 1. Check Content Moderation Security for Terms & Notes
    final textToCheck = '${state.specialTerms} ${state.additionalNotes} ${state.deliveryNotes}';
    final modResult = await moderationService.moderateContent(
      text: textToCheck,
      target: ModerationTarget.quotation,
    );

    if (!modResult.isAllowed) {
      if (context.mounted) {
        ContentModerationDialog.show(context, result: modResult);
      }
      return; // Block submission
    }

    // 2. Generate PDF Document automatically
    final pdfDoc = pdfGeneratorService.generatePdfDocument(state);

    if (context.mounted) {
      // Show Success Dialog with PDF details
      showDialog(
        context: context,
        builder: (context) => Directionality(
          textDirection: TextDirection.rtl,
          child: AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: Row(
              children: const [
                Icon(Icons.check_circle_rounded, color: Colors.green, size: 28),
                SizedBox(width: 8),
                Text('تم إنشاء وإرسال عرض السعر!'),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('تم إصدار وثيقة الـ PDF الرسمية بنجاح:'),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.picture_as_pdf_rounded, color: Colors.red, size: 28),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          pdfDoc.fileName,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'إجمالي العرض النهائي: ${state.netFinalPrice.toStringAsFixed(0)} ${state.currency}',
                  style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF2E7D32)),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                  _showSnackBar(context, 'جاري تحميل ملف PDF: ${pdfDoc.fileName}');
                },
                child: const Text('تحميل الـ PDF'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pop(context); // Exit wizard
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                ),
                child: const Text('تم الانتقال للصفقة'),
              ),
            ],
          ),
        ),
      );
    }
  }

  void _showSnackBar(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }
}

final createQuotationControllerProvider =
    StateNotifierProvider<CreateQuotationController, CreateQuotationFormData>((ref) {
  return CreateQuotationController(
    moderationService: ContentModerationService(),
    pdfGeneratorService: QuotationPdfGeneratorService(),
  );
});


