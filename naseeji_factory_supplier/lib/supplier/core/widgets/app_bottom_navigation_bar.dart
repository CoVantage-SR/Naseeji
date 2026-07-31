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
            height: 62,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: activeIndex,
            onDestinationSelected: (index) {
              if (navigationShell != null) {
                navigationShell!.goBranch(
                  index,
                  initialLocation: index == navigationShell!.currentIndex,
                );
              } else {
                if (index == activeIndex) return;
                switch (index) {
                  case 0:
                    context.go('/home');
                    break;
                  case 1:
                    context.go('/products');
                    break;
                  case 2:
                    context.go('/deals');
                    break;
                  case 3:
                    context.go('/messages');
                    break;
                  case 4:
                    context.go('/profile');
                    break;
                }
              }
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: colorScheme.onSurfaceVariant),
                selectedIcon: Icon(Icons.home_rounded, color: colorScheme.primary),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined, color: colorScheme.onSurfaceVariant),
                selectedIcon: Icon(Icons.category_rounded, color: colorScheme.primary),
                label: 'المنتجات',
              ),
              NavigationDestination(
                icon: Icon(Icons.handshake_outlined, color: colorScheme.onSurfaceVariant),
                selectedIcon: Icon(Icons.handshake_rounded, color: colorScheme.primary),
                label: 'الصفقات',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded, color: colorScheme.onSurfaceVariant),
                selectedIcon: Icon(Icons.chat_bubble_rounded, color: colorScheme.primary),
                label: 'المحادثات',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded, color: colorScheme.onSurfaceVariant),
                selectedIcon: Icon(Icons.person_rounded, color: colorScheme.primary),
                label: 'الحساب',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

