import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';
import 'product_status_badge.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCardWidget({
    super.key,
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap ?? () => context.push('/products/details/${product.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Thumbnail Image & Badge
                Stack(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        product.mainImageUrl,
                        width: 90,
                        height: 90,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          width: 90,
                          height: 90,
                          color: colorScheme.primaryContainer.withValues(alpha: 0.2),
                          child: Icon(
                            Icons.inventory_2_outlined,
                            color: colorScheme.primary,
                            size: 32,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 4,
                      right: 4,
                      child: ProductStatusBadge(status: product.status),
                    ),
                  ],
                ),
                const SizedBox(width: 12),

                // Main Info Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Category Tag
                      Text(
                        product.category,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 2),

                      // Product Title
                      Text(
                        product.name,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                          fontSize: 14,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),

                      // Price & MOQ Row
                      Row(
                        children: [
                          Text(
                            'السعر يبدأ من: ',
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            '${product.startingPrice.toStringAsFixed(0)} ${product.currency}',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.primary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // MOQ & Stock
                      Row(
                        children: [
                          Text(
                            'أقل كمية (MOQ): ${product.moq} • ',
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            'المتوفر: ${product.availableStock}',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: product.availableStock > 0 ? Colors.green.shade800 : Colors.red.shade800,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 8),

                      // Bottom Metrics (Views & RFQs)
                      Row(
                        children: [
                          Row(
                            children: [
                              Icon(Icons.visibility_outlined, size: 13, color: colorScheme.outline),
                              const SizedBox(width: 3),
                              Text(
                                '${product.viewsCount} مشاهدة',
                                style: TextStyle(fontSize: 10, color: colorScheme.outline),
                              ),
                            ],
                          ),
                          const SizedBox(width: 14),
                          Row(
                            children: [
                              Icon(Icons.request_quote_outlined, size: 13, color: colorScheme.primary),
                              const SizedBox(width: 3),
                              Text(
                                '${product.rfqCount} طلب RFQ',
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.primary,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}



