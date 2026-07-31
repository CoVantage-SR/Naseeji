import 'package:flutter/material.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_model.dart';

class InventoryCard extends StatelessWidget {
  final ProductModel product;
  final ValueChanged<int>? onStockUpdated;

  const InventoryCard({
    super.key,
    required this.product,
    this.onStockUpdated,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final currentStock = product.availableStock;
    const reservedQuantity = 150; // Mock reserved quantity
    final availableForSale = (currentStock - reservedQuantity).clamp(0, 999999);
    const alertThreshold = 500;
    final isLowStock = availableForSale <= alertThreshold;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isLowStock
              ? (isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5))
              : (isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
          width: isLowStock ? 1.5 : 1,
        ),
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
          // Header Row with Title & Low Stock Badge if applicable
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: isLowStock
                          ? (isDark ? const Color(0xFF450A0A) : const Color(0xFFFEF2F2))
                          : (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF)),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.inventory_rounded,
                      size: 16,
                      color: isLowStock
                          ? (isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626))
                          : (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB)),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'إدارة المخزون والتوفر',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                    ),
                  ),
                ],
              ),

              if (isLowStock)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF7F1D1D) : const Color(0xFFFEE2E2),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: isDark ? const Color(0xFF991B1B) : const Color(0xFFFCA5A5)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.warning_amber_rounded, size: 12, color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626)),
                      const SizedBox(width: 3),
                      Text(
                        'مخزون منخفض',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFF87171) : const Color(0xFFDC2626),
                        ),
                      ),
                    ],
                  ),
                )
              else
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: isDark ? const Color(0xFF14532D) : const Color(0xFFDCFCE7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    'متوفر للشحن',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                    ),
                  ),
                ),
            ],
          ),

          const SizedBox(height: 14),

          // 4 Metric Columns (as in reference image & requirements)
          Row(
            children: [
              Expanded(
                child: _buildStockMetric(
                  context,
                  label: 'المخزون الحالي',
                  value: '$currentStock',
                  unit: product.unit,
                  color: isDark ? Colors.white : const Color(0xFF111827),
                ),
              ),
              Expanded(
                child: _buildStockMetric(
                  context,
                  label: 'الكمية المحجوزة',
                  value: '$reservedQuantity',
                  unit: product.unit,
                  color: isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C),
                ),
              ),
              Expanded(
                child: _buildStockMetric(
                  context,
                  label: 'المتاح للبيع',
                  value: '$availableForSale',
                  unit: product.unit,
                  color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                  isBold: true,
                ),
              ),
              Expanded(
                child: _buildStockMetric(
                  context,
                  label: 'حد التنبيه',
                  value: '$alertThreshold',
                  unit: product.unit,
                  color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Stock update quick trigger button
          SizedBox(
            width: double.infinity,
            height: 36,
            child: OutlinedButton.icon(
              onPressed: () => _showUpdateStockDialog(context),
              icon: const Icon(Icons.edit_note_rounded, size: 16),
              label: const Text('تحديث كمية المخزون', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold)),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: isDark ? const Color(0xFF3B82F6) : const Color(0xFFBFDBFE)),
                foregroundColor: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStockMetric(
    BuildContext context, {
    required String label,
    required String value,
    required String unit,
    required Color color,
    bool isBold = false,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 9.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: isBold ? 15 : 14,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              fontSize: 8.5,
              color: isDark ? const Color(0xFF64748B) : const Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  void _showUpdateStockDialog(BuildContext context) {
    final controller = TextEditingController(text: '${product.availableStock}');
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('تحديث كمية المخزون', textAlign: TextAlign.right, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('أدخل الكمية الجديدة المتاحة للمخزون:', style: TextStyle(fontSize: 13)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'الكمية (${product.unit})',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () {
              final newQty = int.tryParse(controller.text.trim());
              if (newQty != null && onStockUpdated != null) {
                onStockUpdated!(newQty);
              }
              Navigator.pop(ctx);
            },
            child: const Text('حفظ التعديل'),
          ),
        ],
      ),
    );
  }
}
