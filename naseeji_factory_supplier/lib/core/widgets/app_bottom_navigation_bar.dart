import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final StatefulNavigationShell? navigationShell;
  final int? currentIndex;

  const AppBottomNavigationBar({
    super.key,
    this.navigationShell,
    this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final activeIndex = navigationShell?.currentIndex ?? currentIndex ?? 0;

    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
            width: 0.5,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: colorScheme.primary.withValues(alpha: 0.12),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                );
              }
              return TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: activeIndex,
            onDestinationSelected: (index) {
              if (navigationShell != null) {
                navigationShell!.goBranch(
                  index,
                  initialLocation: index == navigationShell!.currentIndex,
                );
              } else {
                switch (index) {
                  case 0:
                    context.go('/supplier/dashboard');
                    break;
                  case 1:
                    context.go('/supplier/deals');
                    break;
                  case 2:
                    context.go('/supplier/messages');
                    break;
                  case 3:
                    context.go('/supplier/products');
                    break;
                  case 4:
                    context.go('/supplier/profile');
                    break;
                }
              }
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.dashboard_outlined),
                selectedIcon: Icon(Icons.dashboard_rounded),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Icon(Icons.handshake_outlined),
                selectedIcon: Icon(Icons.handshake_rounded),
                label: 'الصفقات',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded),
                selectedIcon: Icon(Icons.chat_bubble_rounded),
                label: 'المحادثات',
              ),
              NavigationDestination(
                icon: Icon(Icons.inventory_2_outlined),
                selectedIcon: Icon(Icons.inventory_2_rounded),
                label: 'المنتجات',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon: Icon(Icons.person_rounded),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}


