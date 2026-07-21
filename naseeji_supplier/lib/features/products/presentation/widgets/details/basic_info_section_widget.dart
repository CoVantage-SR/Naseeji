import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_model.dart';

class BasicInfoSectionWidget extends StatelessWidget {
  final ProductModel product;

  const BasicInfoSectionWidget({super.key, required this.product});

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
              Icon(Icons.info_outline_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'المعلومات الأساسية',
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

          // Product Name
          Text(
            product.name,
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 4),

          // SKU & Categories
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'كود: ${product.sku}',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: colorScheme.primary),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '${product.category} › ${product.subCategory}',
                style: TextStyle(fontSize: 12, color: colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Brand & Country of Origin
          Row(
            children: [
              Expanded(
                child: _buildDetailTile(
                  context,
                  label: 'بلد المنشأ',
                  value: product.countryOfOrigin,
                  icon: Icons.flag_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildDetailTile(
                  context,
                  label: 'العلامة التجارية',
                  value: product.brand,
                  icon: Icons.branding_watermark_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Short Description
          Text(
            'الوصف المختصر:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            product.shortDescription,
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant),
          ),
          const SizedBox(height: 10),

          // Full Description
          Text(
            'الوصف التفصيلي الكامل:',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface),
          ),
          const SizedBox(height: 2),
          Text(
            product.fullDescription,
            style: TextStyle(fontSize: 13, color: colorScheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailTile(BuildContext context, {required String label, required String value, required IconData icon}) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: colorScheme.primary),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                Text(value, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
