import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ProductPricingCard extends StatelessWidget {
  final ProductModel product;

  const ProductPricingCard({
    super.key,
    required this.product,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final hasTieredPrices = product.tieredPrices.isNotEmpty;
    final defaultTiers = [
      {'from': '500', 'to': '1,000', 'price': '${product.startingPrice} ${product.currency}'},
      {'from': '1,001', 'to': '5,000', 'price': '${(product.startingPrice * 0.92).toStringAsFixed(1)} ${product.currency}'},
      {'from': '5,001', 'to': 'فأكثر', 'price': '${(product.startingPrice * 0.85).toStringAsFixed(1)} ${product.currency}'},
    ];

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'التسعير والطاقة الإنتاجية',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'أسعار قابلة للتفاوض',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Core Grid Info
          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  context,
                  title: 'سعر الوحدة',
                  value: '${product.startingPrice} ${product.currency}',
                  subtitle: 'لكل ${product.unit}',
                  icon: Icons.payments_outlined,
                  highlight: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoTile(
                  context,
                  title: 'الحد الأدنى للطلب (MOQ)',
                  value: '${product.moq} ${product.unit}',
                  subtitle: 'حد أدنى للإنتاج',
                  icon: Icons.shopping_bag_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              Expanded(
                child: _buildInfoTile(
                  context,
                  title: 'الطاقة الإنتاجية',
                  value: product.dailyCapacity.isNotEmpty ? product.dailyCapacity : '5,000 متر / يوم',
                  subtitle: 'الشهرية: ${product.monthlyCapacity}',
                  icon: Icons.precision_manufacturing_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildInfoTile(
                  context,
                  title: 'مدة التجهيز',
                  value: product.manufacturingLeadTime.isNotEmpty ? product.manufacturingLeadTime : '7 أيام',
                  subtitle: 'الشحن في خلال ${product.readyForShipmentHours} ساعة',
                  icon: Icons.timer_outlined,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Quantity Tier Pricing Table Header
          Text(
            'خصومات الكميات (جدول الأسعار)',
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),
          const SizedBox(height: 8),

          // Tier Pricing Table
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
            ),
            child: Column(
              children: [
                // Table Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          'من (الكمية)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'إلى (الكمية)',
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: Text(
                          'السعر للوحدة',
                          textAlign: TextAlign.end,
                          style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 1, color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),

                // Table Rows
                if (hasTieredPrices)
                  ...product.tieredPrices.map(
                    (tier) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${tier.minQuantity} ${product.unit}',
                              style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white : const Color(0xFF111827)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              'فأكثر',
                              style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white : const Color(0xFF111827)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${tier.pricePerUnit} ${product.currency}',
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  ...defaultTiers.map(
                    (row) => Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9), width: 0.8),
                        ),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${row['from']} ${product.unit}',
                              style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white : const Color(0xFF111827)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              '${row['to']} ${product.unit}',
                              style: TextStyle(fontSize: 11.5, color: isDark ? Colors.white : const Color(0xFF111827)),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: Text(
                              row['price']!,
                              textAlign: TextAlign.end,
                              style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoTile(
    BuildContext context, {
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    bool highlight = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: highlight
            ? (isDark ? const Color(0xFF2D1B4E) : const Color(0xFFF3E8FF))
            : (isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: highlight
              ? (isDark ? const Color(0xFF581C87) : const Color(0xFFE9D5FF))
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 14,
                color: highlight
                    ? (isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA))
                    : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w600,
                    color: highlight
                        ? (isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA))
                        : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280)),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: highlight
                  ? (isDark ? Colors.white : const Color(0xFF6B21A8))
                  : (isDark ? Colors.white : const Color(0xFF111827)),
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 9.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }
}

