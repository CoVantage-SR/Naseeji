import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;
    final onSurfaceVar = Theme.of(context).colorScheme.onSurfaceVariant;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: primaryColor.withValues(alpha: 0.12),
            indicatorShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                  fontFamily: 'IBM Plex Sans Arabic',
                );
              }
              return TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: onSurfaceVar.withValues(alpha: 0.7),
                fontFamily: 'IBM Plex Sans Arabic',
              );
            }),
          ),
          child: NavigationBar(
            height: 65,
            backgroundColor: Colors.transparent,
            elevation: 0,
            selectedIndex: currentIndex,
            onDestinationSelected: (index) {
              if (index == currentIndex) return;
              switch (index) {
                case 0:
                  context.go('/home');
                  break;
                case 1:
                  context.go('/products');
                  break;
                case 2:
                  context.go('/orders');
                  break;
                case 3:
                  context.go('/messages');
                  break;
                case 4:
                  context.go('/profile');
                  break;
              }
            },
            destinations: [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: onSurfaceVar),
                selectedIcon: Icon(Icons.home_rounded, color: primaryColor),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined, color: onSurfaceVar),
                selectedIcon: Icon(Icons.category_rounded, color: primaryColor),
                label: 'المنتجات',
              ),
              NavigationDestination(
                icon: Icon(Icons.shopping_cart_outlined, color: onSurfaceVar),
                selectedIcon: Icon(Icons.shopping_cart_rounded, color: primaryColor),
                label: 'الطلبات',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline_rounded, color: onSurfaceVar),
                selectedIcon: Icon(Icons.chat_bubble_rounded, color: primaryColor),
                label: 'الدردشة',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded, color: onSurfaceVar),
                selectedIcon: Icon(Icons.person_rounded, color: primaryColor),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
