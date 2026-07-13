import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../features/auth/presentation/screens/business_categories_screen.dart';
import '../../features/auth/presentation/screens/complete_registration_screen.dart';
import '../../features/auth/presentation/screens/factory_info_screen.dart';
import '../../features/auth/presentation/screens/factory_type_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/auth/presentation/screens/onboarding_screen.dart';
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rfq/presentation/screens/rfq_screen.dart';
import '../../features/settings/presentation/screens/settings_screen.dart';
import '../constants/app_icons.dart';

part 'app_router.g.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'root');

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    debugLogDiagnostics: true,
    routes: [
      // Splash
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      // Onboarding
      GoRoute(
        path: '/onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      // Login
      GoRoute(
        path: '/login',
        builder: (context, state) => const LoginScreen(),
      ),
      // Register
      GoRoute(
        path: '/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      // OTP
      GoRoute(
        path: '/otp',
        builder: (context, state) => const OtpScreen(),
      ),
      // Complete Registration
      GoRoute(
        path: '/complete-registration',
        builder: (context, state) => const CompleteRegistrationScreen(),
      ),
      // Factory Type Selection
      GoRoute(
        path: '/factory-type',
        builder: (context, state) => const FactoryTypeScreen(),
      ),
      // Business Categories Selection
      GoRoute(
        path: '/business-categories',
        builder: (context, state) => const BusinessCategoriesScreen(),
      ),
      // Factory Information Form
      GoRoute(
        path: '/factory-info',
        builder: (context, state) => const FactoryInfoScreen(),
      ),
      // Settings
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsScreen(),
      ),
      // Chat
      GoRoute(
        path: '/chat',
        builder: (context, state) => const ChatScreen(),
      ),

      // Bottom Navigation Stateful Shell
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return ScaffoldWithNestedNavigation(navigationShell: navigationShell);
        },
        branches: [
          // Tab 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Tab 1: Products
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                builder: (context, state) => const ProductsScreen(),
              ),
            ],
          ),
          // Tab 2: RFQ
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rfq',
                builder: (context, state) => const RfqScreen(),
              ),
            ],
          ),
          // Tab 3: Orders
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const OrdersScreen(),
              ),
            ],
          ),
          // Tab 4: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                builder: (context, state) => const ProfileScreen(),
              ),
            ],
          ),
        ],
      ),
    ],
  );
}

class ScaffoldWithNestedNavigation extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNestedNavigation({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(AppIcons.home),
            label: 'الرئيسية',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.products),
            label: 'المنتجات',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.rfq),
            label: 'عروض الأسعار',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.orders),
            label: 'الطلبات',
          ),
          BottomNavigationBarItem(
            icon: Icon(AppIcons.profile),
            label: 'حسابنا',
          ),
        ],
      ),
    );
  }
}
