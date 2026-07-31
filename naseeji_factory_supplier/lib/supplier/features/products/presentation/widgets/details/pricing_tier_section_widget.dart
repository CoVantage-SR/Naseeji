import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class PricingTierSectionWidget extends StatelessWidget {
  final ProductModel product;

  const PricingTierSectionWidget({super.key, required this.product});

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
              Icon(Icons.sell_outlined, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'جدول الأسعار والتخفيضات حسب الكمية',
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

          // MOQ & Price Range Summary Row
          Row(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('أقل كمية للطلب (MOQ)', style: TextStyle(fontSize: 10, color: colorScheme.outline)),
                      const SizedBox(height: 2),
                      Text('${product.moq} قطعة / كجم / متر', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary)),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.green.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('نطاق السعر', style: TextStyle(fontSize: 10, color: Colors.green.shade900)),
                      const SizedBox(height: 2),
                      Text(
                        '${product.minPrice.toStringAsFixed(0)} - ${product.maxPrice.toStringAsFixed(0)} ${product.currency}',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.green.shade800),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Tier Table Header
          Text('شرائح أسعار الجملة حسب الكمية المطلوبة:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: colorScheme.onSurface)),
          const SizedBox(height: 8),

          // Tier Table Rows
          ListView.separated(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: product.tieredPrices.length,
            separatorBuilder: (context, index) => const SizedBox(height: 6),
            itemBuilder: (context, index) {
              final tier = product.tieredPrices[index];
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.3)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.inventory_2_outlined, size: 16, color: colorScheme.primary),
                        const SizedBox(width: 8),
                        Text(
                          'ابتداءً من ${tier.minQuantity} وحدة:',
                          style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: colorScheme.onSurface),
                        ),
                      ],
                    ),
                    Text(
                      '${tier.pricePerUnit.toStringAsFixed(0)} ${product.currency} / وحدة',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: colorScheme.primary),
                    ),
                  ],
                ),
              );
            },
          ),

          if (product.discountText != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.local_offer_rounded, color: Colors.orange.shade900, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      product.discountText!,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.orange.shade900),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}


