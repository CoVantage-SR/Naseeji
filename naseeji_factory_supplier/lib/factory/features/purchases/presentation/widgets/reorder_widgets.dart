import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../orders/presentation/providers/orders_provider.dart';

// ─── Previous Order Widget ─────────────────────────────────────────────────
class PreviousOrderWidget extends StatelessWidget {
  final OrderModel order;
  const PreviousOrderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.05),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history_rounded, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              const Text(
                'بيانات الطلب الأصلي',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              ClipRRect(
                borderRadius: AppRadius.rSM,
                child: Image.network(
                  order.productImage,
                  width: 56,
                  height: 56,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 56,
                    height: 56,
                    color: Colors.grey.shade200,
                    child: const Icon(Icons.image_not_supported_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(order.productName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
                    const SizedBox(height: 4),
                    Text('المورد: ${order.supplierName}', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('الكمية السابقة: ${order.quantity} وحدة', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                    Text('السعر الأصلي: ${order.finalPrice.toInt()} ج.م', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Editable Products Widget ─────────────────────────────────────────────
class EditableProductsWidget extends StatelessWidget {
  final int quantity;
  final String color;
  final String size;
  final String material;
  final ValueChanged<int> onQuantityChanged;
  final ValueChanged<String> onColorChanged;
  final ValueChanged<String> onSizeChanged;
  final ValueChanged<String> onMaterialChanged;

  const EditableProductsWidget({
    super.key,
    required this.quantity,
    required this.color,
    required this.size,
    required this.material,
    required this.onQuantityChanged,
    required this.onColorChanged,
    required this.onSizeChanged,
    required this.onMaterialChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'تعديل مواصفات الطلب الجديد',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 16),
            // Quantity
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الكمية المطلوبة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove_circle_outline_rounded, color: AppColors.primary),
                      onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                        borderRadius: AppRadius.rSM,
                      ),
                      child: Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_circle_outline_rounded, color: AppColors.primary),
                      onPressed: () => onQuantityChanged(quantity + 1),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(height: 20),
            _editField('اللون المطلوب', color, Icons.color_lens_rounded, onColorChanged),
            const SizedBox(height: 12),
            _editField('المقاس / الأبعاد', size, Icons.straighten_rounded, onSizeChanged),
            const SizedBox(height: 12),
            _editField('نوع الخامة / المادة', material, Icons.category_rounded, onMaterialChanged),
          ],
        ),
      ),
    );
  }

  Widget _editField(String label, String initialValue, IconData icon, ValueChanged<String> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        const SizedBox(height: 6),
        TextFormField(
          initialValue: initialValue,
          onChanged: onChanged,
          style: const TextStyle(fontSize: 12),
          decoration: InputDecoration(
            prefixIcon: Icon(icon, size: 18, color: AppColors.primary),
            border: OutlineInputBorder(borderRadius: AppRadius.rSM),
            contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
          ),
        ),
      ],
    );
  }
}

// ─── Delivery Widget ───────────────────────────────────────────────────────
class DeliveryWidget extends StatelessWidget {
  final String deliveryDate;
  final ValueChanged<String> onDateChanged;

  const DeliveryWidget({
    super.key,
    required this.deliveryDate,
    required this.onDateChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: isDark ? AppColors.borderDark : AppColors.borderLight),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'موعد التسليم المطلوب',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now().add(const Duration(days: 14)),
                  firstDate: DateTime.now(),
                  lastDate: DateTime.now().add(const Duration(days: 365)),
                );
                if (picked != null) {
                  onDateChanged('${picked.year}/${picked.month.toString().padLeft(2, '0')}/${picked.day.toString().padLeft(2, '0')}');
                }
              },
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
                  borderRadius: AppRadius.rSM,
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, color: AppColors.primary, size: 20),
                    const SizedBox(width: 10),
                    Text(
                      deliveryDate.isEmpty ? 'اختر تاريخ التسليم' : deliveryDate,
                      style: TextStyle(
                        fontSize: 12,
                        color: deliveryDate.isEmpty ? Colors.grey : null,
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

// ─── Reorder Summary Widget ────────────────────────────────────────────────
class SummaryWidget extends StatelessWidget {
  final int quantity;
  final double unitPrice;
  const SummaryWidget({super.key, required this.quantity, required this.unitPrice});

  @override
  Widget build(BuildContext context) {
    final estimatedTotal = quantity * unitPrice;
    return Card(
      elevation: 0,
      color: AppColors.primary.withValues(alpha: 0.05),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rMD,
        side: BorderSide(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'ملخص الطلب الجديد (تقديري)',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('الكمية المطلوبة:', style: const TextStyle(fontSize: 11, color: Colors.grey)),
                Text('$quantity وحدة', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('سعر الوحدة (تقديري):', style: TextStyle(fontSize: 11, color: Colors.grey)),
                Text('${unitPrice.toStringAsFixed(1)} ج.م', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ],
            ),
            const Divider(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('الإجمالي التقديري:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                Text(
                  '${estimatedTotal.toInt()} ج.م',
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary),
                ),
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              '* السعر النهائي يحدد بعد تأكيد المورد وإرسال عرض السعر.',
              style: TextStyle(fontSize: 9, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Reorder Submit Widget ─────────────────────────────────────────────────
class ReorderSubmitWidget extends StatelessWidget {
  final VoidCallback onSendRFQ;
  final VoidCallback onRepeatSame;
  final VoidCallback onCancel;

  const ReorderSubmitWidget({
    super.key,
    required this.onSendRFQ,
    required this.onRepeatSame,
    required this.onCancel,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton.icon(
            onPressed: onSendRFQ,
            icon: const Icon(Icons.request_quote_rounded, size: 18),
            label: const Text('إرسال طلب عرض سعر جديد', style: TextStyle(fontSize: 13)),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
              elevation: 0,
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onRepeatSame,
            icon: const Icon(Icons.repeat_rounded, size: 18),
            label: const Text('تكرار نفس الطلب بدون تغيير', style: TextStyle(fontSize: 13)),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: TextButton(
            onPressed: onCancel,
            child: const Text('إلغاء', style: TextStyle(color: Colors.grey)),
          ),
        ),
      ],
    );
  }
}


