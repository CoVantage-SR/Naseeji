import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/product_model.dart';
import '../controllers/products_controller.dart';
import 'analytics_bottom_sheet.dart';

class QuickActionsWidget extends ConsumerWidget {
  final ProductModel product;

  const QuickActionsWidget({super.key, required this.product});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return PopupMenuButton<String>(
      icon: Icon(Icons.more_vert_rounded, size: 18, color: theme.colorScheme.onSurfaceVariant),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 150),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (action) => _handleAction(context, ref, action),
      itemBuilder: (context) => [
        _buildItem('edit', 'تعديل المنتج', Icons.edit_outlined, theme.colorScheme.onSurface),
        _buildItem('analytics', 'التحليلات والزيارات', Icons.bar_chart_rounded, theme.colorScheme.primary),
        _buildItem('stock', 'تحديث المخزون', Icons.inventory_outlined, Colors.indigo),
        if (product.status == ProductStatus.hidden)
          _buildItem('show', 'إظهار للمشترين', Icons.visibility_outlined, Colors.green)
        else
          _buildItem('hide', 'إخفاء المنتج', Icons.visibility_off_outlined, Colors.orange),
        _buildItem('duplicate', 'نسخ المنتج', Icons.copy_rounded, theme.colorScheme.onSurface),
        _buildItem('archive', 'أرشفة المنتج', Icons.archive_outlined, Colors.red),
      ],
    );
  }

  PopupMenuItem<String> _buildItem(String value, String text, IconData icon, Color color) {
    return PopupMenuItem<String>(
      value: value,
      height: 36,
      child: Row(
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 8),
          Text(text, style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }

  void _handleAction(BuildContext context, WidgetRef ref, String action) {
    final controller = ref.read(productsControllerProvider.notifier);

    switch (action) {
      case 'edit':
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('تعديل المنتج "${product.name}"...')),
        );
        break;
      case 'analytics':
        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          builder: (ctx) => AnalyticsBottomSheet(productId: product.id, productName: product.name),
        );
        break;
      case 'stock':
        _showStockDialog(context, controller);
        break;
      case 'hide':
        controller.updateStatus(product.id, ProductStatus.hidden);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم إخفاء المنتج عن المصنعين.')));
        break;
      case 'show':
        controller.updateStatus(product.id, ProductStatus.published);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم نشر وإظهار المنتج بنجاح!')));
        break;
      case 'duplicate':
        controller.duplicateProduct(product.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تكرار المنتج كمسودة جديدة.')));
        break;
      case 'archive':
        controller.archiveProduct(product.id);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم أرشفة المنتج.')));
        break;
    }
  }

  void _showStockDialog(BuildContext context, ProductsController controller) {
    final stockController = TextEditingController(text: '${product.availableStock}');
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: const Text('تحديث كمية المخزون المتاح', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
          content: TextField(
            controller: stockController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'الكمية المتاحة حالياً بالكمية/المتر',
              suffixText: 'وحدة',
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                final newStock = int.tryParse(stockController.text) ?? product.availableStock;
                controller.updateStock(product.id, newStock);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('تم تحديث المخزون المتاح بنجاح!')));
              },
              child: const Text('حفظ المخزون'),
            ),
          ],
        ),
      ),
    );
  }
}



