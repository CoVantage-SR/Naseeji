// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/deals/domain/entities/deal_model.dart';
import 'package:naseeji_supplier/features/deals/presentation/controllers/deals_controller.dart';

class DeliveryWidget extends ConsumerStatefulWidget {
  final DealModel deal;

  const DeliveryWidget({super.key, required this.deal});

  @override
  ConsumerState<DeliveryWidget> createState() => _DeliveryWidgetState();
}

class _DeliveryWidgetState extends ConsumerState<DeliveryWidget> {
  late DeliveryMethod _method;
  late final TextEditingController _nameCtrl;
  late final TextEditingController _phoneCtrl;
  late final TextEditingController _notesCtrl;

  @override
  void initState() {
    super.initState();
    final del = widget.deal.delivery;
    _method = del?.method ?? DeliveryMethod.supplierDelivery;
    _nameCtrl = TextEditingController(text: del?.responsiblePersonName ?? 'أحمد إبراهيم (سائق الشحنة)');
    _phoneCtrl = TextEditingController(text: del?.responsiblePersonPhone ?? '01000000000');
    _notesCtrl = TextEditingController(text: del?.notes ?? '');
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _phoneCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final del = widget.deal.delivery;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (del != null) ...[
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.teal.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.teal.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_shipping_outlined, color: Colors.teal, size: 18),
                      const SizedBox(width: 6),
                      Text(
                        'تفاصيل وطريقة التسليم الحالية',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.teal.shade900),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('الطريقة: ${del.method.titleAr}', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                  Text('مسؤول التسليم/السائق: ${del.responsiblePersonName}', style: const TextStyle(fontSize: 10)),
                  Text('تاريخ الاستلام التقديري: ${del.estimatedDeliveryDate.day}/${del.estimatedDeliveryDate.month}/${del.estimatedDeliveryDate.year}', style: const TextStyle(fontSize: 10)),
                ],
              ),
            ),
            const SizedBox(height: 14),
          ],

          // Form to set delivery method
          Container(
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
                  children: [
                    Icon(Icons.inventory_2_outlined, size: 16, color: colorScheme.primary),
                    const SizedBox(width: 6),
                    Text(
                      'تحديد طريقة ومسؤول التسليم (بدون شركة شحن)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
                const SizedBox(height: 10),

                // Method 1: Supplier Delivery
                RadioListTile<DeliveryMethod>(
                  value: DeliveryMethod.supplierDelivery,
                  groupValue: _method,
                  onChanged: (val) {
                    if (val != null) setState(() => _method = val);
                  },
                  title: const Text('المورد يقوم بالتوصيل لمقر/مخزن المصنع', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  subtitle: const Text('سيقوم أسطول المورد أو السائق التابع بالتوصيل لموقع المصنع مباشرة.', style: TextStyle(fontSize: 9.5)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),

                // Method 2: Factory Pickup
                RadioListTile<DeliveryMethod>(
                  value: DeliveryMethod.factoryPickup,
                  groupValue: _method,
                  onChanged: (val) {
                    if (val != null) setState(() => _method = val);
                  },
                  title: const Text('المصنع يستلم من مخزن المورد مباشرة', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  subtitle: const Text('يقوم مندوب أو سيارة المصنع بالحضور لم مخزن المنشأة للتسلم والتوقيع.', style: TextStyle(fontSize: 9.5)),
                  contentPadding: EdgeInsets.zero,
                  dense: true,
                ),
                const SizedBox(height: 10),

                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(labelText: 'اسم مسؤول التسليم / السائق', contentPadding: EdgeInsets.all(8)),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _phoneCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(labelText: 'رقم هاتف مسؤول التسليم للتنسيق', contentPadding: EdgeInsets.all(8)),
                ),
                const SizedBox(height: 8),

                TextField(
                  controller: _notesCtrl,
                  maxLines: 2,
                  style: const TextStyle(fontSize: 11),
                  decoration: const InputDecoration(labelText: 'ملاحظات العنوان والتسليم', contentPadding: EdgeInsets.all(8)),
                ),
                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    onPressed: _saveDelivery,
                    icon: const Icon(Icons.check_circle_outline, size: 16),
                    label: const Text('اعتماد طريقة التسليم وبدء الشحن'),
                    style: ElevatedButton.styleFrom(backgroundColor: colorScheme.primary, foregroundColor: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _saveDelivery() async {
    final success = await ref.read(dealsControllerProvider.notifier).setDeliveryDetails(
          dealId: widget.deal.id,
          method: _method,
          estimatedDeliveryDate: DateTime.now().add(const Duration(days: 2)),
          responsiblePersonName: _nameCtrl.text,
          responsiblePersonPhone: _phoneCtrl.text,
          notes: _notesCtrl.text,
        );

    if (mounted && success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('تم اعتماد طريقة التسليم وتحديث الحالة إلى "قيد التسليم" 🚛'), backgroundColor: Colors.teal),
      );
    }
  }
}
