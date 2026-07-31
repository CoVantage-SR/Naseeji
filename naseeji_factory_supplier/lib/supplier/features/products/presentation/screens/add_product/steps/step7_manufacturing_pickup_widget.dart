import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_form_data.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/controllers/add_product_controller.dart';

class Step7ManufacturingPickupWidget extends ConsumerWidget {
  final ProductFormData formData;

  const Step7ManufacturingPickupWidget({super.key, required this.formData});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final controller = ref.read(addProductControllerProvider.notifier);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الطاقة الإنتاجية ومواعيد التجهيز',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'أدخل بيانات المخزون المتاح والقدرة الإنتاجية اليومية والشهرية لتأكيد الجاهزية للمشتريين.',
            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 16),

          // Stock & Ready Window Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.availableStock.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = int.tryParse(val);
                    if (p != null) controller.updateManufacturingLogistics(availableStock: p);
                  },
                  decoration: const InputDecoration(
                    labelText: 'الكمية المتوفرة بالمخزن *',
                    hintText: '5000',
                    prefixIcon: Icon(Icons.warehouse_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.readyForShipmentHours.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (val) {
                    final p = int.tryParse(val);
                    if (p != null) controller.updateManufacturingLogistics(readyForShipmentHours: p);
                  },
                  decoration: const InputDecoration(
                    labelText: 'جاهز للشحن خلال (ساعة) *',
                    hintText: '48',
                    prefixIcon: Icon(Icons.local_shipping_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Daily & Monthly Capacity Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.dailyCapacity,
                  onChanged: (val) => controller.updateManufacturingLogistics(dailyCapacity: val),
                  decoration: const InputDecoration(
                    labelText: 'الطاقة الإنتاجية اليومية',
                    hintText: '5,000 كجم / يوم',
                    prefixIcon: Icon(Icons.speed_rounded),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.monthlyCapacity,
                  onChanged: (val) => controller.updateManufacturingLogistics(monthlyCapacity: val),
                  decoration: const InputDecoration(
                    labelText: 'الطاقة الإنتاجية الشهرية',
                    hintText: '150,000 كجم / شهر',
                    prefixIcon: Icon(Icons.calendar_month_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Lead Time & Prep Time Row
          Row(
            children: [
              Expanded(
                child: TextFormField(
                  initialValue: formData.manufacturingLeadTime,
                  onChanged: (val) => controller.updateManufacturingLogistics(manufacturingLeadTime: val),
                  decoration: const InputDecoration(
                    labelText: 'مدة التصنيع',
                    hintText: '٧ أيام عمل',
                    prefixIcon: Icon(Icons.build_outlined),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: TextFormField(
                  initialValue: formData.preparationTime,
                  onChanged: (val) => controller.updateManufacturingLogistics(preparationTime: val),
                  decoration: const InputDecoration(
                    labelText: 'مدة التجهيز والتعبئة',
                    hintText: '٢٤ ساعة',
                    prefixIcon: Icon(Icons.inventory_2_outlined),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Pickup Location
          TextFormField(
            initialValue: formData.pickupLocation,
            onChanged: (val) => controller.updateManufacturingLogistics(pickupLocation: val),
            decoration: const InputDecoration(
              labelText: 'عنوان ومكان استلام الشحنة (المصنع/المخزن) *',
              hintText: 'مثال: مخزن المحلة الكبرى - المنطقة الصناعية الأولى - المحلة',
              prefixIcon: Icon(Icons.location_on_outlined),
            ),
          ),
        ],
      ),
    );
  }
}
