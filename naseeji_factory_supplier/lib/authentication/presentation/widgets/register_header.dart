import 'package:flutter/material.dart';

class RegisterHeader extends StatelessWidget {
  final VoidCallback? onBack;
  final bool showBackButton;
  final String currentLanguage;
  final ValueChanged<String> onLanguageChanged;

  const RegisterHeader({
    super.key,
    this.onBack,
    this.showBackButton = true,
    required this.currentLanguage,
    required this.onLanguageChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Circular Back Button
        if (showBackButton && onBack != null)
          InkWell(
            onTap: onBack,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: isDark ? colorScheme.outline : const Color(0xFFE2E8F0),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.03),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                Icons.chevron_left_rounded,
                size: 20,
                color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
              ),
            ),
          )
        else
          const SizedBox.shrink(),

        // Language Switcher Badge
        PopupMenuButton<String>(
          onSelected: onLanguageChanged,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          itemBuilder: (context) => const [
            PopupMenuItem(value: 'العربية', child: Text('العربية')),
            PopupMenuItem(value: 'English', child: Text('English')),
          ],
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: isDark ? colorScheme.surfaceContainerHighest : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isDark ? colorScheme.outline : const Color(0xFFE2E8F0),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.03),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.language_rounded,
                  size: 16,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text(
                  currentLanguage,
                  style: theme.textTheme.bodySmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: isDark ? colorScheme.onSurface : const Color(0xFF334155),
                  ),
                ),
                const SizedBox(width: 4),
                Icon(
                  Icons.keyboard_arrow_down_rounded,
                  size: 16,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
