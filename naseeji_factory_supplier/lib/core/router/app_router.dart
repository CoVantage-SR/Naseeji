import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../authentication/presentation/choose_account_type/choose_account_type_screen.dart';
import '../../authentication/presentation/forgot_password/forgot_password_screen.dart';
import '../../authentication/presentation/login/login_screen.dart';
import '../../authentication/presentation/otp/otp_screen.dart';
import '../../authentication/presentation/register/register_screen.dart';
import '../../authentication/presentation/splash/splash_screen.dart';

import '../../factory/features/home/presentation/screens/home_screen.dart' as factory_home;
import '../../supplier/features/dashboard/presentation/screens/home/home_screen.dart' as supplier_home;
import '../../supplier/features/deals/presentation/screens/deals_dashboard_screen.dart';
import '../../supplier/features/messages/presentation/screens/messages_screen.dart';
import '../../supplier/features/products/presentation/screens/products_module_screen.dart';
import '../../supplier/features/profile/presentation/screens/supplier_profile/supplier_profile_screen.dart';

import '../../authentication/reset_password/reset_password_screen.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    routes: [
      // Auth routes
      GoRoute(
        path: '/',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/auth/login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/auth/register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/auth/otp',
        builder: (context, state) {
          final phone = state.extra as String? ?? '01000000000';
          return OtpScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/forgot-password',
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: '/auth/reset-password',
        builder: (context, state) {
          final phone = state.extra as String? ?? '01000000000';
          return ResetPasswordScreen(phone: phone);
        },
      ),
      GoRoute(
        path: '/auth/choose-account-type',
        builder: (context, state) => const ChooseAccountTypeScreen(),
      ),

      // Factory main routes
      GoRoute(
        path: '/factory/home',
        builder: (context, state) => const factory_home.HomeScreen(),
      ),

      // Supplier main routes
      GoRoute(
        path: '/supplier/dashboard',
        builder: (context, state) => const supplier_home.HomeScreen(),
      ),
      GoRoute(
        path: '/supplier/deals',
        builder: (context, state) => const DealsDashboardScreen(),
      ),
      GoRoute(
        path: '/supplier/messages',
        builder: (context, state) => const MessagesScreen(),
      ),
      GoRoute(
        path: '/supplier/products',
        builder: (context, state) => const ProductsModuleScreen(),
      ),
      GoRoute(
        path: '/supplier/profile',
        builder: (context, state) => const SupplierProfileScreen(),
      ),
    ],
  );
}


