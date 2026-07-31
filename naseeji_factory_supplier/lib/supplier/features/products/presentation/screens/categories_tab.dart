import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';

class CategoriesTab extends StatefulWidget {
  const CategoriesTab({super.key});

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
  final List<Map<String, dynamic>> _categories = [
    {'id': 'c1', 'name': 'خيوط غزل', 'count': 45},
    {'id': 'c2', 'name': 'أقمشة قطنية', 'count': 82},
    {'id': 'c3', 'name': 'منسوجات مخلوطة', 'count': 27},
  ];

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: _categories.length,
          separatorBuilder: (_, __) => SizedBox(height: 10),
          itemBuilder: (context, index) {
            final cat = _categories[index];
            return Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  )
                ],
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Folder Icon
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primaryContainer.withValues(alpha: 0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.folder_open_outlined, color: AppColors.primary, size: 22),
                  ),
                  SizedBox(width: 14),
                  // Name and count
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          cat['name'],
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Theme.of(context).colorScheme.onSurface),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'عدد المنتجات: ${cat['count']}',
                          style: TextStyle(fontSize: 11, color: AppColors.outline),
                        ),
                      ],
                    ),
                  ),
                  // Actions buttons
                  IconButton(
                    icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.outline),
                    onPressed: () => _showAddEditDialog(context, category: cat),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                    onPressed: () => _confirmDelete(context, cat),
                  ),
                ],
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'categories_add_fab',
          onPressed: () => _showAddEditDialog(context),
          backgroundColor: const Color(0xFF0040E0),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.add),
          label: Text('إضافة تصنيف جديد', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
        ),
      ),
    );
  }

  void _showAddEditDialog(BuildContext context, {Map<String, dynamic>? category}) {
    final controller = TextEditingController(text: category?['name'] ?? '');
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text(category == null ? 'إضافة تصنيف جديد' : 'تعديل التصنيف', textAlign: TextAlign.right),
          content: TextField(
            controller: controller,
            autofocus: true,
            textAlign: TextAlign.right,
            decoration: const InputDecoration(
              hintText: 'اسم التصنيف (مثال: ألياف طبيعية)...',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              onPressed: () {
                final name = controller.text.trim();
                if (name.isNotEmpty) {
                  setState(() {
                    if (category == null) {
                      _categories.add({
                        'id': 'c_${DateTime.now().millisecondsSinceEpoch}',
                        'name': name,
                        'count': 0,
                      });
                    } else {
                      final idx = _categories.indexWhere((c) => c['id'] == category['id']);
                      if (idx != -1) {
                        _categories[idx]['name'] = name;
                      }
                    }
                  });
                  Navigator.pop(ctx);
                }
              },
              child: Text('حفظ'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, Map<String, dynamic> cat) {
    showDialog(
      context: context,
      builder: (ctx) => Directionality(
        textDirection: TextDirection.rtl,
        child: AlertDialog(
          title: Text('حذف التصنيف', textAlign: TextAlign.right),
          content: Text(
            'هل أنت متأكد من حذف تصنيف "${cat['name']}"؟ سيتم إلغاء تصنيف المنتجات المرتبطة به.',
            textAlign: TextAlign.right,
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('إلغاء')),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () {
                setState(() => _categories.removeWhere((c) => c['id'] == cat['id']));
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم حذف التصنيف بنجاح.')),
                );
              },
              child: Text('حذف', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
