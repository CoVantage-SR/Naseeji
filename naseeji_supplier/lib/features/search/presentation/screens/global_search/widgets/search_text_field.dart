import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class SearchTextField extends StatelessWidget {
  final ValueChanged<String>? onChanged;

  const SearchTextField({super.key, this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary, width: 1.5),
      ),
      child: TextField(
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        onChanged: onChanged,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          hintText: 'ابحث عن منتجات، طلبات، عملاء...',
          hintStyle: const TextStyle(color: AppColors.outline, fontSize: 13),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          prefixIcon: const Icon(Icons.search, color: AppColors.primary),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                icon: const Icon(Icons.qr_code_scanner, color: AppColors.onSurfaceVariant, size: 20),
                onPressed: () {},
              ),
              IconButton(
                icon: const Icon(Icons.mic_none, color: AppColors.onSurfaceVariant, size: 20),
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
