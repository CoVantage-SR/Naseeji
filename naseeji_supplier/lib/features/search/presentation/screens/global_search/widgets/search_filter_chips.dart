import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SearchFilterChips extends StatefulWidget {
  const SearchFilterChips({super.key});

  @override
  State<SearchFilterChips> createState() => _SearchFilterChipsState();
}

class _SearchFilterChipsState extends State<SearchFilterChips> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _filters = [
    {'title': 'الكل', 'icon': Icons.all_inclusive},
    {'title': 'المنتجات', 'icon': null},
    {'title': 'الطلبات', 'icon': null},
    {'title': 'العملاء', 'icon': null},
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      reverse: true, // Scroll from right to left in Arabic
      child: Row(
        children: List.generate(_filters.length, (index) {
          final isSelected = _selectedIndex == index;
          final filter = _filters[index];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedIndex = index;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(left: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0040E0) : const Color(0xFFF1F3FD),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (filter['icon'] != null) ...[
                    Icon(
                      filter['icon'] as IconData,
                      size: 14,
                      color: isSelected ? Colors.white : AppColors.outline,
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    filter['title'] as String,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? Colors.white : AppColors.outline,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
