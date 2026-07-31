import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step6TermsSectionWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step6TermsSectionWidget({super.key, required this.formData});

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
            'شروط وصلاحية عرض السعر',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'حدد فترة ثبات السعر والشروط الخاصة الموثقة بعرض السعر.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Validity Period Input
          TextFormField(
            initialValue: formData.validityPeriod,
            onChanged: (val) => controller.updateTermsDetails(validityPeriod: val),
            decoration: const InputDecoration(
              labelText: 'مدة صلاحية وثبات السعر *',
              hintText: '١٥ يوم من تاريخ الإصدار',
              prefixIcon: Icon(Icons.event_note_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Special Terms
          TextFormField(
            initialValue: formData.specialTerms,
            onChanged: (val) => controller.updateTermsDetails(specialTerms: val),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'الشروط والأحكام الخاصة بالعرض *',
              hintText: 'الأسعار شاملة ضريبة القيمة المضافة وموثقة بالضمان القانوني بالمنصة...',
              alignLabelWithHint: true,
              prefixIcon: Icon(Icons.gavel_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Additional Notes
          TextFormField(
            initialValue: formData.additionalNotes,
            onChanged: (val) => controller.updateTermsDetails(additionalNotes: val),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'ملاحظات إضافية للمصنع',
              hintText: 'الخامة مفحوصة ومطابقة لمعايير الجودة المصرية...',
              prefixIcon: Icon(Icons.rate_review_outlined),
            ),
          ),
        ],
      ),
    );
  }
}


