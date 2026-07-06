import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: NavigationBarTheme(
        data: NavigationBarThemeData(
          indicatorColor: AppColors.secondary.withValues(alpha: 0.15),
          indicatorShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          labelTextStyle: WidgetStateProperty.resolveWith((states) {
            if (states.contains(WidgetState.selected)) {
              return const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.secondary);
            }
            return const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.outline);
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
      destinations: const [
        NavigationDestination(
          icon: Icon(Icons.home_outlined, color: AppColors.outline),
          selectedIcon: Icon(Icons.home, color: AppColors.secondary),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.category_outlined,
            color: AppColors.outline,
          ),
          selectedIcon: Icon(Icons.category, color: AppColors.secondary),
          label: 'المنتجات',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.outline,
          ),
          selectedIcon: Icon(Icons.shopping_cart, color: AppColors.secondary),
          label: 'الطلبات',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.outline,
          ),
          selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
          label: 'الرسائل',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppColors.outline),
          selectedIcon: Icon(Icons.person, color: AppColors.secondary),
          label: 'حسابي',
        ),
      ],
    ),
      ),
    );
  }
}
