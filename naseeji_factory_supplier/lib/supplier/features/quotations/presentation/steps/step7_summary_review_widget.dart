import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step7SummaryReviewWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step7SummaryReviewWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(createQuotationControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'مراجعة العرض والمعاينة الفورية',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'راجع كافة الشروط والأسعار المعروضة أدناه قبل الإصدار والتوليد الآلي لملف الـ PDF.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Total Highlight Banner
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('الإجمالي الصافي لعرض السعر:', style: TextStyle(fontSize: 12, color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      '${formData.netFinalPrice.toStringAsFixed(0)} ${formData.currency}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.picture_as_pdf_rounded, color: Colors.white, size: 16),
                      SizedBox(width: 4),
                      Text('PDF تلقائي', style: TextStyle(fontSize: 11, color: Colors.white, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Summary Cards with Direct Edit Buttons
          _buildSummarySectionCard(
            context,
            title: '1. بيانات المنتج والـ RFQ',
            content: '${formData.productName}\n${formData.category} • ${formData.factoryName}\nطلب سعر: ${formData.rfqId}',
            onEdit: () => controller.goToStep(1),
          ),
          const SizedBox(height: 10),

          _buildSummarySectionCard(
            context,
            title: '2. تفاصيل التسعير والخصم',
            content: 'سعر الوحدة: ${formData.unitPrice} ${formData.currency}\nالكمية: ${formData.quantity} وحدة\nالخصم: ${formData.calculatedDiscountAmount.toStringAsFixed(0)} ${formData.currency}',
            onEdit: () => controller.goToStep(2),
          ),
          const SizedBox(height: 10),

          _buildSummarySectionCard(
            context,
            title: '3. التصنيع والجاهزية',
            content: 'مدة الإنتاج: ${formData.productionLeadTime}\nمدة التعبئة: ${formData.preparationTime}\nأقرب تسليم: ${formData.targetDeliveryDate}',
            onEdit: () => controller.goToStep(3),
          ),
          const SizedBox(height: 10),

          _buildSummarySectionCard(
            context,
            title: '4. طرق ودفعات التسديد',
            content: '${formData.paymentMethod.arabicLabel}\nالدفعة المقدمة: ${formData.advancePaymentPercentage.toStringAsFixed(0)}% (${formData.advancePaymentAmount.toStringAsFixed(0)} ${formData.currency})\nالباقي: ${formData.balanceDueDate}',
            onEdit: () => controller.goToStep(4),
          ),
          const SizedBox(height: 10),

          _buildSummarySectionCard(
            context,
            title: '5. مكان الاستلام والشحن',
            content: '${formData.pickupLocation}\nجاهز خلال: ${formData.readyForPickupHours} ساعة\nالنقل الضامن يتم عبر منصة نسيجي.',
            onEdit: () => controller.goToStep(5),
          ),
          const SizedBox(height: 10),

          _buildSummarySectionCard(
            context,
            title: '6. الشروط والصلاحية',
            content: 'مدة الصلاحية: ${formData.validityPeriod}\nالشروط: ${formData.specialTerms}',
            onEdit: () => controller.goToStep(6),
          ),
          const SizedBox(height: 20),

          // Big Submit & Auto-Generate PDF Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.submitQuotation(context),
              icon: const Icon(Icons.send_rounded, size: 20),
              label: const Text(
                'تأكيد وإنشاء الـ PDF وإرسال العرض للمصنع',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2E7D32),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                minimumSize: const Size(0, 50),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummarySectionCard(
    BuildContext context, {
    required String title,
    required String content,
    required VoidCallback onEdit,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
              ),
              TextButton.icon(
                onPressed: onEdit,
                icon: const Icon(Icons.edit_outlined, size: 14),
                label: const Text('تعديل'),
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}



