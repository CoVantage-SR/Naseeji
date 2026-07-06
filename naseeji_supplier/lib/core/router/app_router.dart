import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'session_router_observer.dart';
import '../../features/auth/presentation/screens/splash/splash_screen.dart';
import '../../features/auth/presentation/screens/onboarding/onboarding_screen.dart';
import '../../features/auth/presentation/screens/choose_supplier_type/choose_supplier_type_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/create_account/create_account_screen.dart';
import '../../features/auth/presentation/screens/otp_verification/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/supplier_registration/supplier_registration_screen.dart';
import '../../features/dashboard/presentation/screens/home/home_screen.dart';
import '../../features/dashboard/presentation/screens/analytics/analytics_screen.dart';
import '../../features/notifications/presentation/screens/notifications_center/notifications_center_screen.dart';
import '../../features/search/presentation/screens/global_search/global_search_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/supplier_profile_screen.dart';
import '../../features/products/presentation/screens/add_product/add_product_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/rfq_details_screen.dart';
import '../../features/orders/presentation/screens/create_offer_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/',
    observers: [SessionRouterObserver(ref)],
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: '/onboarding',
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: '/supplier-type',
        name: 'supplier-type',
        builder: (context, state) => const ChooseSupplierTypeScreen(),
      ),
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: 'register',
        builder: (context, state) => const CreateAccountScreen(),
      ),
      GoRoute(
        path: '/verify-otp',
        name: 'verify-otp',
        builder: (context, state) => const OtpVerificationScreen(),
      ),
      GoRoute(
        path: '/supplier-registration',
        name: 'supplier-registration',
        builder: (context, state) => const SupplierRegistrationScreen(),
      ),
      GoRoute(
        path: '/home',
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/notifications',
        name: 'notifications',
        builder: (context, state) => const NotificationsCenterScreen(),
      ),
      GoRoute(
        path: '/search',
        name: 'search',
        builder: (context, state) => const GlobalSearchScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: 'profile',
        builder: (context, state) => const SupplierProfileScreen(),
      ),
      GoRoute(
        path: '/add-product',
        name: 'add-product',
        builder: (context, state) => const AddNewProductScreen(),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const OrdersScreen(),
      ),
      GoRoute(
        path: '/rfq-details',
        name: 'rfq-details',
        builder: (context, state) => RfqDetailsScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/create-offer',
        name: 'create-offer',
        builder: (context, state) => CreateOfferScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
    ],
  );
}
