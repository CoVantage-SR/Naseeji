import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../widgets/reusable_widgets.dart';

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
import '../../features/home/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/home/presentation/screens/quick_statistics_screen.dart';
import '../../features/home/presentation/screens/mini_profile_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/products/presentation/screens/products_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';
import '../../features/products/presentation/screens/product_search_screen.dart';
import '../../features/products/presentation/screens/suppliers_screen.dart';
import '../../features/products/presentation/screens/supplier_details_screen.dart';
import '../../features/products/presentation/screens/suppliers_comparison_screen.dart';
import '../../features/products/presentation/screens/price_comparison_screen.dart';
import '../../features/products/presentation/screens/delivery_comparison_screen.dart';
import '../../features/products/presentation/screens/favorite_suppliers_screen.dart';
import '../../features/products/presentation/screens/request_product_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/rfq/presentation/screens/rfq_screen.dart';
import '../../features/rfq/presentation/screens/create_rfq_screen.dart';
import '../../features/rfq/presentation/screens/rfq_details_screen.dart';
import '../../features/rfq/presentation/screens/received_quotations_screen.dart';
import '../../features/rfq/presentation/screens/quotation_details_screen.dart';
import '../../features/rfq/presentation/screens/quotations_comparison_screen.dart';
import '../../features/rfq/presentation/screens/counter_offer_screen.dart';
import '../../features/rfq/presentation/screens/approve_offer_screen.dart';
import '../../features/rfq/presentation/screens/reject_offer_screen.dart';
import '../../features/rfq/presentation/screens/quotation_revision_history_screen.dart';
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
      // Notifications
      GoRoute(
        path: '/notifications',
        builder: (context, state) => const NotificationsScreen(),
      ),
      // Search
      GoRoute(
        path: '/search',
        builder: (context, state) {
          final type = state.uri.queryParameters['type'];
          final favorites = state.uri.queryParameters['favorites'] == 'true';
          return SearchScreen(initialType: type, onlyFavorites: favorites);
        },
      ),
      // Quick Statistics
      GoRoute(
        path: '/statistics',
        builder: (context, state) => const QuickStatisticsScreen(),
      ),
      // Mini Profile
      GoRoute(
        path: '/mini-profile',
        builder: (context, state) => const MiniProfileScreen(),
      ),
      // Product Details
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductDetailsScreen(productId: id);
        },
      ),
      // Product Search & Filters
      GoRoute(
        path: '/product-search',
        builder: (context, state) => const ProductSearchScreen(),
      ),
      // Suppliers List
      GoRoute(
        path: '/suppliers',
        builder: (context, state) => const SuppliersScreen(),
      ),
      // Supplier Details
      GoRoute(
        path: '/suppliers/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SupplierDetailsScreen(supplierId: id);
        },
      ),
      // Suppliers Comparison
      GoRoute(
        path: '/suppliers-comparison',
        builder: (context, state) => const SuppliersComparisonScreen(),
      ),
      // Price Comparison
      GoRoute(
        path: '/price-comparison',
        builder: (context, state) => const PriceComparisonScreen(),
      ),
      // Delivery Comparison
      GoRoute(
        path: '/delivery-comparison',
        builder: (context, state) => const DeliveryComparisonScreen(),
      ),
      // Favorite Suppliers
      GoRoute(
        path: '/favorite-suppliers',
        builder: (context, state) => const FavoriteSuppliersScreen(),
      ),
      // Request Product
      GoRoute(
        path: '/request-product',
        builder: (context, state) {
          final id = state.uri.queryParameters['id'] ?? 'prod_1';
          return RequestProductScreen(productId: id);
        },
      ),
      // Create RFQ
      GoRoute(
        path: '/rfq/create',
        builder: (context, state) => const CreateRFQScreen(),
      ),
      // RFQ Details
      GoRoute(
        path: '/rfq/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RFQDetailsScreen(rfqId: id);
        },
      ),
      // Received Quotations
      GoRoute(
        path: '/rfq/:id/quotations',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ReceivedQuotationsScreen(rfqId: id);
        },
      ),
      // Quotation Details
      GoRoute(
        path: '/rfq/quotation/:quoteId',
        builder: (context, state) {
          final id = state.pathParameters['quoteId'] ?? '';
          return QuotationDetailsScreen(quoteId: id);
        },
      ),
      // Compare Quotations
      GoRoute(
        path: '/rfq/:id/compare-quotations',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QuotationsComparisonScreen(rfqId: id);
        },
      ),
      // Counter Offer
      GoRoute(
        path: '/rfq/quotation/:quoteId/counter',
        builder: (context, state) {
          final id = state.pathParameters['quoteId'] ?? '';
          return CounterOfferScreen(quoteId: id);
        },
      ),
      // Approve Offer
      GoRoute(
        path: '/rfq/quotation/:quoteId/approve',
        builder: (context, state) {
          final id = state.pathParameters['quoteId'] ?? '';
          return ApproveOfferScreen(quoteId: id);
        },
      ),
      // Reject Offer
      GoRoute(
        path: '/rfq/quotation/:quoteId/reject',
        builder: (context, state) {
          final id = state.pathParameters['quoteId'] ?? '';
          return RejectOfferScreen(quoteId: id);
        },
      ),
      // Quotation Revision History
      GoRoute(
        path: '/rfq/quotation/:quoteId/revisions',
        builder: (context, state) {
          final id = state.pathParameters['quoteId'] ?? '';
          return QuotationRevisionHistoryScreen(quoteId: id);
        },
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

class ScaffoldWithNestedNavigation extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithNestedNavigation({
    super.key,
    required this.navigationShell,
  });

  void _onTap(BuildContext context, WidgetRef ref, int index) {
    if (index >= 2) {
      checkGuestAction(context, ref, () {
        navigationShell.goBranch(
          index,
          initialLocation: index == navigationShell.currentIndex,
        );
      });
    } else {
      navigationShell.goBranch(
        index,
        initialLocation: index == navigationShell.currentIndex,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, ref, index),
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
