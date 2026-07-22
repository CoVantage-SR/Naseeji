import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/product_form_data.dart';
import '../controllers/add_product_controller.dart';

class Step8ReviewPublishWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step8ReviewPublishWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);

    final bool hasName = formData.name.isNotEmpty;
    final bool hasImage = formData.mainCoverImage != null;
    final bool hasPrice = formData.tieredPrices.isNotEmpty;
    final bool hasMoq = formData.moq > 0;
    final bool limitsOk = formData.usedImagesCount <= formData.maxImagesAllowed &&
        formData.usedVideosCount <= formData.maxVideosAllowed &&
        formData.usedPdfsCount <= formData.maxPdfsAllowed;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'المراجعة النهائية وتأكيد النشر',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'راجع كافة البيانات المرفقة أدناه قبل الفحص النهائي ونشر المنتج بالشبكة.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Pre-publish Validation Checklist Box
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: formData.isReadyForPublish ? Colors.green.shade50 : Colors.orange.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: formData.isReadyForPublish ? Colors.green.shade300 : Colors.orange.shade300,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      formData.isReadyForPublish ? Icons.verified_rounded : Icons.pending_actions_rounded,
                      color: formData.isReadyForPublish ? Colors.green.shade800 : Colors.orange.shade900,
                      size: 22,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      formData.isReadyForPublish ? 'جميع متطلبات الفحص الشامل مكتملة!' : 'ملاحظات وتنبيهات الفحص الشامل',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: formData.isReadyForPublish ? Colors.green.shade900 : Colors.orange.shade900,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _buildCheckItem('الحقول التعريفية الأساسية مكتملة', hasName),
                _buildCheckItem('تم تحديد صورة غلاف رئيسية للمنتج', hasImage),
                _buildCheckItem('تم تحديد شرائح الأسعار وخصومات الكميات', hasPrice),
                _buildCheckItem('تم تحديد حد أدنى للطلب (MOQ)', hasMoq),
                _buildCheckItem('حدود اشتراك الباقة تسمح بالنشر (الصور والوسائط)', limitsOk),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Sections Summary Cards with Edit Buttons
          _buildReviewCard(
            context,
            title: '1. المعلومات الأساسية',
            content: '${formData.name}\n${formData.category} › ${formData.subCategory}\nبلد المنشأ: ${formData.countryOfOrigin} • العلامة: ${formData.brand}',
            onEdit: () => controller.goToStep(1),
          ),
          const SizedBox(height: 10),

          _buildReviewCard(
            context,
            title: '2. المواصفات الفنية (${formData.technicalSpecs.length} مواصفات)',
            content: formData.technicalSpecs.entries.map((e) => '• ${e.key}: ${e.value}').join('\n'),
            onEdit: () => controller.goToStep(2),
          ),
          const SizedBox(height: 10),

          _buildReviewCard(
            context,
            title: '3. الصور والوسائط',
            content: 'الصورة الرئيسية: متوفرة\nالصور الإضافية: ${formData.additionalImages.length} صور\nاستهلاك حد الصور: ${formData.usedImagesCount} / ${formData.maxImagesAllowed}',
            onEdit: () => controller.goToStep(3),
          ),
          const SizedBox(height: 10),

          _buildReviewCard(
            context,
            title: '4. الكتالوج والملفات (PDF)',
            content: 'عدد ملفات PDF المرفوعة: ${formData.pdfDocuments.length}\nالاستهلاك: ${formData.usedPdfsCount} / ${formData.maxPdfsAllowed}',
            onEdit: () => controller.goToStep(5),
          ),
          const SizedBox(height: 10),

          _buildReviewCard(
            context,
            title: '5. الأسعار وشرائح الجملة',
            content: 'أقل كمية للطلب (MOQ): ${formData.moq} وحدة\nشرائح الأسعار: ${formData.tieredPrices.length} شرائح محددة',
            onEdit: () => controller.goToStep(6),
          ),
          const SizedBox(height: 10),

          _buildReviewCard(
            context,
            title: '6. الطاقة الإنتاجية واللوجستيات',
            content: 'الكمية بالمخزن: ${formData.availableStock} • الطاقة اليومية: ${formData.dailyCapacity}\nمكان الاستلام: ${formData.pickupLocation}',
            onEdit: () => controller.goToStep(7),
          ),
          const SizedBox(height: 20),

          // Big Publish Button Prompt
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => controller.publishProduct(context),
              icon: const Icon(Icons.rocket_launch_rounded, size: 20),
              label: const Text(
                'تأكيد ونشر المنتج بالمنصة الآن',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
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

  Widget _buildCheckItem(String label, bool isOk) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2.0),
      child: Row(
        children: [
          Icon(
            isOk ? Icons.check_circle_rounded : Icons.cancel_rounded,
            size: 16,
            color: isOk ? Colors.green.shade800 : Colors.red,
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isOk ? FontWeight.w600 : FontWeight.bold,
              color: isOk ? Colors.green.shade900 : Colors.red.shade900,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReviewCard(
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
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
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
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
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
