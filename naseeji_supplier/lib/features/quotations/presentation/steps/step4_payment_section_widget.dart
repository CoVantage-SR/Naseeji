import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step4PaymentSectionWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step4PaymentSectionWidget({super.key, required this.formData});

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
            'طرق ودفعات التسديد',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'اختر طريقة الدفع المناسبة وحدد نسبة الدفعة المقدمة لحجز طلبية المصنع.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Payment Methods Chips Selection
          Text('طريقة الدفع المحددة بالعرض *', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 8),

          Column(
            children: PaymentMethodType.values.map((type) {
              final isSelected = formData.paymentMethod == type;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: RadioListTile<PaymentMethodType>(
                  value: type,
                  groupValue: formData.paymentMethod,
                  onChanged: (val) {
                    if (val != null) controller.updatePaymentDetails(paymentMethod: val);
                  },
                  title: Text(type.arabicLabel, style: TextStyle(fontSize: 13, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                  activeColor: colorScheme.primary,
                  tileColor: isSelected ? colorScheme.primary.withValues(alpha: 0.08) : colorScheme.surface,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: BorderSide(
                      color: isSelected ? colorScheme.primary : colorScheme.outlineVariant.withValues(alpha: 0.4),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 14),

          // Advance Payment % & Balance Due Date Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.advancePaymentPercentage.toStringAsFixed(0),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = double.tryParse(val);
                    if (p != null) controller.updatePaymentDetails(advancePaymentPercentage: p);
                  },
                  decoration: const InputDecoration(
                    labelText: 'نسبة الدفعة المقدمة (%) *',
                    hintText: '50',
                    prefixIcon: Icon(Icons.percent_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.balanceDueDate,
                  onChanged: (val) => controller.updatePaymentDetails(balanceDueDate: val),
                  decoration: const InputDecoration(
                    labelText: 'موعد استحقاق الباقي *',
                    hintText: 'عند الاستلام والتأكيد',
                    prefixIcon: Icon(Icons.event_available_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Calculated Advance Amount Preview Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'قيمة الدفعة المقدمة المطلوبة (${formData.advancePaymentPercentage.toStringAsFixed(0)}%):',
                  style: TextStyle(fontSize: 12, color: Colors.green.shade900),
                ),
                Text(
                  '${formData.advancePaymentAmount.toStringAsFixed(0)} ${formData.currency}',
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.green.shade900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
