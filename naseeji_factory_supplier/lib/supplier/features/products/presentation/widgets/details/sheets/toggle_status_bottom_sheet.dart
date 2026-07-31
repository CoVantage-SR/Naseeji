import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/features/products/domain/entities/product_model.dart';

class ToggleStatusBottomSheet extends StatelessWidget {
  final ProductModel product;
  final VoidCallback onConfirm;

  const ToggleStatusBottomSheet({
    super.key,
    required this.product,
    required this.onConfirm,
  });

  static Future<void> show(
    BuildContext context, {
    required ProductModel product,
    required VoidCallback onConfirm,
  }) {
    return showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (ctx) => ToggleStatusBottomSheet(
        product: product,
        onConfirm: onConfirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isHidden = product.status == ProductStatus.hidden;

    final actionTitle = isHidden ? 'إعادة نشر المنتج' : 'إخفاء المنتج مؤقتاً';
    final actionSub = isHidden
        ? 'سيظهر المنتج مرة أخرى في متجر المورد ونتائج البحث لجميع المشتريين.'
        : 'سيتم إخفاء المنتج مؤقتاً من المتجر ولن يتمكن المشتريين من رؤيته حتى تعيد نشره.';

    final themeColor = isHidden ? const Color(0xFF16A34A) : const Color(0xFFEA580C);
    final themeBg = isHidden
        ? (isDark ? const Color(0xFF064E3B) : const Color(0xFFDCFCE7))
        : (isDark ? const Color(0xFF7C2D12) : const Color(0xFFFFEDD5));

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).padding.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Drag Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: isDark ? const Color(0xFF475569) : const Color(0xFFCBD5E1),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 20),

          // Icon
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: themeBg,
              shape: BoxShape.circle,
            ),
            child: Icon(
              isHidden ? Icons.visibility_rounded : Icons.visibility_off_rounded,
              color: themeColor,
              size: 32,
            ),
          ),

          const SizedBox(height: 16),

          // Title
          Text(
            actionTitle,
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : const Color(0xFF111827),
            ),
          ),

          const SizedBox(height: 8),

          // Subtitle Explanation
          Text(
            actionSub,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.5,
              height: 1.5,
              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF6B7280),
            ),
          ),

          const SizedBox(height: 24),

          // Actions
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text('إلغاء'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                    onConfirm();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    minimumSize: const Size.fromHeight(46),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(
                    isHidden ? 'تأكيد إعادة النشر' : 'تأكيد الإخفاء',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

