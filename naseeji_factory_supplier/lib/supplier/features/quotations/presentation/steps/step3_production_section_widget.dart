import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step3ProductionSectionWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step3ProductionSectionWidget({super.key, required this.formData});

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
            'التصنيع والطاقة الإنتاجية',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'حدد مدة التصنيع والتعبئة وأقرب موعد لتسليم الكمية المطلوبة.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Production Lead Time & Preparation Time Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.productionLeadTime,
                  onChanged: (val) => controller.updateProductionDetails(productionLeadTime: val),
                  decoration: const InputDecoration(
                    labelText: 'مدة الإنتاج والتصنيع *',
                    hintText: '٧ أيام عمل',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.preparationTime,
                  onChanged: (val) => controller.updateProductionDetails(preparationTime: val),
                  decoration: const InputDecoration(
                    labelText: 'مدة التجهيز والتعبئة *',
                    hintText: '٢٤ ساعة',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Target Delivery Date & Capacity Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.targetDeliveryDate,
                  onChanged: (val) => controller.updateProductionDetails(targetDeliveryDate: val),
                  decoration: const InputDecoration(
                    labelText: 'أقرب موعد لتسليم الشحنة *',
                    hintText: '٢٨ يوليو ٢٠٢٦',
                    prefixIcon: Icon(Icons.event_available_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.dailyCapacity,
                  onChanged: (val) => controller.updateProductionDetails(dailyCapacity: val),
                  decoration: const InputDecoration(
                    labelText: 'الطاقة الإنتاجية اليومية',
                    hintText: '٥,٠٠٠ كجم / يوم',
                    prefixIcon: Icon(Icons.speed_rounded),
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

