import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ManageInventoryBottomSheet extends StatefulWidget {
  final ProductModel product;
  final Function(int newStock)? onStockUpdated;

  const ManageInventoryBottomSheet({
    super.key,
    required this.product,
    this.onStockUpdated,
  });

  static Future<void> show(
    BuildContext context, {
    required ProductModel product,
    Function(int newStock)? onStockUpdated,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ManageInventoryBottomSheet(
        product: product,
        onStockUpdated: onStockUpdated,
      ),
    );
  }

  @override
  State<ManageInventoryBottomSheet> createState() => _ManageInventoryBottomSheetState();
}

class _ManageInventoryBottomSheetState extends State<ManageInventoryBottomSheet> {
  late TextEditingController _stockController;
  late TextEditingController _moqController;
  late ProductStatus _status;

  @override
  void initState() {
    super.initState();
    _stockController = TextEditingController(text: widget.product.availableStock.toString());
    _moqController = TextEditingController(text: widget.product.moq.toString());
    _status = widget.product.status;
  }

  @override
  void dispose() {
    _stockController.dispose();
    _moqController.dispose();
    super.dispose();
  }

  void _adjustStock(int delta) {
    final current = int.tryParse(_stockController.text.trim()) ?? 0;
    final updated = (current + delta).clamp(0, 999999);
    setState(() {
      _stockController.text = updated.toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag Handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.inventory_2_outlined,
                  color: isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'إدارة المخزون والتوفر',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF111827),
                      ),
                    ),
                    Text(
                      'تحديث الكميات المتاحة والتوافر للمنتج',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded),
                style: IconButton.styleFrom(
                  backgroundColor: isDark ? const Color(0xFF334155) : const Color(0xFFF1F5F9),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Stock Stepper Field
          Text(
            'الكمية المتاحة حالياً بالمخزن (${widget.product.unit}):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              _buildStepButton(
                icon: Icons.remove_rounded,
                onTap: () => _adjustStock(-10),
                color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: TextFormField(
                  controller: _stockController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : const Color(0xFF111827),
                  ),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 10),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              _buildStepButton(
                icon: Icons.add_rounded,
                onTap: () => _adjustStock(10),
                color: const Color(0xFF4F46E5),
                isPrimary: true,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Minimum Order Quantity Field
          Text(
            'أقل كمية للطلب (MOQ):',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _moqController,
            keyboardType: TextInputType.number,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
            decoration: InputDecoration(
              suffixText: widget.product.unit,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),

          const SizedBox(height: 16),

          // Availability Status Selection
          Text(
            'حالة التوفر والمنتج:',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF374151),
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [ProductStatus.published, ProductStatus.outOfStock, ProductStatus.hidden].map((st) {
              final isSelected = _status == st;
              return ChoiceChip(
                label: Text(
                  st.titleAr,
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.white
                        : (isDark ? const Color(0xFFCBD5E1) : const Color(0xFF334155)),
                  ),
                ),
                selected: isSelected,
                selectedColor: const Color(0xFF4F46E5),
                backgroundColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF1F5F9),
                onSelected: (val) {
                  if (val) {
                    setState(() {
                      _status = st;
                    });
                  }
                },
              );
            }).toList(),
          ),

          const SizedBox(height: 24),

          // Submit Button
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: () {
                final newStock = int.tryParse(_stockController.text.trim()) ?? widget.product.availableStock;
                if (widget.onStockUpdated != null) {
                  widget.onStockUpdated!(newStock);
                }
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تم تحديث المخزون بنجاح إلى $newStock ${widget.product.unit}'),
                    behavior: SnackBarBehavior.floating,
                    backgroundColor: const Color(0xFF16A34A),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF4F46E5),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text(
                'حفظ التعديلات',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepButton({
    required IconData icon,
    required VoidCallback onTap,
    required Color color,
    bool isPrimary = false,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(
          icon,
          color: isPrimary ? Colors.white : const Color(0xFF64748B),
          size: 20,
        ),
      ),
    );
  }
}

