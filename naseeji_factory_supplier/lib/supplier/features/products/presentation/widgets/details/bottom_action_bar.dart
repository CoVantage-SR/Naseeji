import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class BottomActionBar extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onManageInventory;
  final VoidCallback onToggleHideRepublish;
  final VoidCallback onViewInStore;
  final VoidCallback onShare;

  const BottomActionBar({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onManageInventory,
    required this.onToggleHideRepublish,
    required this.onViewInStore,
    required this.onShare,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHidden = product.status == ProductStatus.hidden;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        border: Border(top: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Row 1: Primary Actions (Matching reference image: عرض في المتجر & مشاركة المنتج)
            Row(
              children: [
                Expanded(
                  flex: 3,
                  child: SizedBox(
                    height: 44,
                    child: ElevatedButton.icon(
                      onPressed: onViewInStore,
                      icon: const Icon(Icons.storefront_rounded, size: 18, color: Colors.white),
                      label: const Text(
                        'عرض في المتجر',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        backgroundColor: const Color(0xFF4F46E5),
                        elevation: 0,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  flex: 2,
                  child: SizedBox(
                    height: 44,
                    child: OutlinedButton.icon(
                      onPressed: onShare,
                      icon: Icon(Icons.share_outlined, size: 16, color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA)),
                      label: Text(
                        'مشاركة المنتج',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isDark ? const Color(0xFFC084FC) : const Color(0xFF9333EA),
                        ),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: isDark ? const Color(0xFF581C87) : const Color(0xFFE9D5FF)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 8),

            // Row 2: Secondary Operational Actions (تعديل المنتج | إدارة المخزون | إخفاء / إعادة النشر)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: onEdit,
                      icon: const Icon(Icons.edit_outlined, size: 14),
                      label: const Text('تعديل المنتج', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                        foregroundColor: isDark ? Colors.white : const Color(0xFF111827),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: onManageInventory,
                      icon: const Icon(Icons.inventory_2_outlined, size: 14),
                      label: const Text('إدارة المخزون', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold)),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
                        foregroundColor: isDark ? Colors.white : const Color(0xFF111827),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: SizedBox(
                    height: 38,
                    child: OutlinedButton.icon(
                      onPressed: onToggleHideRepublish,
                      icon: Icon(
                        isHidden ? Icons.visibility_rounded : Icons.visibility_off_outlined,
                        size: 14,
                      ),
                      label: Text(
                        isHidden ? 'إعادة النشر' : 'إخفاء المنتج',
                        style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                      ),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        side: BorderSide(
                          color: isHidden
                              ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
                              : (isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C)),
                        ),
                        foregroundColor: isHidden
                            ? (isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A))
                            : (isDark ? const Color(0xFFFB923C) : const Color(0xFFEA580C)),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
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

