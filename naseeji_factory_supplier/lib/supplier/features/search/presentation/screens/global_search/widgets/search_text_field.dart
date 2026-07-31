import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: isDark ? const Color(0xFF60A5FA) : AppColors.primary, width: 1.5),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'ابحث عن منتجات، طلبات، عملاء...',
          hintStyle: TextStyle(color: isDark ? const Color(0xFF94A3B8) : AppColors.outline, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: Icon(Icons.search, color: isDark ? const Color(0xFF60A5FA) : AppColors.primary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: Icon(Icons.qr_code_scanner, color: isDark ? const Color(0xFF94A3B8) : AppColors.onSurfaceVariant, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: Icon(Icons.mic_none, color: isDark ? const Color(0xFF94A3B8) : AppColors.onSurfaceVariant, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}