import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/product_model.dart';

class ProductCardWidget extends StatelessWidget {
  final ProductModel product;

  const ProductCardWidget({super.key, required this.product});

  String _formatNumber(int number) {
    if (number >= 1000) {
      final str = number.toString();
      final result = StringBuffer();
      for (int i = 0; i < str.length; i++) {
        if (i > 0 && (str.length - i) % 3 == 0) {
          result.write(',');
        }
        result.write(str[i]);
      }
      return result.toString();
    }
    return number.toString();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), // Slate 100
          width: 1.2,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x080F172A), // Soft dark shadow
            blurRadius: 16,
            offset: Offset(0, 4),
          ),
          BoxShadow(
            color: Color(0x040F172A),
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/products/details/${product.id}'),
          borderRadius: BorderRadius.circular(16),
          splashColor: colorScheme.primary.withValues(alpha: 0.05),
          highlightColor: colorScheme.primary.withValues(alpha: 0.02),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Options Popup Menu (Far Left in RTL)
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: PopupMenuButton<String>(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 4,
                    constraints: const BoxConstraints(minWidth: 150),
                    icon: const Icon(
                      Icons.more_vert_rounded,
                      color: Color(0xFF64748B),
                      size: 18,
                    ),
                    onSelected: (val) {
                      if (val == 'details') {
                        context.push('/products/details/${product.id}');
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'details',
                        child: Row(
                          children: [
                            Icon(Icons.remove_red_eye_outlined, size: 16, color: Color(0xFF2563EB)),
                            SizedBox(width: 8),
                            Text('عرض التفاصيل', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'edit',
                        child: Row(
                          children: [
                            Icon(Icons.edit_outlined, size: 16, color: Color(0xFF059669)),
                            SizedBox(width: 8),
                            Text('تعديل المنتج', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                      const PopupMenuItem(
                        value: 'stock',
                        child: Row(
                          children: [
                            Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFFD97706)),
                            SizedBox(width: 8),
                            Text('تحديث المخزون', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 6),

                // 2. Main Details Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Row: Status Badge + Product Title
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Status Badge
                          _buildStatusBadge(product.status),
                          const SizedBox(width: 8),

                          // Product Name
                          Expanded(
                            child: Text(
                              product.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.w700,
                                color: isDark ? Colors.white : const Color(0xFF0F172A), // Slate 900
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),

                      // Subtitle Row: SKU & Minimum Order Quantity
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F5F9),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'SKU: ${product.sku}',
                              style: const TextStyle(
                                fontSize: 10.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF475569),
                              ),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            '•',
                            style: TextStyle(color: Color(0xFF94A3B8), fontSize: 10),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'حد أدنى: ${product.moq} ${product.unit}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // 4 Metrics Bar wrapped in a sleek container
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                        decoration: BoxDecoration(
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC), // Slate 900 / Slate 50
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9)),
                        ),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _buildMetricItem(
                                context: context,
                                icon: Icons.inventory_2_rounded,
                                iconColor: const Color(0xFFEA580C),
                                bgColor: const Color(0xFFFFEDD5),
                                value: _formatNumber(product.availableStock),
                                label: 'مخزون',
                              ),
                              const SizedBox(width: 10),
                              _buildMetricItem(
                                context: context,
                                icon: Icons.handshake_rounded,
                                iconColor: const Color(0xFF059669),
                                bgColor: const Color(0xFFD1FAE5),
                                value: _formatNumber(product.dealsCount),
                                label: 'صفقات',
                              ),
                              const SizedBox(width: 10),
                              _buildMetricItem(
                                context: context,
                                icon: Icons.description_rounded,
                                iconColor: const Color(0xFF7C3AED),
                                bgColor: const Color(0xFFEDE9FE),
                                value: _formatNumber(product.rfqCount),
                                label: 'طلبات RFQ',
                              ),
                              const SizedBox(width: 10),
                              _buildMetricItem(
                                context: context,
                                icon: Icons.visibility_rounded,
                                iconColor: const Color(0xFF0284C7),
                                bgColor: const Color(0xFFE0F9FF),
                                value: _formatNumber(product.viewsCount),
                                label: 'مشاهدة',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // 3. Product Thumbnail Image Container
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0A0F172A),
                        blurRadius: 8,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      product.mainImageUrl,
                      width: 84,
                      height: 84,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 84,
                        height: 84,
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.inventory_2_outlined,
                          size: 32,
                          color: Color(0xFF94A3B8),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(ProductStatus status) {
    Color bg;
    Color textColor;
    Color dotColor;
    String label;

    switch (status) {
      case ProductStatus.published:
        bg = const Color(0xFFECFDF5);
        textColor = const Color(0xFF059669);
        dotColor = const Color(0xFF10B981);
        label = 'تم النشر';
        break;
      case ProductStatus.draft:
        bg = const Color(0xFFFFFBEB);
        textColor = const Color(0xFFD97706);
        dotColor = const Color(0xFFF59E0B);
        label = 'مسودة';
        break;
      default:
        bg = const Color(0xFFFEF2F2);
        textColor = const Color(0xFFE11D48);
        dotColor = const Color(0xFFF43F5E);
        label = 'مرفوضة';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: textColor.withValues(alpha: 0.15), width: 0.8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: dotColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required BuildContext context,
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required String label,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: isDark ? iconColor.withValues(alpha: 0.2) : bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 12.5,
            color: isDark ? iconColor.withValues(alpha: 0.9) : iconColor,
          ),
        ),
        const SizedBox(width: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: isDark ? Colors.white : const Color(0xFF0F172A),
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w500,
                color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                height: 1.1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
