import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:naseeji_factory/supplier/features/products/presentation/providers/products_providers.dart';

class ProductFilterBar extends ConsumerWidget {
  const ProductFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final statusFilter = ref.watch(productStatusFilterProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    const List<String> statuses = ['الكل', 'منشور', 'بانتظار المراجعة', 'مخفي', 'مسودة', 'غير متوفر'];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          onChanged: (val) {
            ref.read(productSearchQueryProvider.notifier).state = val;
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

        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: statuses.length,
            separatorBuilder: (context, index) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final status = statuses[index];
              final isSelected = (statusFilter == null && status == 'الكل') || (statusFilter == status);

              return ChoiceChip(
                label: Text(status),
                selected: isSelected,
                onSelected: (selected) {
                  if (selected) {
                    ref.read(productStatusFilterProvider.notifier).state = status == 'الكل' ? null : status;
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

