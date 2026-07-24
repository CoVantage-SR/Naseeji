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

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFE5E7EB),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: () => context.push('/products/details/${product.id}'),
          borderRadius: BorderRadius.circular(16),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Options menu button (Far Left in RTL layout)
                PopupMenuButton<String>(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(
                    Icons.more_vert_rounded,
                    color: Color(0xFF9CA3AF),
                    size: 20,
                  ),
                  onSelected: (val) {
                    if (val == 'details') {
                      context.push('/products/details/${product.id}');
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'details',
                      child: Text('عرض التفاصيل', style: TextStyle(fontSize: 12)),
                    ),
                    const PopupMenuItem(
                      value: 'edit',
                      child: Text('تعديل المنتج', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(width: 4),

                // 2. Middle Content Column
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Top Line: Title + Status Badge
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
                              style: const TextStyle(
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF111827),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Subtitle: SKU & MOQ
                      Text(
                        'SKU: ${product.sku}  •  حد أدنى: ${product.moq} ${product.unit}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6B7280),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // 4 Metric Chips Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildMetricItem(
                            icon: Icons.inventory_2_outlined,
                            iconColor: const Color(0xFFEA580C),
                            bgColor: const Color(0xFFFFF7ED),
                            value: _formatNumber(product.availableStock),
                            label: 'مخزون',
                          ),
                          _buildMetricItem(
                            icon: Icons.handshake_outlined,
                            iconColor: const Color(0xFF16A34A),
                            bgColor: const Color(0xFFF0FDF4),
                            value: _formatNumber(product.dealsCount),
                            label: 'صفقات',
                          ),
                          _buildMetricItem(
                            icon: Icons.article_outlined,
                            iconColor: const Color(0xFF9333EA),
                            bgColor: const Color(0xFFF3E8FF),
                            value: _formatNumber(product.rfqCount),
                            label: 'طلبات RFQ',
                          ),
                          _buildMetricItem(
                            icon: Icons.remove_red_eye_outlined,
                            iconColor: const Color(0xFF2563EB),
                            bgColor: const Color(0xFFEFF6FF),
                            value: _formatNumber(product.viewsCount),
                            label: 'مشاهدة',
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),

                // 3. Product Thumbnail Image (Right Side in RTL)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    product.mainImageUrl,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      width: 82,
                      height: 82,
                      color: colorScheme.surfaceContainerLow,
                      child: const Icon(
                        Icons.inventory_2_outlined,
                        size: 32,
                        color: Color(0xFF9CA3AF),
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
    String label;
    bool showDot = false;

    switch (status) {
      case ProductStatus.published:
        bg = const Color(0xFFDCFCE7);
        textColor = const Color(0xFF16A34A);
        label = 'تم النشر';
        showDot = true;
        break;
      case ProductStatus.draft:
        bg = const Color(0xFFFEF3C7);
        textColor = const Color(0xFFD97706);
        label = 'مسودة';
        showDot = false;
        break;
      default:
        bg = const Color(0xFFFEE2E2);
        textColor = const Color(0xFFDC2626);
        label = 'مرفوضة';
        showDot = false;
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 5,
              height: 5,
              decoration: BoxDecoration(
                color: textColor,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 10.5,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
    required String value,
    required String label,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: const TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
                height: 1.1,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 9.5,
                fontWeight: FontWeight.w500,
                color: Color(0xFF6B7280),
                height: 1.1,
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
        Container(
          width: 26,
          height: 26,
          decoration: BoxDecoration(
            color: bgColor,
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 13,
            color: iconColor,
          ),
        ),
      ],
    );
  }
}
