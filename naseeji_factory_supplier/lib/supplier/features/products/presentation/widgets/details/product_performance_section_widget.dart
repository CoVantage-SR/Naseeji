import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ProductPerformanceSectionWidget extends StatelessWidget {
  final ProductModel product;

  const ProductPerformanceSectionWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final perf = product.performance;

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
              Icon(Icons.insights_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'مؤشرات أداء المنتج والمبيعات',
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

          // Total Revenue Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF2E7D32),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('إجمالي مبيعات هذا المنتج', style: TextStyle(fontSize: 11, color: Colors.white.withValues(alpha: 0.85))),
                    const SizedBox(height: 2),
                    Text(
                      '${perf.totalRevenue.toStringAsFixed(0)} ${product.currency}',
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ],
                ),
                const Icon(Icons.monetization_on_rounded, color: Colors.white, size: 28),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Performance Metrics Grid
          Row(
            children: [
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'المشاهدات',
                  value: '${perf.views}',
                  icon: Icons.visibility_outlined,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'طلبات RFQ',
                  value: '${perf.rfqRequests}',
                  icon: Icons.request_quote_outlined,
                  color: const Color(0xFF673AB7),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'عدد الصفقات',
                  value: '${perf.quotesSubmitted}',
                  icon: Icons.handshake_outlined,
                  color: const Color(0xFF006B5F),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'عدد الاتفاقات',
                  value: '${perf.agreementsCount}',
                  icon: Icons.description_outlined,
                  color: const Color(0xFFE65100),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'عدد المبيعات',
                  value: '${perf.completedOrders}',
                  icon: Icons.check_circle_outline_rounded,
                  color: const Color(0xFF2E7D32),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildPerfTile(
                  context,
                  title: 'معدل التحويل',
                  value: '${perf.conversionRatePercent.toStringAsFixed(1)}%',
                  icon: Icons.trending_up_rounded,
                  color: Colors.blue.shade800,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPerfTile(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



