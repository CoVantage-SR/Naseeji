import 'package:flutter/material.dart';

class FactoryFilterBottomSheet extends StatefulWidget {
  const FactoryFilterBottomSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const FactoryFilterBottomSheet(),
    );
  }

  @override
  State<FactoryFilterBottomSheet> createState() => _FactoryFilterBottomSheetState();
}

class _FactoryFilterBottomSheetState extends State<FactoryFilterBottomSheet> {
  String _selectedCategory = 'الكل';
  RangeValues _priceRange = const RangeValues(50, 500);
  String _selectedStatus = 'الكل';

  final List<String> _categories = ['الكل', 'أقمشة قطنية', 'خيوط بوليستر', 'تريكو', 'مستلزمات خياطة'];
  final List<String> _statuses = ['الكل', 'جديد', 'قيد التفاوض', 'في الإنتاج', 'مكتمل'];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      decoration: BoxDecoration(
        color: theme.scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: theme.dividerColor.withValues(alpha: 0.4),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تصفية النتائج',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.close_rounded),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            'الفئة',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _categories.map((cat) {
              final isSelected = _selectedCategory == cat;
              return ChoiceChip(
                label: Text(cat),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedCategory = cat);
                },
                selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'الحالة',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: _statuses.map((status) {
              final isSelected = _selectedStatus == status;
              return ChoiceChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) setState(() => _selectedStatus = status);
                },
                selectedColor: colorScheme.primary.withValues(alpha: 0.15),
                labelStyle: TextStyle(
                  color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Text(
            'السعر (ج.م): ${_priceRange.start.round()} - ${_priceRange.end.round()}',
            style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          RangeSlider(
            values: _priceRange,
            min: 0,
            max: 1000,
            divisions: 20,
            activeColor: colorScheme.primary,
            onChanged: (values) => setState(() => _priceRange = values),
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    setState(() {
                      _selectedCategory = 'الكل';
                      _selectedStatus = 'الكل';
                      _priceRange = const RangeValues(50, 500);
                    });
                  },
                  child: const Text('إعادة ضبط'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('تطبيق التصفية'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
