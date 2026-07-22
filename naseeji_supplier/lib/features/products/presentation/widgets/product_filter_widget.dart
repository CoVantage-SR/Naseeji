import 'package:flutter/material.dart';

class ProductFilterWidget extends StatelessWidget {
  final String? selectedStatus;
  final String? selectedCategory;
  final String selectedSort;
  final ValueChanged<String?> onStatusChanged;
  final ValueChanged<String?> onCategoryChanged;
  final ValueChanged<String> onSortChanged;

  const ProductFilterWidget({
    super.key,
    required this.selectedStatus,
    required this.selectedCategory,
    required this.selectedSort,
    required this.onStatusChanged,
    required this.onCategoryChanged,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Sort Dropdown Chip
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: theme.colorScheme.outlineVariant),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: selectedSort,
                icon: const Icon(Icons.sort_rounded, size: 14),
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                items: const [
                  DropdownMenuItem(value: 'updated', child: Text('آخر تعديل')),
                  DropdownMenuItem(value: 'views', child: Text('الأكثر مشاهدة')),
                  DropdownMenuItem(value: 'stock', child: Text('الأعلى مخزوناً')),
                ],
                onChanged: (val) {
                  if (val != null) onSortChanged(val);
                },
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Category Dropdown Chip
          Container(
            height: 30,
            padding: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: selectedCategory != null ? theme.colorScheme.primaryContainer.withValues(alpha: 0.3) : theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: selectedCategory != null ? theme.colorScheme.primary : theme.colorScheme.outlineVariant,
              ),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String?>(
                value: selectedCategory,
                hint: Text('الفئة', style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurfaceVariant)),
                icon: const Icon(Icons.keyboard_arrow_down_rounded, size: 14),
                style: TextStyle(fontSize: 10, color: theme.colorScheme.onSurface, fontWeight: FontWeight.bold),
                items: const [
                  DropdownMenuItem(value: null, child: Text('جميع الفئات')),
                  DropdownMenuItem(value: 'خيوط ونُسُج', child: Text('خيوط ونُسُج')),
                  DropdownMenuItem(value: 'أقمشة ملابس', child: Text('أقمشة ملابس')),
                  DropdownMenuItem(value: 'أقمشة راقية', child: Text('أقمشة راقية')),
                ],
                onChanged: onCategoryChanged,
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Status Reset Chip if active
          if (selectedStatus != null || selectedCategory != null)
            GestureDetector(
              onTap: () {
                onStatusChanged(null);
                onCategoryChanged(null);
              },
              child: Container(
                height: 30,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.filter_alt_off_outlined, size: 12, color: Colors.red),
                    SizedBox(width: 4),
                    Text('إلغاء الفلاتر', style: TextStyle(fontSize: 9, color: Colors.red, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}
