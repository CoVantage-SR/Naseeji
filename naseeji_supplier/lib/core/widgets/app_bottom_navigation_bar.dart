import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class AppBottomNavigationBar extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigationBar({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 30,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            indicatorColor: const Color.fromARGB(
              255,
              5,
              0,
              107,
            ).withValues(alpha: 0.15),
            indicatorShape: const StadiumBorder(),
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.selected)) {
                return const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Color.fromARGB(255, 2, 0, 107),
                );
              }
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.outline,
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
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined, color: AppColors.outline),
                selectedIcon: Icon(
                  Icons.home,
                  color: Color.fromARGB(255, 11, 0, 107),
                ),
                label: 'الرئيسية',
              ),
              NavigationDestination(
                icon: Icon(Icons.category_outlined, color: AppColors.outline),
                selectedIcon: Icon(
                  Icons.category,
                  color: Color.fromARGB(255, 0, 0, 107),
                ),
                label: 'المنتجات',
              ),
              NavigationDestination(
                icon: Icon(
                  Icons.shopping_cart_outlined,
                  color: AppColors.outline,
                ),
                selectedIcon: Icon(
                  Icons.shopping_cart,
                  color: Color.fromARGB(255, 21, 0, 107),
                ),
                label: 'الطلبات',
              ),
              NavigationDestination(
                icon: Icon(Icons.chat_bubble_outline, color: AppColors.outline),
                selectedIcon: Icon(
                  Icons.chat_bubble,
                  color: Color.fromARGB(255, 0, 11, 107),
                ),
                label: 'الرسائل',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline, color: AppColors.outline),
                selectedIcon: Icon(
                  Icons.person,
                  color: Color.fromARGB(255, 23, 0, 107),
                ),
                label: 'حسابي',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
