import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/features/products/domain/entities/product_model.dart';
import 'package:naseeji_supplier/features/products/presentation/controllers/products_controller.dart';

class ProductQuickActionsBarWidget extends ConsumerWidget {
  final ProductModel product;

  const ProductQuickActionsBarWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isPublished = product.status == ProductStatus.published;

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
              Icon(Icons.bolt_rounded, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'الإجراءات السريعة على المنتج',
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

          // Action Grid Buttons
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
            children: [
              // 1. Edit Product
              _buildActionButton(
                context,
                title: 'تعديل البيانات',
                icon: Icons.edit_outlined,
                color: colorScheme.primary,
                onTap: () => context.push('/add-product'),
              ),

              // 2. Pause / Activate Product
              _buildActionButton(
                context,
                title: isPublished ? 'إيقاف مؤقت' : 'تفعيل ونشر',
                icon: isPublished ? Icons.pause_circle_outline_rounded : Icons.play_circle_outline_rounded,
                color: isPublished ? Colors.orange.shade800 : Colors.green.shade800,
                onTap: () {
                  ref.read(productsControllerProvider.notifier).toggleProductStatus(
                        product.id,
                        isPublished ? ProductStatus.hidden : ProductStatus.published,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم تغيير حالة المنتج إلى ${isPublished ? 'مخفي' : 'منشور'}')),
                  );
                },
              ),

              // 3. Hide Product
              _buildActionButton(
                context,
                title: 'إخفاء عن المشتريين',
                icon: Icons.visibility_off_outlined,
                color: colorScheme.outline,
                onTap: () {
                  ref.read(productsControllerProvider.notifier).toggleProductStatus(
                        product.id,
                        ProductStatus.hidden,
                      );
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم إخفاء المنتج')),
                  );
                },
              ),

              // 4. Duplicate Product
              _buildActionButton(
                context,
                title: 'نسخ المنتج',
                icon: Icons.content_copy_rounded,
                color: const Color(0xFF673AB7),
                onTap: () {
                  ref.read(productsControllerProvider.notifier).duplicateProduct(product.id);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('تم نسخ المنتج "${product.name}" كمسودة جديدة')),
                  );
                },
              ),

              // 5. Share inside Network
              _buildActionButton(
                context,
                title: 'مشاركة بالشبكة',
                icon: Icons.share_outlined,
                color: const Color(0xFF006B5F),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('تم نسخ رابط المنتج لمشاركته مع العملاء')),
                  );
                },
              ),

              // 6. Create Sponsored Ad
              _buildActionButton(
                context,
                title: 'إنشاء إعلان ممول',
                icon: Icons.campaign_outlined,
                color: Colors.orange.shade900,
                onTap: () => context.push('/subscription/addons'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.25)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
