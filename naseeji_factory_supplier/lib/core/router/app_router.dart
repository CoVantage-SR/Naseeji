import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../session/session_provider.dart';
import '../../authentication/choose_account_type/choose_account_type.dart';
import '../../authentication/complete_profile/complete_profile.dart';
import '../../authentication/terms_acceptance/terms_acceptance_screen.dart';
import '../../authentication/presentation/forgot_password/forgot_password_screen.dart';
import '../../shared/enums/user_role.dart';
import '../../authentication/presentation/login/login_screen.dart';
import '../../authentication/presentation/otp/otp_screen.dart';
import '../../authentication/presentation/register/register_screen.dart';
import '../../authentication/presentation/splash/splash_screen.dart';

import '../../factory/features/home/presentation/screens/home_screen.dart' as factory_home;
import '../../factory/features/account/presentation/screens/account_profile_screen.dart';
import '../../factory/features/account/presentation/screens/edit_profile_screen.dart';
import '../../factory/features/account/presentation/screens/factory_account_screen.dart';
import '../../factory/features/account/presentation/screens/general_settings_screen.dart';
import '../../factory/features/account/presentation/screens/notifications_settings_screen.dart';
import '../../factory/features/account/presentation/screens/appearance_screen.dart';
import '../../factory/features/account/presentation/screens/terms_screen.dart';
import '../../factory/features/account/presentation/screens/privacy_screen.dart';

import '../../supplier/features/dashboard/presentation/screens/home/home_screen.dart' as supplier_home;
import '../../supplier/features/deals/presentation/screens/deals_dashboard_screen.dart';
import '../../supplier/features/messages/presentation/screens/messages_screen.dart';
import '../../supplier/features/products/presentation/screens/products_module_screen.dart';
import '../../supplier/features/profile/presentation/screens/supplier_profile/supplier_profile_screen.dart';

import '../../authentication/reset_password/reset_password_screen.dart';

part 'app_router.g.dart';

final rootNavigatorKey = GlobalKey<NavigatorState>(debugLabel: 'rootNav');

class RouterNotifier extends ChangeNotifier {
  RouterNotifier(Ref ref) {
    ref.listen(sessionNotifierProvider, (_, __) {
      notifyListeners();
    });
  }
}

@riverpod
GoRouter appRouter(AppRouterRef ref) {
  final routerNotifier = RouterNotifier(ref);

  return GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: routerNotifier,
    errorBuilder: (context, state) => const LoginScreen(),
    redirect: (context, state) {
      final session = ref.read(sessionNotifierProvider);
      final isFactoryRoute = state.matchedLocation.startsWith('/factory') ||
          state.matchedLocation.startsWith('/account');
      final isSupplierRoute = state.matchedLocation.startsWith('/supplier');

      if (!session.isLoggedIn) {
        if (isFactoryRoute || isSupplierRoute) {
          return '/auth/login';
        }
      } else {
        final defaultDashboard = session.role == UserRole.supplier
            ? '/supplier/dashboard'
            : '/factory/home';

        if (state.matchedLocation == '/auth/login' ||
            state.matchedLocation == '/auth/register') {
          return defaultDashboard;
        }

        if (session.role == UserRole.factory && isSupplierRoute) {
          return '/factory/home';
        }

        if (session.role == UserRole.supplier && isFactoryRoute) {
          return '/supplier/dashboard';
        }
      }
      return null;
    },
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
        builder: (context, state) {
          final role = state.extra as UserRole?;
          return RegisterScreen(initialRole: role);
        },
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
        builder: (context, state) => const ChooseAccountScreen(),
      ),
      GoRoute(
        path: '/auth/complete-profile',
        builder: (context, state) {
          final role = state.extra as UserRole?;
          return CompleteProfileScreen(initialRole: role);
        },
      ),
      GoRoute(
        path: '/auth/terms-acceptance',
        builder: (context, state) {
          final role = state.extra as UserRole? ?? UserRole.factory;
          return TermsAcceptanceScreen(role: role);
        },
      ),

      // Factory main routes
      GoRoute(
        path: '/factory/home',
        builder: (context, state) => const factory_home.HomeScreen(),
      ),
      GoRoute(
        path: '/factory/account',
        builder: (context, state) => const FactoryAccountScreen(),
      ),
      GoRoute(
        path: '/account/profile',
        builder: (context, state) => const AccountProfileScreen(),
      ),
      GoRoute(
        path: '/account/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/account/settings',
        builder: (context, state) => const GeneralSettingsScreen(),
      ),
      GoRoute(
        path: '/account/notifications',
        builder: (context, state) => const NotificationsSettingsScreen(),
      ),
      GoRoute(
        path: '/account/appearance',
        builder: (context, state) => const AppearanceScreen(),
      ),
      GoRoute(
        path: '/account/terms',
        builder: (context, state) => const TermsScreen(),
      ),
      GoRoute(
        path: '/account/privacy',
        builder: (context, state) => const PrivacyScreen(),
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


