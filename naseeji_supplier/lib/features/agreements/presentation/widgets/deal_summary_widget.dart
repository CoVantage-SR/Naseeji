import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class DealSummaryWidget extends StatelessWidget {
  final AgreementProduct product;

  const DealSummaryWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10,
          ),
        ],
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Row(
            children: [
              const Icon(Icons.inventory_2_outlined, color: AppColors.primary, size: 18),
              const SizedBox(width: 8),
              Text(
                'القسم الأول: ملخص الصفقة والمنتج',
                style: theme.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Product Image & Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  product.imageUrl,
                  width: 70,
                  height: 70,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: 70,
                    height: 70,
                    color: colorScheme.surfaceContainerHighest,
                    child: const Icon(Icons.inventory_2, color: Colors.grey),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'SKU: ${product.sku} • الفئة: ${product.category}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'بلد المنشأ: ${product.countryOfOrigin}',
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.outline,
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Pricing & Quantity Grid
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerLow,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildMetricTile(
                    context,
                    label: 'الكمية المطلوبة',
                    value: '${product.quantity} ${product.unit}',
                    icon: Icons.format_list_numbered,
                  ),
                ),
                Container(width: 1, height: 30, color: colorScheme.outlineVariant),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    label: 'سعر الوحدة',
                    value: '${product.unitPrice} ${product.currency}',
                    icon: Icons.sell_outlined,
                  ),
                ),
                Container(width: 1, height: 30, color: colorScheme.outlineVariant),
                Expanded(
                  child: _buildMetricTile(
                    context,
                    label: 'إجمالي الصفقة',
                    value: '${product.totalPrice} ${product.currency}',
                    icon: Icons.account_balance_wallet_outlined,
                    isPrimary: true,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Specifications & Packaging Details
          _buildInfoRow('المواصفات الفنية المعتمدة:', product.specifications),
          const SizedBox(height: 6),
          _buildInfoRow('تفاصيل التعبئة والتغليف:', product.packagingDetails),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String label,
    required String value,
    required IconData icon,
    bool isPrimary = false,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 12, color: isPrimary ? AppColors.primary : theme.colorScheme.outline),
              const SizedBox(width: 4),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                  fontSize: 9,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: TextAlign.center,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: isPrimary ? AppColors.primary : theme.colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.outline),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 10, height: 1.3),
        ),
      ],
    );
  }
}
