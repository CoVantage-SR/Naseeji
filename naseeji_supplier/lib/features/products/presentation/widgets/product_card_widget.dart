import 'package:flutter/material.dart';
import '../../domain/entities/product_model.dart';
import 'product_status_badge_widget.dart';
import 'quick_actions_widget.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Product Image Thumbnail
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              product.mainImageUrl,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 58,
                height: 58,
                color: colorScheme.surfaceContainerLow,
                child: Icon(Icons.image_not_supported_outlined, size: 20, color: colorScheme.outline),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Main Info Column
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title + Status Badge Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        product.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.onSurface,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    ProductStatusBadgeWidget(status: product.status),
                  ],
                ),
                const SizedBox(height: 4),

                // Price + Stock Row
                Row(
                  children: [
                    Text(
                      '${product.startingPrice.toStringAsFixed(0)} ${product.currency}',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Icon(Icons.inventory_2_outlined, size: 12, color: colorScheme.outline),
                    const SizedBox(width: 2),
                    Text(
                      'المخزون: ${product.availableStock}',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: product.availableStock <= 0 ? Colors.red : colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Footer Row: Views, RFQs, Last Updated
                Row(
                  children: [
                    Icon(Icons.visibility_outlined, size: 11, color: colorScheme.outline),
                    const SizedBox(width: 2),
                    Text('${product.viewsCount}', style: TextStyle(fontSize: 9.5, color: colorScheme.outline)),
                    const SizedBox(width: 8),
                    Icon(Icons.assignment_outlined, size: 11, color: colorScheme.outline),
                    const SizedBox(width: 2),
                    Text('${product.rfqCount} RFQ', style: TextStyle(fontSize: 9.5, color: colorScheme.outline, fontWeight: FontWeight.bold)),
                    const Spacer(),
                    Text(
                      product.formattedLastUpdated,
                      style: TextStyle(fontSize: 9, color: colorScheme.outline, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Quick Actions Button
          QuickActionsWidget(product: product),
        ],
      ),
    );
  }
}
