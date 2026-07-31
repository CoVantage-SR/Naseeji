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
    final tabs = [
      {'key': null, 'label': 'الكل'},
      {'key': 'منشور', 'label': 'تم النشر'},
      {'key': 'مسودة', 'label': 'مسودة'},
      {'key': 'مرفوضة', 'label': 'مرفوضة'},
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          // Filter Button ("تصفية") on the Left
          InkWell(
            onTap: () {
              // Open filter modal or reset
              onStatusChanged(null);
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE5E7EB)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.tune_rounded,
                    size: 14,
                    color: Color(0xFF4B5563),
                  ),
                  SizedBox(width: 4),
                  Text(
                    'تصفية',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF374151),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Status Filter Tabs
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              reverse: true, // RTL alignment
              child: Row(
                children: tabs.map((tab) {
                  final key = tab['key'];
                  final label = tab['label']!;
                  final isSelected = selectedStatus == key;

                  return Padding(
                    padding: const EdgeInsets.only(left: 6),
                    child: InkWell(
                      onTap: () => onStatusChanged(key),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6),
                          borderRadius: BorderRadius.circular(10),
                          border: isSelected
                              ? Border.all(color: const Color(0xFFBFDBFE), width: 1)
                              : null,
                        ),
                        child: Text(
                          label,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                            color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF4B5563),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}



