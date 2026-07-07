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
import '../../features/products/presentation/screens/products_module_screen.dart';
import '../../features/orders/presentation/screens/orders_screen.dart';
import '../../features/orders/presentation/screens/rfq_details_screen.dart';
import '../../features/orders/presentation/screens/create_offer_screen.dart';
import '../../features/orders/presentation/screens/rfq_chat_screen.dart';
import '../../features/orders/presentation/screens/offer_preview_screen.dart';
import '../../features/orders/presentation/screens/offer_details_screen.dart';
import '../../features/orders/presentation/screens/offer_rejected_screen.dart';
import '../../features/orders/presentation/screens/offer_approved_screen.dart';
import '../../features/orders/presentation/screens/final_agreement_screen.dart';
import '../../features/orders/presentation/screens/quotation_revision_history_screen.dart';
import '../../features/orders/presentation/screens/production_preparation_screen.dart';
import '../../features/orders/presentation/screens/factory_preparation_review_screen.dart';
import '../../features/orders/presentation/screens/shipping_manifest_screen.dart';
import '../../features/orders/presentation/screens/delivery_confirmation_screen.dart';
import '../../features/orders/presentation/screens/payment_release_screen.dart';
import '../../features/orders/presentation/screens/activity_log_screen.dart';
import '../../features/orders/presentation/screens/order_center_screen.dart';
import '../../features/orders/presentation/screens/dispute_center_screen.dart';
import '../../features/orders/presentation/screens/create_quotation_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/public_supplier_profile_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/edit_supplier_profile_screen.dart';
import '../../features/messages/presentation/screens/messages_screen.dart';
import '../../features/messages/presentation/screens/business_chat_screen.dart';
import '../../features/messages/presentation/screens/support_chat_screen.dart';
import '../../features/messages/presentation/screens/attachments_screen.dart';
import '../../features/messages/presentation/screens/quotation_history_screen.dart';
import '../../features/messages/presentation/screens/chat_timeline_screen.dart';
import '../../features/messages/presentation/screens/search_messages_screen.dart';
import '../../features/messages/presentation/screens/chat_settings_screen.dart';
import '../../features/messages/presentation/screens/archived_chats_screen.dart';

import '../../features/shipping/presentation/screens/shipping_dashboard_screen.dart';
import '../../features/shipping/presentation/screens/shipment_details_screen.dart';
import '../../features/shipping/presentation/screens/shipment_tracking_screen.dart';
import '../../features/shipping/presentation/screens/shipment_issue_screen.dart';
import '../../features/shipping/presentation/screens/shipping_company_selector_screen.dart';
import '../../features/shipping/presentation/screens/shipment_documents_screen.dart';

part 'app_router.g.dart';

@riverpod
GoRouter goRouter(GoRouterRef ref) {
  return GoRouter(
    initialLocation: '/home',
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
        pageBuilder: (context, state) => const NoTransitionPage(child: HomeScreen()),
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
        pageBuilder: (context, state) => const NoTransitionPage(child: SupplierProfileScreen()),
      ),
      GoRoute(
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const EditSupplierProfileScreen(),
      ),
      GoRoute(
        path: '/products',
        name: 'products',
        pageBuilder: (context, state) => const NoTransitionPage(child: ProductsModuleScreen()),
      ),
      GoRoute(
        path: '/add-product',
        name: 'add-product',
        builder: (context, state) => const AddNewProductScreen(),
      ),
      GoRoute(
        path: '/shipping',
        name: 'shipping',
        pageBuilder: (context, state) => const NoTransitionPage(child: ShippingDashboardScreen()),
      ),
      GoRoute(
        path: '/shipping/details/:id',
        name: 'shipping-details',
        builder: (context, state) => ShipmentDetailsScreen(
          shipmentId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/shipping/tracking/:id',
        name: 'shipping-tracking',
        builder: (context, state) => ShipmentTrackingScreen(
          shipmentId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/shipping/issue/:id',
        name: 'shipping-issue',
        builder: (context, state) => ShipmentIssueScreen(
          shipmentId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/shipping/company-selector/:id',
        name: 'shipping-company-selector',
        builder: (context, state) => ShippingCompanySelectorScreen(
          shipmentId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/shipping/documents/:id',
        name: 'shipping-documents',
        builder: (context, state) => ShipmentDocumentsScreen(
          shipmentId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        pageBuilder: (context, state) => const NoTransitionPage(child: OrdersScreen()),
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
      GoRoute(
        path: '/orders/chat',
        name: 'orders-chat',
        builder: (context, state) => RfqChatScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/offer-preview',
        name: 'orders-offer-preview',
        builder: (context, state) => OfferPreviewScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/offer-details',
        name: 'orders-offer-details',
        builder: (context, state) => OfferDetailsScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/offer-rejected',
        name: 'orders-offer-rejected',
        builder: (context, state) => OfferRejectedScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/offer-approved',
        name: 'orders-offer-approved',
        builder: (context, state) => OfferApprovedScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/final-agreement',
        name: 'orders-final-agreement',
        builder: (context, state) => FinalAgreementScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/quotation-history',
        name: 'orders-quotation-history',
        builder: (context, state) => QuotationRevisionHistoryScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/production-preparation',
        name: 'orders-production-preparation',
        builder: (context, state) => ProductionPreparationScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/factory-preparation-review',
        name: 'orders-factory-preparation-review',
        builder: (context, state) => FactoryPreparationReviewScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/shipping-manifest',
        name: 'orders-shipping-manifest',
        builder: (context, state) => ShippingManifestScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/delivery-confirmation',
        name: 'orders-delivery-confirmation',
        builder: (context, state) => DeliveryConfirmationScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/payment-release',
        name: 'orders-payment-release',
        builder: (context, state) => PaymentReleaseScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/activity-log',
        name: 'orders-activity-log',
        builder: (context, state) => ActivityLogScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/order-center',
        name: 'orders-order-center',
        builder: (context, state) => OrderCenterScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/dispute-center',
        name: 'orders-dispute-center',
        builder: (context, state) => DisputeCenterScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders/create-quotation',
        name: 'orders-create-quotation',
        builder: (context, state) => CreateQuotationScreen(
          rfqId: state.uri.queryParameters['rfqId'] ?? '',
          conversationId: state.uri.queryParameters['conversationId'],
        ),
      ),
      GoRoute(
        path: '/profile/public-preview',
        name: 'profile-public-preview',
        builder: (context, state) => const PublicSupplierProfileScreen(),
      ),
      // ─── Messages Feature ────────────────────────────────────────────
      GoRoute(
        path: '/messages',
        name: 'messages',
        pageBuilder: (context, state) => const NoTransitionPage(child: MessagesScreen()),
      ),
      GoRoute(
        path: '/messages/archived',
        name: 'messages-archived',
        builder: (context, state) => const ArchivedChatsScreen(),
      ),
      GoRoute(
        path: '/messages/search',
        name: 'messages-search',
        builder: (context, state) => SearchMessagesScreen(
          conversationId: state.uri.queryParameters['conversationId'],
        ),
      ),
      GoRoute(
        path: '/messages/chat/:id',
        name: 'messages-business-chat',
        builder: (context, state) => BusinessChatScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages/chat/:id/settings',
        name: 'messages-chat-settings',
        builder: (context, state) => ChatSettingsScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages/chat/:id/attachments',
        name: 'messages-attachments',
        builder: (context, state) => AttachmentsScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages/chat/:id/quotation-history',
        name: 'messages-quotation-history',
        builder: (context, state) => QuotationHistoryScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages/chat/:id/timeline',
        name: 'messages-timeline',
        builder: (context, state) => ChatTimelineScreen(
          conversationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/messages/support/:id',
        name: 'messages-support-chat',
        builder: (context, state) => SupportChatScreen(
          ticketId: state.pathParameters['id'] ?? '',
        ),
      ),
    ],
  );
}
