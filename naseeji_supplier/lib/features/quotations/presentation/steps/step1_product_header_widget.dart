import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step1ProductHeaderWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step1ProductHeaderWidget({super.key, required this.formData});

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
            'بيانات الطلب والمنتج المستهدف',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'تأكد من اختيار بيانات المنتج والـ RFQ الصحيحة قبل تحديد الأسعار.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Factory Info Header Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage('https://images.unsplash.com/photo-1560179707-f14e90ef3623?auto=format&fit=crop&w=200&q=80'),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formData.factoryName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const SizedBox(height: 2),
                      Text('طلب سعر: ${formData.rfqId}', style: TextStyle(fontSize: 11, color: colorScheme.primary, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Product Image & Name Input
          TextFormField(
            initialValue: formData.productName,
            onChanged: (val) => controller.updateProductHeaderInfo(productName: val),
            decoration: const InputDecoration(
              labelText: 'اسم المنتج *',
              hintText: 'خيوط قطن غزل دائرية 30/1',
              prefixIcon: Icon(Icons.inventory_2_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Category Dropdown
          TextFormField(
            initialValue: formData.category,
            onChanged: (val) => controller.updateProductHeaderInfo(category: val),
            decoration: const InputDecoration(
              labelText: 'الفئة الرئيسية *',
              hintText: 'خيوط ونُسُج',
              prefixIcon: Icon(Icons.category_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // RFQ ID & Factory Name Edit Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.rfqId,
                  onChanged: (val) => controller.updateProductHeaderInfo(rfqId: val),
                  decoration: const InputDecoration(
                    labelText: 'رقم الـ RFQ *',
                    prefixIcon: Icon(Icons.request_quote_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.factoryName,
                  onChanged: (val) => controller.updateProductHeaderInfo(factoryName: val),
                  decoration: const InputDecoration(
                    labelText: 'اسم المصنع *',
                    prefixIcon: Icon(Icons.factory_outlined),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
