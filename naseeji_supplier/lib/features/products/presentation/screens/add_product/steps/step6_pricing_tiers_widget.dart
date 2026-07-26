import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_supplier/features/products/presentation/controllers/add_product_controller.dart';

class Step6PricingTiersWidget extends ConsumerStatefulWidget {
  final ProductFormData formData;

  const Step6PricingTiersWidget({super.key, required this.formData});

  @override
  ConsumerState<Step6PricingTiersWidget> createState() => _Step6PricingTiersWidgetState();
}

class _Step6PricingTiersWidgetState extends ConsumerState<Step6PricingTiersWidget> {
  final TextEditingController _qtyController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  @override
  void dispose() {
    _qtyController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _showAddTierDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إضافة شريحة سعر جديدة'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _qtyController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'الحد الأدنى للكمية',
                hintText: 'مثال: 500',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'سعر الوحدة (بالجنيه)',
                hintText: 'مثال: 47',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final q = int.tryParse(_qtyController.text) ?? 0;
              final p = double.tryParse(_priceController.text) ?? 0.0;
              if (q > 0 && p > 0) {
                ref.read(addProductControllerProvider.notifier).addTierPrice(q, p);
              }
              _qtyController.clear();
              _priceController.clear();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(0, 36),
            ),
            child: const Text('إضافة الشريحة'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);
    final tiers = widget.formData.tieredPrices;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'جدول أسعار الجملة وخصومات الكميات',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'حدد أسعار التدرج حسب الكميات المطلوبة لتشجيع طلبيات المصانع الكبيرة.',
                      style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _showAddTierDialog(context),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('إضافة شريحة'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  minimumSize: const Size(0, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // MOQ & Validity Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: widget.formData.moq.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final parsed = int.tryParse(val);
                    if (parsed != null) controller.updatePricingDetails(moq: parsed);
                  },
                  decoration: const InputDecoration(
                    labelText: 'أقل كمية للطلب (MOQ) *',
                    hintText: '100',
                    prefixIcon: Icon(Icons.shopping_bag_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: widget.formData.priceValidityPeriod,
                  onChanged: (val) => controller.updatePricingDetails(priceValidityPeriod: val),
                  decoration: const InputDecoration(
                    labelText: 'مدة صلاحية السعر',
                    hintText: '30 يوم',
                    prefixIcon: Icon(Icons.timer_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tier Price List Table
          Text('شرائح أسعار الجملة المحددة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 8),

          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            child: ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: tiers.length,
              separatorBuilder: (context, index) => Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
              itemBuilder: (context, index) {
                final tier = tiers[index];
                final qty = tier['quantity'] ?? 0;
                final price = tier['price'] ?? 0.0;

                return ListTile(
                  leading: CircleAvatar(
                    radius: 14,
                    backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
                    child: Icon(Icons.sell_outlined, size: 14, color: colorScheme.primary),
                  ),
                  title: Text('ابتداءً من $qty وحدة:', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '${(price as num).toStringAsFixed(0)} ج.م / وحدة',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
                      ),
                      const SizedBox(width: 8),
                      IconButton(
                        icon: const Icon(Icons.delete_outline_rounded, color: Colors.red, size: 20),
                        onPressed: () => controller.removeTierPrice(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 14),

          // Wholesale Discounts Note
          TextFormField(
            initialValue: widget.formData.wholesaleDiscounts,
            onChanged: (val) => controller.updatePricingDetails(wholesaleDiscounts: val),
            decoration: const InputDecoration(
              labelText: 'ملاحظات وتخفيضات الكميات الخاصة',
              hintText: 'مثال: خصم 15% إضافي للطلبيات السريعة الدفع كاش',
              prefixIcon: Icon(Icons.local_offer_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
