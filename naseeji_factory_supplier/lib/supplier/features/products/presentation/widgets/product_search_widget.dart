import 'package:flutter/material.dart';

class ProductSearchWidget extends StatelessWidget {
  final String query;
  final ValueChanged<String> onChanged;
  final VoidCallback? onClear;

  const ProductSearchWidget({
    super.key,
    required this.query,
    required this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      height: 44,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: TextEditingController(text: query)..selection = TextSelection.collapsed(offset: query.length),
        onChanged: onChanged,
        style: TextStyle(fontSize: 13, color: isDark ? Colors.white : const Color(0xFF111827)),
        decoration: InputDecoration(
          hintText: 'ابحث عن منتج...',
          hintStyle: const TextStyle(
            fontSize: 13,
            color: Color(0xFF9CA3AF),
          ),
          suffixIcon: const Icon(
            Icons.search_rounded,
            size: 20,
            color: Color(0xFF6B7280),
          ),
          prefixIcon: query.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.clear_rounded, size: 16, color: Color(0xFF9CA3AF)),
                  onPressed: onClear ?? () => onChanged(''),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 11, horizontal: 12),
        ),
      ),
    );
  }
}



