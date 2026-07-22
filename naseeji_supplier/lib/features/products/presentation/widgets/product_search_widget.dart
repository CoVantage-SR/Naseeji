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
    final theme = Theme.of(context);

    return Container(
      height: 38,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      child: TextField(
        controller: TextEditingController(text: query)..selection = TextSelection.collapsed(offset: query.length),
        onChanged: onChanged,
        style: const TextStyle(fontSize: 12),
        decoration: InputDecoration(
          hintText: 'ابحث باسم المنتج، كود SKU، أو الفئة...',
          hintStyle: TextStyle(
            fontSize: 10.5,
            color: theme.colorScheme.outline,
          ),
          prefixIcon: Icon(Icons.search, size: 16, color: theme.colorScheme.outline),
          suffixIcon: query.isNotEmpty
              ? GestureDetector(
                  onTap: onClear ?? () => onChanged(''),
                  child: Icon(Icons.clear, size: 14, color: theme.colorScheme.outline),
                )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 8),
        ),
      ),
    );
  }
}
