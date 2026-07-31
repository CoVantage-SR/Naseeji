import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step2PricingSectionWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step2PricingSectionWidget({super.key, required this.formData});

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
            'التسعير وحساب الخصومات',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'أدخل سعر الوحدة والكمية. يتم حساب الإجمالي تلقائياً مع تطبيق الخصم.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Unit Price & Quantity Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.unitPrice.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = double.tryParse(val);
                    if (p != null) controller.updatePricingDetails(unitPrice: p);
                  },
                  decoration: const InputDecoration(
                    labelText: 'سعر الوحدة (بالجنيه) *',
                    hintText: '45.0',
                    prefixIcon: Icon(Icons.attach_money_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.quantity.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final q = int.tryParse(val);
                    if (q != null) controller.updatePricingDetails(quantity: q);
                  },
                  decoration: const InputDecoration(
                    labelText: 'الكمية المطلوبة *',
                    hintText: '1000',
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Discount Value & Type Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.discountValue.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final d = double.tryParse(val);
                    if (d != null) controller.updatePricingDetails(discountValue: d);
                  },
                  decoration: InputDecoration(
                    labelText: 'قيمة الخصم المقدم',
                    hintText: '5',
                    prefixIcon: const Icon(Icons.local_offer_outlined),
                    suffixText: formData.isDiscountPercentage ? '%' : formData.currency,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: DropdownButtonFormField<bool>(
                  initialValue: formData.isDiscountPercentage,
                  onChanged: (val) {
                    if (val != null) controller.updatePricingDetails(isDiscountPercentage: val);
                  },
                  items: const [
                    DropdownMenuItem(value: true, child: Text('خصم نسبة مئوية (%)', style: TextStyle(fontSize: 12))),
                    DropdownMenuItem(value: false, child: Text('خصم مبلغ ثابت (ج.م)', style: TextStyle(fontSize: 12))),
                  ],
                  decoration: const InputDecoration(
                    labelText: 'نوع الخصم',
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Auto-Calculated Price Summary Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [colorScheme.primary, colorScheme.primary.withValues(alpha: 0.85)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                _buildPriceRow('الإجمالي قبل الخصم:', '${formData.subtotalPrice.toStringAsFixed(0)} ${formData.currency}'),
                const Divider(color: Colors.white24, height: 16),
                _buildPriceRow('مبلغ الخصم المستقطع:', '- ${formData.calculatedDiscountAmount.toStringAsFixed(0)} ${formData.currency}'),
                const Divider(color: Colors.white24, height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('السعر الصافي النهائي:', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
                    Text(
                      '${formData.netFinalPrice.toStringAsFixed(0)} ${formData.currency}',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.white70)),
        Text(val, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white)),
      ],
    );
  }
}

