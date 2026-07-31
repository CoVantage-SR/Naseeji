import 'package:flutter/material.dart';

class EmptyProductsWidget extends StatelessWidget {
  final String title;
  final String description;
  final VoidCallback? onAddProduct;

  const EmptyProductsWidget({
    super.key,
    this.title = 'لا توجد منتجات',
    this.description = 'لم نتمكن من العثور على منتجات تطابق البحث الحالي.',
    this.onAddProduct,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: Icon(Icons.inventory_2_outlined, size: 36, color: theme.colorScheme.primary),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: theme.colorScheme.onSurface),
            ),
            const SizedBox(height: 4),
            Text(
              description,
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 10.5, color: theme.colorScheme.outline, height: 1.3),
            ),
            if (onAddProduct != null) ...[
              const SizedBox(height: 14),
              ElevatedButton.icon(
                onPressed: onAddProduct,
                icon: const Icon(Icons.add_rounded, size: 14),
                label: const Text('إضافة منتج خامة جديد'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: Colors.white,
                  minimumSize: const Size(0, 36),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}


