import 'package:flutter/material.dart';
import '../../domain/entities/product_model.dart';

class ProductsDashboardWidget extends StatelessWidget {
  final List<ProductModel> products;
  final Function(String?)? onSelectFilter;
  final String? activeFilter;

  const ProductsDashboardWidget({
    super.key,
    required this.products,
    this.onSelectFilter,
    this.activeFilter,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final totalCount = products.length;
    final publishedCount = products.where((p) => p.status == ProductStatus.published).length;
    final pendingCount = products.where((p) => p.status == ProductStatus.pendingReview).length;
    final draftsCount = products.where((p) => p.status == ProductStatus.draft).length;
    final outOfStockCount = products.where((p) => p.status == ProductStatus.outOfStock).length;
    final hiddenCount = products.where((p) => p.status == ProductStatus.hidden).length;

    final cardsData = [
      _DashboardMiniCardData(title: 'المنتجات', count: totalCount, icon: Icons.inventory_2_outlined, color: theme.colorScheme.primary, filterKey: null),
      _DashboardMiniCardData(title: 'منشورة', count: publishedCount, icon: Icons.check_circle_outline, color: const Color(0xFF16A34A), filterKey: 'منشور'),
      _DashboardMiniCardData(title: 'قيد المراجعة', count: pendingCount, icon: Icons.hourglass_empty_rounded, color: const Color(0xFFEAB308), filterKey: 'بانتظار المراجعة'),
      _DashboardMiniCardData(title: 'مسودة', count: draftsCount, icon: Icons.edit_note_outlined, color: const Color(0xFF6B7280), filterKey: 'مسودة'),
      _DashboardMiniCardData(title: 'غير متوفر', count: outOfStockCount, icon: Icons.remove_shopping_cart_outlined, color: const Color(0xFFF97316), filterKey: 'غير متوفر'),
      _DashboardMiniCardData(title: 'مخفية', count: hiddenCount, icon: Icons.visibility_off_outlined, color: const Color(0xFF9CA3AF), filterKey: 'مخفي'),
    ];

    return SizedBox(
      height: 62,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cardsData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final item = cardsData[index];
          final isSelected = activeFilter == item.filterKey;

          return InkWell(
            onTap: () {
              if (onSelectFilter != null) {
                onSelectFilter!(item.filterKey);
              }
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 100,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? item.color.withValues(alpha: 0.15)
                    : theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: isSelected
                      ? item.color
                      : theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: item.color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(item.icon, size: 14, color: item.color),
                  ),
                  const SizedBox(width: 6),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${item.count}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                            color: item.color,
                            height: 1.1,
                          ),
                        ),
                        Text(
                          item.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 9,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardMiniCardData {
  final String title;
  final int count;
  final IconData icon;
  final Color color;
  final String? filterKey;

  const _DashboardMiniCardData({
    required this.title,
    required this.count,
    required this.icon,
    required this.color,
    this.filterKey,
  });
}
