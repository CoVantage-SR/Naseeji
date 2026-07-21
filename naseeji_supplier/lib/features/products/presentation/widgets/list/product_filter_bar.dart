import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_supplier/features/products/presentation/providers/products_providers.dart';

class ProductFilterBar extends ConsumerWidget {
  const ProductFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filter = ref.watch(productFilterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const List<String> statuses = ['الكل', 'منشور', 'مخفي', 'مسودة', 'منتهي'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Search Input
        TextField(
          onChanged: (val) {
            ref.read(productFilterProvider.notifier).state =
                filter.copyWith(searchQuery: val);
          },
          decoration: InputDecoration(
            hintText: 'ابحث باسم المنتج أو كود SKU...',
            hintStyle: TextStyle(fontSize: 13, color: colorScheme.outline),
            prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
            contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            filled: true,
            fillColor: colorScheme.surface,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
            ),
          ),
        ),
        const SizedBox(height: 10),

        // Status Chips Horizontal Scroll
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: statuses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = statuses[index];
              final isSelected = filter.statusFilter == status;

              return ChoiceChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(productFilterProvider.notifier).state =
                        filter.copyWith(statusFilter: status);
                  }
                },
                selectedColor: colorScheme.primary,
                labelStyle: TextStyle(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                  color: isSelected ? colorScheme.onPrimary : colorScheme.onSurfaceVariant,
                ),
                backgroundColor: colorScheme.surface,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(
                    color: isSelected
                        ? colorScheme.primary
                        : colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
