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
import '../../features/auth/presentation/screens/otp_screen.dart';
import '../../features/auth/presentation/screens/register_screen.dart';
import '../../features/auth/presentation/screens/splash_screen.dart';
import '../../features/chat/presentation/screens/chat_screen.dart';
import '../../features/chat/presentation/screens/chat_detail_screen.dart';
import '../../features/chat/presentation/screens/negotiation_summary_screen.dart';
import '../../features/chat/presentation/screens/shared_files_screen.dart';
import '../../features/chat/presentation/screens/chat_settings_screen.dart';
import '../../features/chat/presentation/screens/archived_conversations_screen.dart';
import '../../features/home/presentation/screens/home_screen.dart';
import '../../features/home/presentation/widgets/factory_bottom_navigation.dart';
import '../../features/home/presentation/screens/notifications_screen.dart';
import '../../features/home/presentation/screens/search_screen.dart';
import '../../features/home/presentation/screens/quick_statistics_screen.dart';
import '../../features/home/presentation/screens/mini_profile_screen.dart';
import '../../features/orders/presentation/screens/deals_screen.dart';
import '../../features/orders/presentation/screens/order_details_screen.dart';
import '../../features/orders/presentation/screens/order_timeline_screen.dart';
import '../../features/orders/presentation/screens/production_progress_screen.dart';
import '../../features/orders/presentation/screens/preparation_gallery_screen.dart';
import '../../features/orders/presentation/screens/preparation_videos_screen.dart';
import '../../features/orders/presentation/screens/shipment_tracking_screen.dart';
import '../../features/orders/presentation/screens/shipment_details_screen.dart';
import '../../features/orders/presentation/screens/delivery_confirmation_screen.dart';
import '../../features/orders/presentation/screens/live_order_status_screen.dart';
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
import '../../features/rfq/presentation/screens/factory_orders_screen.dart';
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
import '../../features/quality/presentation/screens/delivery_receipt_screen.dart';
import '../../features/quality/presentation/screens/quality_inspection_screen.dart';
import '../../features/quality/presentation/screens/issue_report_screen.dart';
import '../../features/quality/presentation/screens/reject_delivery_screen.dart';
import '../../features/quality/presentation/screens/replacement_request_screen.dart';
import '../../features/quality/presentation/screens/return_request_screen.dart';
import '../../features/purchases/presentation/screens/purchase_history_screen.dart';
import '../../features/purchases/presentation/screens/purchase_details_screen.dart';
import '../../features/purchases/presentation/screens/reorder_screen.dart';
import '../../features/purchases/presentation/screens/favorite_suppliers_screen.dart' as purchase_favs;
import '../../features/purchases/presentation/screens/invoices_screen.dart';
import '../../features/reviews/presentation/screens/rate_supplier_screen.dart';
import '../../features/reviews/presentation/screens/write_review_screen.dart';
import '../../features/reviews/presentation/screens/reviews_screen.dart';
import '../../features/reviews/presentation/screens/review_details_screen.dart';
import '../../features/account/presentation/screens/account_profile_screen.dart';
import '../../features/account/presentation/screens/edit_profile_screen.dart';
import '../../features/account/presentation/screens/employee_management_screen.dart';
import '../../features/account/presentation/screens/general_settings_screen.dart';
import '../../features/account/presentation/screens/notifications_settings_screen.dart';
import '../../features/account/presentation/screens/appearance_screen.dart';
import '../../features/account/presentation/screens/terms_screen.dart';
import '../../features/account/presentation/screens/privacy_screen.dart';
import '../../features/account/presentation/screens/security_screen.dart';
import '../../features/account/presentation/screens/subscription_screen.dart';
import '../../features/account/presentation/screens/payment_methods_screen.dart';
import '../../features/account/presentation/screens/language_screen.dart';
import '../../features/account/presentation/screens/help_center_screen.dart';
import '../../features/account/presentation/screens/support_screen.dart';
import '../../features/account/presentation/screens/about_screen.dart';

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
      // Chat details
      GoRoute(
        path: '/chat/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ChatDetailScreen(conversationId: id);
        },
      ),
      // Negotiation Summary
      GoRoute(
        path: '/chat/:id/summary',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return NegotiationSummaryScreen(conversationId: id);
        },
      ),
      // Shared Files
      GoRoute(
        path: '/chat/:id/files',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return SharedFilesScreen(conversationId: id);
        },
      ),
      // Chat Settings
      GoRoute(
        path: '/chat/:id/settings',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ChatSettingsScreen(conversationId: id);
        },
      ),
      // Archived Conversations
      GoRoute(
        path: '/chat/archived',
        builder: (context, state) => const ArchivedConversationsScreen(),
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

      // Order Details
      GoRoute(
        path: '/orders/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderDetailsScreen(orderId: id);
        },
      ),
      // Order Timeline
      GoRoute(
        path: '/orders/:id/timeline',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return OrderTimelineScreen(orderId: id);
        },
      ),
      // Production Progress
      GoRoute(
        path: '/orders/:id/production',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ProductionProgressScreen(orderId: id);
        },
      ),
      // Preparation Gallery
      GoRoute(
        path: '/orders/:id/gallery',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PreparationGalleryScreen(orderId: id);
        },
      ),
      // Preparation Videos
      GoRoute(
        path: '/orders/:id/videos',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PreparationVideosScreen(orderId: id);
        },
      ),
      // Shipment Tracking
      GoRoute(
        path: '/orders/:id/shipment',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ShipmentTrackingScreen(orderId: id);
        },
      ),
      // Shipment Details
      GoRoute(
        path: '/orders/:id/shipment/details',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ShipmentDetailsScreen(orderId: id);
        },
      ),
      // Delivery Confirmation
      GoRoute(
        path: '/orders/:id/confirm',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DeliveryConfirmationScreen(orderId: id);
        },
      ),
      // Live Order Status
      GoRoute(
        path: '/orders/:id/live',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return LiveOrderStatusScreen(orderId: id);
        },
      ),
      // Delivery Receipt Screen
      GoRoute(
        path: '/orders/:id/delivery-receipt',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return DeliveryReceiptScreen(orderId: id);
        },
      ),
      // Quality Inspection Screen
      GoRoute(
        path: '/orders/:id/quality-inspection',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return QualityInspectionScreen(orderId: id);
        },
      ),
      // Issue Report Screen
      GoRoute(
        path: '/orders/:id/issue-report',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return IssueReportScreen(orderId: id);
        },
      ),
      // Reject Delivery Screen
      GoRoute(
        path: '/orders/:id/reject-delivery',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return RejectDeliveryScreen(orderId: id);
        },
      ),
      // Replacement Request Screen
      GoRoute(
        path: '/orders/:id/replacement-request',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ReplacementRequestScreen(orderId: id);
        },
      ),
      // Return Request Screen
      GoRoute(
        path: '/orders/:id/return-request',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ReturnRequestScreen(orderId: id);
        },
      ),

      // Purchase History Routes
      GoRoute(
        path: '/purchases',
        builder: (context, state) => const PurchaseHistoryScreen(),
      ),
      GoRoute(
        path: '/purchases/favorites',
        builder: (context, state) => const purchase_favs.FavoriteSuppliersScreen(),
      ),
      GoRoute(
        path: '/purchases/invoices',
        builder: (context, state) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/purchases/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return PurchaseDetailsScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/purchases/:id/reorder',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '';
          return ReorderScreen(orderId: id);
        },
      ),

      // Reviews Routes
      GoRoute(
        path: '/reviews/rate/:orderId',
        builder: (context, state) {
          final id = state.pathParameters['orderId'] ?? '';
          return RateSupplierScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/reviews/write/:orderId',
        builder: (context, state) {
          final id = state.pathParameters['orderId'] ?? '';
          return WriteReviewScreen(orderId: id);
        },
      ),
      GoRoute(
        path: '/reviews/supplier/:supplierId',
        builder: (context, state) {
          final id = state.pathParameters['supplierId'] ?? '';
          return ReviewsScreen(supplierId: id);
        },
      ),
      GoRoute(
        path: '/reviews/details/:reviewId',
        builder: (context, state) {
          final id = state.pathParameters['reviewId'] ?? '';
          return ReviewDetailsScreen(reviewId: id);
        },
      ),

      // Account & Settings Routes
      GoRoute(
        path: '/account/profile',
        builder: (context, state) => const AccountProfileScreen(),
      ),
      GoRoute(
        path: '/account/profile/edit',
        builder: (context, state) => const EditProfileScreen(),
      ),
      GoRoute(
        path: '/account/employees',
        builder: (context, state) => const EmployeeManagementScreen(),
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
      GoRoute(
        path: '/account/security',
        builder: (context, state) => const SecurityScreen(),
      ),
      GoRoute(
        path: '/account/subscription',
        builder: (context, state) => const SubscriptionScreen(),
      ),
      GoRoute(
        path: '/account/payment-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/account/language',
        builder: (context, state) => const LanguageScreen(),
      ),
      GoRoute(
        path: '/account/help',
        builder: (context, state) => const HelpCenterScreen(),
      ),
      GoRoute(
        path: '/account/support',
        builder: (context, state) => const SupportScreen(),
      ),
      GoRoute(
        path: '/account/about',
        builder: (context, state) => const AboutScreen(),
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
          // Tab 2: RFQ (Factory Orders)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/rfq',
                builder: (context, state) => const FactoryOrdersScreen(),
              ),
            ],
          ),
          // Tab 3: Deals (الصفقات)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/orders',
                builder: (context, state) => const DealsScreen(),
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
      bottomNavigationBar: FactoryBottomNavigation(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, ref, index),
      ),
    );
  }
}
