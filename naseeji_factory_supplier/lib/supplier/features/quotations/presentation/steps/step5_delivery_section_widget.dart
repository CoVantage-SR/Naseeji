import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/create_quotation_controller.dart';
import '../../domain/entities/create_quotation_form_data.dart';

class Step5DeliverySectionWidget extends ConsumerWidget {
  final CreateQuotationFormData formData;

  const Step5DeliverySectionWidget({super.key, required this.formData});

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
            'مكان الاستلام وملاحظات الشحن',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'حدد عنوان الاستلام بالمصنع أو المخزن مع توضيح الجاهزية بالساعات.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Platform Shipping Notice Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.local_shipping_outlined, color: Colors.blue.shade900, size: 24),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'تنبيه: يتم تنفيذ شحن واستلام الطلبيات حصرياً من خلال شركات الشحن المعتمدة والضامنة بمنصة نسيجي.',
                    style: TextStyle(fontSize: 11, color: Colors.blue.shade900, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Pickup Location
          TextFormField(
            initialValue: formData.pickupLocation,
            onChanged: (val) => controller.updateDeliveryDetails(pickupLocation: val),
            decoration: const InputDecoration(
              labelText: 'عنوان ومكان استلام الشحنة (المصنع/المخزن) *',
              hintText: 'مخزن المحلة الكبرى - المنطقة الصناعية الأولى',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
          const SizedBox(height: 14),

          // Ready for Pickup Hours
          TextFormField(
            initialValue: formData.readyForPickupHours.toString(),
            keyboardType: TextInputType.number,
            onChanged: (val) {
              final h = int.tryParse(val);
              if (h != null) controller.updateDeliveryDetails(readyForPickupHours: h);
            },
            decoration: const InputDecoration(
              labelText: 'جاهز للاستلام والتسليم خلال (ساعة) *',
              hintText: '48',
              prefixIcon: Icon(Icons.av_timer_rounded),
            ),
          ),
          const SizedBox(height: 14),

          // Delivery Special Notes
          TextFormField(
            initialValue: formData.deliveryNotes,
            onChanged: (val) => controller.updateDeliveryDetails(deliveryNotes: val),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'ملاحظات وتوجيهات التسليم الخاصة',
              hintText: 'مثال: يرجى التنسيق مع أمين المخزن قبل الشحن بساعتين...',
              prefixIcon: Icon(Icons.note_alt_outlined),
            ),
          ),
        ],
      ),
    );
  }
}



