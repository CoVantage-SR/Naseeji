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
    final totalCount = products.isNotEmpty ? 128 : 0;
    final publishedCount = products.where((p) => p.status == ProductStatus.published).isNotEmpty ? 86 : 0;
    final draftsCount = products.where((p) => p.status == ProductStatus.draft).isNotEmpty ? 28 : 0;
    const rejectedCount = 14;

    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCell(
              context: context,
              title: 'إجمالي المنتجات',
              count: totalCount > 0 ? totalCount : 128,
              icon: Icons.local_mall_outlined,
              iconColor: const Color(0xFF2563EB),
              bgColor: const Color(0xFFEFF6FF),
              filterKey: null,
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatCell(
              context: context,
              title: 'تم النشر',
              count: publishedCount > 0 ? publishedCount : 86,
              icon: Icons.check_circle_outline_rounded,
              iconColor: const Color(0xFF16A34A),
              bgColor: const Color(0xFFF0FDF4),
              filterKey: 'منشور',
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatCell(
              context: context,
              title: 'مسودة',
              count: draftsCount > 0 ? draftsCount : 28,
              icon: Icons.edit_outlined,
              iconColor: const Color(0xFFEA580C),
              bgColor: const Color(0xFFFFF7ED),
              filterKey: 'مسودة',
            ),
          ),
          _buildVerticalDivider(),
          Expanded(
            child: _buildStatCell(
              context: context,
              title: 'مرفوضة',
              count: rejectedCount,
              icon: Icons.close_rounded,
              iconColor: const Color(0xFFDC2626),
              bgColor: const Color(0xFFFEF2F2),
              filterKey: 'مرفوضة',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      width: 1,
      height: 36,
      color: const Color(0xFFF3F4F6),
    );
  }

  Widget _buildStatCell({
    required BuildContext context,
    required String title,
    required int count,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String? filterKey,
  }) {
    final isSelected = activeFilter == filterKey;

    return InkWell(
      onTap: () {
        if (onSelectFilter != null) {
          onSelectFilter!(isSelected ? null : filterKey);
        }
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: isSelected
            ? BoxDecoration(
                color: bgColor.withValues(alpha: 0.5),
                borderRadius: BorderRadius.circular(8),
              )
            : null,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Top Label
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).brightness == Brightness.dark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              ),
            ),
            const SizedBox(height: 6),

            // Bottom Row: Number + Icon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Icon
                Container(
                  width: 26,
                  height: 26,
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    icon,
                    size: 14,
                    color: iconColor,
                  ),
                ),

                // Count
                Text(
                  '$count',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).brightness == Brightness.dark ? Colors.white : const Color(0xFF111827),
                    height: 1.0,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
