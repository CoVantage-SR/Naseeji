import 'package:flutter/material.dart';

class DemoExploreBanner extends StatelessWidget {
  final VoidCallback onDemoFactory;
  final VoidCallback onDemoSupplier;

  const DemoExploreBanner({
    super.key,
    required this.onDemoFactory,
    required this.onDemoSupplier,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? colorScheme.surfaceContainerHighest : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? colorScheme.outline.withValues(alpha: 0.3) : const Color(0xFFE2E8F0),
        ),
      ),
      child: Material(
        color: Colors.transparent,
        child: PopupMenuButton<String>(
          onSelected: (val) {
            if (val == 'factory') onDemoFactory();
            if (val == 'supplier') onDemoSupplier();
          },
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          itemBuilder: (context) => const [
            PopupMenuItem(
              value: 'factory',
              child: Row(
                children: [
                  Icon(Icons.factory_outlined, color: Color(0xFF10B981), size: 20),
                  SizedBox(width: 8),
                  Text('تجربة المنصة كمصنع'),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'supplier',
              child: Row(
                children: [
                  Icon(Icons.inventory_2_outlined, color: Color(0xFF2563EB), size: 20),
                  SizedBox(width: 8),
                  Text('تجربة المنصة كمورد'),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            child: Row(
              children: [
                Icon(
                  Icons.account_balance_outlined,
                  size: 20,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'استكشف المنصة كتجربة دون تسجيل',
                    style: theme.textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                      fontSize: 11.5,
                    ),
                  ),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'تجربة المنصة',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 11.5,
                      ),
                    ),
                    Icon(
                      Icons.chevron_left_rounded,
                      size: 18,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
