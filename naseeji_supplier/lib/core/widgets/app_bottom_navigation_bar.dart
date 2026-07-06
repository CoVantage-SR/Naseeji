import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: currentIndex,
      backgroundColor: Colors.white,
      elevation: 8,
      indicatorColor: const Color(0xFF72F8E4).withValues(alpha: 0.6),
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
          icon: Icon(Icons.home_outlined, color: AppColors.onSurfaceVariant),
          selectedIcon: Icon(Icons.home, color: AppColors.secondary),
          label: 'الرئيسية',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.category_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.category, color: AppColors.secondary),
          label: 'المنتجات',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.shopping_cart_outlined,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.shopping_cart, color: AppColors.secondary),
          label: 'الطلبات',
        ),
        NavigationDestination(
          icon: Icon(
            Icons.chat_bubble_outline,
            color: AppColors.onSurfaceVariant,
          ),
          selectedIcon: Icon(Icons.chat_bubble, color: AppColors.secondary),
          label: 'الرسائل',
        ),
        NavigationDestination(
          icon: Icon(Icons.person_outline, color: AppColors.onSurfaceVariant),
          selectedIcon: Icon(Icons.person, color: AppColors.secondary),
          label: 'حسابي',
        ),
      ],
    );
  }
}
