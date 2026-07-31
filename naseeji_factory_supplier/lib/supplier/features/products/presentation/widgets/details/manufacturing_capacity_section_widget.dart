import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ManufacturingCapacitySectionWidget extends StatelessWidget {
  final ProductModel product;

  const ManufacturingCapacitySectionWidget({super.key, required this.product});

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
              Icon(Icons.precision_manufacturing_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'الطاقة الإنتاجية ومدة التجهيز',
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

          // Daily & Monthly Production Capacity
          Row(
            children: [
              Expanded(
                child: _buildCapacityBox(
                  context,
                  title: 'الطاقة الإنتاجية اليومية',
                  value: product.dailyCapacity,
                  icon: Icons.speed_rounded,
                  color: const Color(0xFF009688),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCapacityBox(
                  context,
                  title: 'الطاقة الإنتاجية الشهرية',
                  value: product.monthlyCapacity,
                  icon: Icons.calendar_month_outlined,
                  color: const Color(0xFF0040E0),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Lead Time, Prep Time & Readiness Window
          Row(
            children: [
              Expanded(
                child: _buildCapacityBox(
                  context,
                  title: 'مدة التصنيع',
                  value: product.manufacturingLeadTime,
                  icon: Icons.build_outlined,
                  color: const Color(0xFFE65100),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildCapacityBox(
                  context,
                  title: 'جاهز للشحن خلال',
                  value: '${product.readyForShipmentHours} ساعة',
                  icon: Icons.local_shipping_outlined,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCapacityBox(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 16, color: color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: color),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}


