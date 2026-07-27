import 'package:flutter/material.dart';
import '../../domain/entities/marketplace_models.dart';

class RecommendedProducts extends StatelessWidget {
  final List<RecommendedProductItem> items;
  final ValueChanged<RecommendedProductItem> onItemTap;

  const RecommendedProducts({
    super.key,
    required this.items,
    required this.onItemTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Text(
            'مقترح لك',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        SizedBox(
          height: 140,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Container(
                width: 125,
                margin: const EdgeInsets.symmetric(horizontal: 4.0),
                child: InkWell(
                  onTap: () => onItemTap(item),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding: const EdgeInsets.all(8.0),
                    decoration: BoxDecoration(
                      color: theme.cardTheme.color ?? colorScheme.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: theme.dividerColor.withValues(alpha: 0.25),
                        width: 1,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Image Thumbnail Placeholder
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Container(
                            height: 60,
                            width: double.infinity,
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            child: Icon(
                              Icons.category_outlined,
                              size: 28,
                              color: colorScheme.primary.withValues(alpha: 0.4),
                            ),
                          ),
                        ),
                        const SizedBox(height: 6),

                        // Title
                        Text(
                          item.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),

                        // Price
                        Text(
                          '${item.price.toStringAsFixed(2)} ${item.priceUnit}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade700,
                            fontSize: 10,
                          ),
                        ),

                        // MOQ
                        Text(
                          'MOQ ${item.moq}',
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontSize: 9,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
