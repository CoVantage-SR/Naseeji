import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/factory_navigation_provider.dart';

class FactoryBottomNavigation extends ConsumerWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FactoryBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final navState = ref.watch(factoryNavigationProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final primaryColor = colorScheme.primary;
    final unselectedColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.7);

    final items = [
      _NavItemData(
        label: 'الرئيسية',
        selectedIcon: Icons.dashboard_rounded,
        unselectedIcon: Icons.dashboard_outlined,
      ),
      _NavItemData(
        label: 'السوق',
        selectedIcon: Icons.storefront_rounded,
        unselectedIcon: Icons.storefront_outlined,
      ),
      _NavItemData(
        label: 'الطلبات',
        selectedIcon: Icons.description_rounded,
        unselectedIcon: Icons.description_outlined,
        badgeCount: navState.rfqBadgeCount,
      ),
      _NavItemData(
        label: 'الصفقات',
        selectedIcon: Icons.handshake_rounded,
        unselectedIcon: Icons.handshake_outlined,
        badgeCount: navState.dealsBadgeCount,
      ),
      _NavItemData(
        label: 'الحساب',
        selectedIcon: Icons.person_rounded,
        unselectedIcon: Icons.person_outline_rounded,
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: theme.bottomNavigationBarTheme.backgroundColor ?? theme.cardTheme.color ?? colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
        border: Border(
          top: BorderSide(
            color: theme.dividerColor.withValues(alpha: 0.15),
            width: 1,
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 62,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(items.length, (index) {
              final item = items[index];
              final isSelected = index == currentIndex;

              return Expanded(
                child: InkWell(
                  onTap: () => onTap(index),
                  splashColor: primaryColor.withValues(alpha: 0.1),
                  highlightColor: Colors.transparent,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Icon with optional badge
                      Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Icon(
                            isSelected ? item.selectedIcon : item.unselectedIcon,
                            color: isSelected ? primaryColor : unselectedColor,
                            size: 24,
                          ),
                          if (item.badgeCount != null && item.badgeCount! > 0)
                            Positioned(
                              top: -4,
                              right: -8,
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                decoration: BoxDecoration(
                                  color: colorScheme.error,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 14,
                                ),
                                child: Text(
                                  '${item.badgeCount}',
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Label Text
                      Text(
                        item.label,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                          color: isSelected ? primaryColor : unselectedColor,
                          height: 1.1,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _NavItemData {
  final String label;
  final IconData selectedIcon;
  final IconData unselectedIcon;
  final int? badgeCount;

  _NavItemData({
    required this.label,
    required this.selectedIcon,
    required this.unselectedIcon,
    this.badgeCount,
  });
}


