import 'package:flutter/material.dart';
import '../../domain/entities/product_model.dart';

class PackagingPickupSectionWidget extends StatelessWidget {
  final ProductModel product;

  const PackagingPickupSectionWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.inventory_2_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'التغليف ومكان استلام الشحنة',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4), height: 1),
          const SizedBox(height: 12),

          // Packaging Details
          Text('طريقة التغليف:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 2),
          Text(product.packagingMethod, style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant)),
          const SizedBox(height: 10),

          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('وزن الكرتونة / الثوب', style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                      const SizedBox(height: 2),
                      Text('${product.cartonWeightKg} كجم', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('عدد الوحدات بالكرتونة', style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                      const SizedBox(height: 2),
                      Text('${product.unitsPerBox} وحدة', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Pickup Location
          Text('مكان تسليم الشحنة (المخزن / المصنع):', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(Icons.location_on_outlined, color: colorScheme.primary, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  product.pickupLocation,
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Logistics Note Prompt Requirement
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: colorScheme.primary.withValues(alpha: 0.2)),
            ),
            child: Row(
              children: [
                Icon(Icons.local_shipping_rounded, color: colorScheme.primary, size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'ملاحظة: لا يتم حساب تكلفة الشحن هنا. حساب وتنسيق الشحن يتم بالكامل تلقائياً من خلال تطبيق شركة الشحن المرتبط بالمنصة.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: colorScheme.primary, height: 1.3),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
