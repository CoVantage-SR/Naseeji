import 'package:flutter/material.dart';
import '../../domain/entities/account_type.dart';

class AccountTypeCard extends StatelessWidget {
  final AccountType type;
  final bool isSelected;
  final VoidCallback onTap;

  const AccountTypeCard({
    super.key,
    required this.type,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final title = type == AccountType.factory ? 'مصنع 🏭' : 'مورد 🧵';
    final description = type == AccountType.factory
        ? 'تصفح وطلب خامات النسيج وإدارة المشتروات'
        : 'عرض الأقمشة والخيوط واستقبال طلبات التسعير';

    final activeColor = colorScheme.primary;
    final borderColor = isSelected
        ? activeColor
        : (isDark ? colorScheme.outline.withValues(alpha: 0.3) : const Color(0xFFE2E8F0));

    final cardBg = isSelected
        ? (isDark ? activeColor.withValues(alpha: 0.15) : const Color(0xFFF0F7FF))
        : (isDark ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.5) : Colors.white);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: cardBg,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: borderColor,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: activeColor.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              )
            else
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: isSelected
                    ? activeColor.withValues(alpha: 0.2)
                    : (isDark ? colorScheme.surface : const Color(0xFFF1F5F9)),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  type == AccountType.factory ? '🏭' : '🧵',
                  style: const TextStyle(fontSize: 26),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: isSelected
                              ? activeColor
                              : (isDark ? colorScheme.onSurface : const Color(0xFF0F172A)),
                          fontSize: 17,
                        ),
                      ),
                      Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: isSelected
                                ? activeColor
                                : (isDark ? colorScheme.outline : const Color(0xFFCBD5E1)),
                            width: isSelected ? 6 : 2,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: isDark ? colorScheme.onSurfaceVariant : const Color(0xFF64748B),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
