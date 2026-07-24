import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'session_router_observer.dart';
import '../widgets/main_shell_scaffold.dart';
import '../../features/auth/presentation/controllers/auth_controller.dart';
import '../../features/auth/domain/models/user_model.dart';
import '../../features/auth/presentation/screens/splash/splash_screen.dart';
import '../../features/auth/presentation/screens/choose_supplier_type/choose_supplier_type_screen.dart';
import '../../features/auth/presentation/screens/login/login_screen.dart';
import '../../features/auth/presentation/screens/create_account/create_account_screen.dart';
import '../../features/auth/presentation/screens/otp_verification/otp_verification_screen.dart';
import '../../features/auth/presentation/screens/supplier_registration/supplier_registration_screen.dart';
import '../../features/auth/presentation/screens/supplier_registration/register_review_screen.dart';
import '../../features/auth/presentation/screens/terms/terms_conditions_screen.dart';
import '../../features/auth/presentation/screens/terms/privacy_policy_screen.dart';
import '../../features/auth/presentation/screens/google_complete_registration/google_complete_registration_screen.dart';
import '../../features/dashboard/presentation/screens/home/home_screen.dart';
import '../../features/dashboard/presentation/screens/analytics/analytics_screen.dart';
import '../../features/dashboard/presentation/screens/operations_log/operations_log_screen.dart';
import '../../features/notifications/presentation/screens/notifications_center/notifications_center_screen.dart';
import '../../features/search/presentation/screens/global_search/global_search_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/supplier_profile_screen.dart';
import '../../features/products/presentation/screens/add_product/add_product_screen.dart';
import '../../features/products/presentation/screens/products_module_screen.dart';
import '../../features/products/presentation/screens/product_usage_screen.dart';
import '../../features/deals/presentation/screens/deals_dashboard_screen.dart';
import '../../features/deals/presentation/screens/deal_details_screen.dart';

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
import '../../features/quotations/presentation/screens/create_quotation_wizard_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/public_supplier_profile_screen.dart';
import '../../features/profile/presentation/screens/supplier_profile/edit_supplier_profile_screen.dart';
import '../../features/messages/presentation/screens/messages_screen.dart';
import '../../features/messages/presentation/screens/business_chat_screen.dart';
import '../../features/messages/presentation/screens/support_chat_screen.dart';
import '../../features/messages/presentation/screens/attachments_screen.dart';
import '../../features/messages/presentation/screens/quotation_history_screen.dart'
    as msg_qh;
import '../../features/messages/presentation/screens/chat_timeline_screen.dart';
import '../../features/messages/presentation/screens/search_messages_screen.dart';
import '../../features/messages/presentation/screens/chat_settings_screen.dart';
import '../../features/messages/presentation/screens/archived_chats_screen.dart';
import '../../features/products/presentation/screens/product_details_screen.dart';

import '../../features/shipping/presentation/screens/shipping_dashboard_screen.dart';
import '../../features/shipping/presentation/screens/shipment_details_screen.dart';
import '../../features/shipping/presentation/screens/shipment_tracking_screen.dart';
import '../../features/shipping/presentation/screens/shipment_issue_screen.dart';
import '../../features/shipping/presentation/screens/shipping_company_selector_screen.dart';
import '../../features/shipping/presentation/screens/shipment_documents_screen.dart';

import '../../features/agreements/presentation/screens/agreements_dashboard_screen.dart';
import '../../features/agreements/presentation/screens/agreement_details_screen.dart';
import '../../features/agreements/presentation/screens/agreement_comparison_screen.dart';
import '../../features/agreements/presentation/screens/agreement_documents_screen.dart';
import '../../features/agreements/presentation/screens/agreement_history_screen.dart';

import '../../features/quotations/presentation/screens/quotations_dashboard_screen.dart';
import '../../features/quotations/presentation/screens/quotation_details_screen.dart';
import '../../features/quotations/presentation/screens/quotation_comparison_screen.dart';
import '../../features/quotations/presentation/screens/quotation_versions_screen.dart';
import '../../features/quotations/presentation/screens/quotation_history_screen.dart';

import '../../features/customers/presentation/screens/customers_dashboard_screen.dart';
import '../../features/customers/presentation/screens/customer_details_screen.dart';
import '../../features/customers/presentation/screens/customer_orders_screen.dart';
import '../../features/customers/presentation/screens/customer_notes_screen.dart';
import '../../features/customers/presentation/screens/customer_analytics_screen.dart';

import '../../features/financial/presentation/screens/financial_dashboard_screen.dart';
import '../../features/financial/presentation/screens/transactions_screen.dart';
import '../../features/financial/presentation/screens/transaction_details_screen.dart';
import '../../features/financial/presentation/screens/payments_screen.dart';
import '../../features/financial/presentation/screens/payment_details_screen.dart';
import '../../features/financial/presentation/screens/wallet_screen.dart';
import '../../features/financial/presentation/screens/withdrawals_screen.dart';
import '../../features/financial/presentation/screens/request_withdrawal_screen.dart';
import '../../features/financial/presentation/screens/earnings_screen.dart';
import '../../features/financial/presentation/screens/expenses_screen.dart';
import '../../features/financial/presentation/screens/invoices_screen.dart';
import '../../features/financial/presentation/screens/invoice_details_screen.dart';
import '../../features/financial/presentation/screens/financial_reports_screen.dart';
import '../../features/financial/presentation/screens/tax_center_screen.dart';
import '../../features/financial/presentation/screens/payment_methods_screen.dart';
import '../../features/financial/presentation/screens/refunds_screen.dart';
import '../../features/financial/presentation/screens/escrow_tracking_screen.dart';
import '../../features/financial/presentation/screens/financial_analytics_screen.dart';
import '../../features/financial/domain/entities/financial_models.dart';

import '../../features/subscription/presentation/screens/subscription_dashboard_screen.dart';
import '../../features/subscription/presentation/screens/subscription_plans_screen.dart';
import '../../features/subscription/presentation/screens/plan_comparison_screen.dart';
import '../../features/subscription/presentation/screens/subscription_details_screen.dart';
import '../../features/subscription/presentation/screens/billing_screen.dart';
import '../../features/subscription/presentation/screens/payment_methods_screen.dart';
import '../../features/subscription/presentation/screens/subscription_history_screen.dart';
import '../../features/subscription/presentation/screens/usage_limits_screen.dart';
import '../../features/subscription/presentation/screens/addons_store_screen.dart';
import '../../features/subscription/presentation/screens/addon_details_screen.dart';
import '../../features/subscription/presentation/screens/checkout_screen.dart';
import '../../features/subscription/presentation/screens/billing_invoices_screen.dart';
import '../../features/subscription/presentation/screens/subscription_notifications_screen.dart';
import '../../features/subscription/presentation/screens/subscription_analytics_screen.dart';
import '../../features/subscription/presentation/screens/subscription_management_screen.dart';
import '../../features/subscription/presentation/screens/subscription_test_demo_screen.dart';
import '../../features/subscription/domain/entities/subscription_models.dart';

// ─── Reports Feature ─────────────────────────────────────────────────────────
import '../../features/reports/presentation/screens/analytics_dashboard_screen.dart';
import '../../features/reports/presentation/screens/sales_report_screen.dart';
import '../../features/reports/presentation/screens/orders_report_screen.dart';
import '../../features/reports/presentation/screens/products_report_screen.dart';
import '../../features/reports/presentation/screens/product_performance_screen.dart';
import '../../features/reports/presentation/screens/customers_report_screen.dart';
import '../../features/reports/presentation/screens/quotations_report_screen.dart';
import '../../features/reports/presentation/screens/financial_report_screen.dart';
import '../../features/reports/presentation/screens/shipping_report_screen.dart';
import '../../features/reports/presentation/screens/subscription_report_screen.dart';
import '../../features/reports/presentation/screens/advertisement_report_screen.dart';
import '../../features/reports/presentation/screens/performance_report_screen.dart';
import '../../features/reports/presentation/screens/ai_insights_screen.dart';

part 'app_router.g.dart';

class RouterNotifier extends ChangeNotifier {
  final Ref _ref;

  RouterNotifier(this._ref) {
    _ref.listen<AsyncValue<UserModel?>>(
      authControllerProvider,
      (_, __) {
        notifyListeners();
      },
    );
  }
}

@Riverpod(keepAlive: true)
GoRouter goRouter(Ref ref) {
  final notifier = RouterNotifier(ref);

  return GoRouter(
    initialLocation: '/',
    refreshListenable: notifier,
    observers: [SessionRouterObserver(ref)],
    redirect: (context, state) {
      final authState = ref.read(authControllerProvider);
      
      final isLoggingIn = state.uri.path == '/login' ||
                          state.uri.path == '/register' ||
                          state.uri.path == '/verify-otp' ||
                          state.uri.path == '/supplier-registration' ||
                          state.uri.path == '/register-review' ||
                          state.uri.path == '/google-complete-registration' ||
                          state.uri.path == '/terms' ||
                          state.uri.path == '/privacy' ||
                          state.uri.path == '/supplier-type' ||
                          state.uri.path == '/';

      final isAuthenticated = authState.value != null;

      if (!isAuthenticated && !isLoggingIn) {
        return '/login';
      }

      if (isAuthenticated && isLoggingIn) {
        return '/home';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
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
        path: '/register-review',
        name: 'register-review',
        builder: (context, state) => const RegisterReviewScreen(),
      ),
      GoRoute(
        path: '/terms',
        name: 'terms',
        builder: (context, state) => const TermsConditionsScreen(),
      ),
      GoRoute(
        path: '/privacy',
        name: 'privacy',
        builder: (context, state) => const PrivacyPolicyScreen(),
      ),
      GoRoute(
        path: '/google-complete-registration',
        name: 'google-complete-registration',
        builder: (context, state) => const GoogleCompleteRegistrationScreen(),
      ),
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainShellScaffold(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: الرئيسية (Home)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/home',
                name: 'home',
                builder: (context, state) => const HomeScreen(),
              ),
            ],
          ),
          // Branch 1: المنتجات (Products)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/products',
                name: 'products',
                builder: (context, state) => const ProductsModuleScreen(),
              ),
            ],
          ),
          // Branch 2: الصفقات (Deals)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/deals',
                name: 'deals',
                builder: (context, state) => const DealsDashboardScreen(),
              ),
            ],
          ),
          // Branch 3: المحادثات (Messages)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/messages',
                name: 'messages',
                builder: (context, state) => const MessagesScreen(),
              ),
            ],
          ),
          // Branch 4: الحساب (Profile)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/profile',
                name: 'profile',
                builder: (context, state) => const SupplierProfileScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/analytics',
        name: 'analytics',
        builder: (context, state) => const AnalyticsScreen(),
      ),
      GoRoute(
        path: '/operations-log',
        name: 'operations-log',
        builder: (context, state) => const OperationsLogScreen(),
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
        path: '/profile/edit',
        name: 'profile-edit',
        builder: (context, state) => const EditSupplierProfileScreen(),
      ),
      GoRoute(
        path: '/add-product',
        name: 'add-product',
        builder: (context, state) => const AddNewProductScreen(),
      ),
      GoRoute(
        path: '/products/usage',
        name: 'products-usage',
        builder: (context, state) => const ProductUsageScreen(),
      ),
      GoRoute(
        path: '/products/details/:id',
        name: 'product-details',
        builder: (context, state) => ProductDetailsScreen(
          productId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/shipping',
        name: 'shipping',
        builder: (context, state) => const ShippingDashboardScreen(),
      ),
      GoRoute(
        path: '/shipping/details/:id',
        name: 'shipping-details',
        builder: (context, state) =>
            ShipmentDetailsScreen(shipmentId: state.pathParameters['id'] ?? ''),
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
        builder: (context, state) =>
            ShipmentIssueScreen(shipmentId: state.pathParameters['id'] ?? ''),
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
      // ─── Agreements Feature ──────────────────────────────────────────
      GoRoute(
        path: '/agreements',
        name: 'agreements',
        builder: (context, state) => const AgreementsDashboardScreen(),
      ),
      GoRoute(
        path: '/agreements/details/:id',
        name: 'agreements-details',
        builder: (context, state) => AgreementDetailsScreen(
          agreementId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/agreements/comparison/:id',
        name: 'agreements-comparison',
        builder: (context, state) => AgreementComparisonScreen(
          agreementId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/agreements/documents/:id',
        name: 'agreements-documents',
        builder: (context, state) => AgreementDocumentsScreen(
          agreementId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/agreements/history/:id',
        name: 'agreements-history',
        builder: (context, state) => AgreementHistoryScreen(
          agreementId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/deals/details/:id',
        name: 'deals-details',
        builder: (context, state) => DealDetailsScreen(
          dealId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/orders',
        name: 'orders',
        builder: (context, state) => const DealsDashboardScreen(),
      ),
      GoRoute(
        path: '/rfq-details',
        name: 'rfq-details',
        builder: (context, state) =>
            RfqDetailsScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
      ),
      GoRoute(
        path: '/create-offer',
        name: 'create-offer',
        builder: (context, state) =>
            CreateOfferScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
      ),
      GoRoute(
        path: '/orders/chat',
        name: 'orders-chat',
        builder: (context, state) =>
            RfqChatScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
      ),
      GoRoute(
        path: '/orders/offer-preview',
        name: 'orders-offer-preview',
        builder: (context, state) =>
            OfferPreviewScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
      ),
      GoRoute(
        path: '/orders/offer-details',
        name: 'orders-offer-details',
        builder: (context, state) =>
            OfferDetailsScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
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
        builder: (context, state) =>
            ActivityLogScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
      ),
      GoRoute(
        path: '/orders/order-center',
        name: 'orders-order-center',
        builder: (context, state) =>
            OrderCenterScreen(rfqId: state.uri.queryParameters['rfqId'] ?? ''),
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
        path: '/messages/chat',
        name: 'messages-business-chat-query',
        builder: (context, state) {
          final dealId = state.uri.queryParameters['dealId'] ??
              state.uri.queryParameters['conversationId'] ??
              'DEAL-101';
          return BusinessChatScreen(
            dealId: dealId,
            conversationId: dealId,
          );
        },
      ),
      GoRoute(
        path: '/messages/chat/:id',
        name: 'messages-business-chat',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? 'DEAL-101';
          return BusinessChatScreen(
            dealId: id,
            conversationId: id,
          );
        },
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
        builder: (context, state) =>
            AttachmentsScreen(conversationId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/messages/chat/:id/quotation-history',
        name: 'messages-quotation-history',
        builder: (context, state) => msg_qh.QuotationHistoryScreen(
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
        builder: (context, state) =>
            SupportChatScreen(ticketId: state.pathParameters['id'] ?? ''),
      ),
      // ─── Quotations Feature ───────────────────────────────────────────
      GoRoute(
        path: '/quotations',
        name: 'quotations',
        builder: (context, state) => const QuotationsDashboardScreen(),
      ),
      GoRoute(
        path: '/quotations/create',
        name: 'quotations-create',
        builder: (context, state) => const CreateQuotationWizardScreen(),
      ),
      GoRoute(
        path: '/quotations/details/:id',
        name: 'quotations-details',
        builder: (context, state) => QuotationDetailsScreen(
          quotationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/quotations/comparison/:id',
        name: 'quotations-comparison',
        builder: (context, state) => QuotationComparisonScreen(
          quotationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/quotations/versions/:id',
        name: 'quotations-versions',
        builder: (context, state) => QuotationVersionsScreen(
          quotationId: state.pathParameters['id'] ?? '',
        ),
      ),
      GoRoute(
        path: '/quotations/history/:id',
        name: 'quotations-history',
        builder: (context, state) => QuotationHistoryScreen(
          quotationId: state.pathParameters['id'] ?? '',
        ),
      ),
      // ─── Customers (CRM) Feature ──────────────────────────────────────
      GoRoute(
        path: '/customers',
        name: 'customers',
        builder: (context, state) => const CustomersDashboardScreen(),
      ),
      GoRoute(
        path: '/customers/details/:id',
        name: 'customers-details',
        builder: (context, state) =>
            CustomerDetailsScreen(customerId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/customers/orders/:id',
        name: 'customers-orders',
        builder: (context, state) =>
            CustomerOrdersScreen(customerId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/customers/notes/:id',
        name: 'customers-notes',
        builder: (context, state) =>
            CustomerNotesScreen(customerId: state.pathParameters['id'] ?? ''),
      ),
      GoRoute(
        path: '/customers/analytics/:id',
        name: 'customers-analytics',
        builder: (context, state) => CustomerAnalyticsScreen(
          customerId: state.pathParameters['id'] ?? '',
        ),
      ),
      // ─── Financial Feature ───────────────────────────────────────────
      GoRoute(
        path: '/finance',
        name: 'finance-dashboard',
        builder: (context, state) => const FinancialDashboardScreen(),
      ),
      GoRoute(
        path: '/finance/transactions',
        name: 'finance-transactions',
        builder: (context, state) => const TransactionsScreen(),
      ),
      GoRoute(
        path: '/finance/transactions/:id',
        name: 'finance-transaction-details',
        builder: (context, state) {
          final extraTxn = state.extra as FinancialTransaction?;
          return TransactionDetailsScreen(
            transactionId: state.pathParameters['id'] ?? '',
            transaction: extraTxn,
          );
        },
      ),
      GoRoute(
        path: '/finance/payments',
        name: 'finance-payments',
        builder: (context, state) => const PaymentsScreen(),
      ),
      GoRoute(
        path: '/finance/payments/:id',
        name: 'finance-payment-details',
        builder: (context, state) {
          final extraPay = state.extra as SupplierPayment?;
          return PaymentDetailsScreen(
            paymentNumber: state.pathParameters['id'] ?? '',
            payment: extraPay,
          );
        },
      ),
      GoRoute(
        path: '/finance/wallet',
        name: 'finance-wallet',
        builder: (context, state) => const WalletScreen(),
      ),
      GoRoute(
        path: '/finance/withdrawals',
        name: 'finance-withdrawals',
        builder: (context, state) => const WithdrawalsScreen(),
      ),
      GoRoute(
        path: '/finance/withdrawals/request',
        name: 'finance-withdrawals-request',
        builder: (context, state) => const RequestWithdrawalScreen(),
      ),
      GoRoute(
        path: '/finance/earnings',
        name: 'finance-earnings',
        builder: (context, state) => const EarningsScreen(),
      ),
      GoRoute(
        path: '/finance/expenses',
        name: 'finance-expenses',
        builder: (context, state) => const ExpensesScreen(),
      ),
      GoRoute(
        path: '/finance/invoices',
        name: 'finance-invoices',
        builder: (context, state) => const InvoicesScreen(),
      ),
      GoRoute(
        path: '/finance/invoices/:id',
        name: 'finance-invoice-details',
        builder: (context, state) {
          final extraInv = state.extra as SupplierInvoice?;
          return InvoiceDetailsScreen(
            invoiceNumber: state.pathParameters['id'] ?? '',
            invoice: extraInv,
          );
        },
      ),
      GoRoute(
        path: '/finance/reports',
        name: 'finance-reports',
        builder: (context, state) => const FinancialReportsScreen(),
      ),
      GoRoute(
        path: '/finance/tax',
        name: 'finance-tax',
        builder: (context, state) => const TaxCenterScreen(),
      ),
      GoRoute(
        path: '/finance/methods',
        name: 'finance-methods',
        builder: (context, state) => const PaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/finance/refunds',
        name: 'finance-refunds',
        builder: (context, state) => const RefundsScreen(),
      ),
      GoRoute(
        path: '/finance/escrow',
        name: 'finance-escrow',
        builder: (context, state) => const EscrowTrackingScreen(),
      ),
      GoRoute(
        path: '/finance/analytics',
        name: 'finance-analytics',
        builder: (context, state) => const FinancialAnalyticsScreen(),
      ),
      // ─── Subscription & Billing Feature ────────────────────────────────
      GoRoute(
        path: '/subscription',
        name: 'subscription-dashboard',
        builder: (context, state) => const SubscriptionDashboardScreen(),
      ),
      GoRoute(
        path: '/subscription/plans',
        name: 'subscription-plans',
        builder: (context, state) => const SubscriptionPlansScreen(),
      ),
      GoRoute(
        path: '/subscription/comparison',
        name: 'plan-comparison',
        builder: (context, state) => const PlanComparisonScreen(),
      ),
      GoRoute(
        path: '/subscription/details',
        name: 'subscription-details',
        builder: (context, state) => const SubscriptionDetailsScreen(),
      ),
      GoRoute(
        path: '/subscription/billing',
        name: 'subscription-billing',
        builder: (context, state) => const BillingScreen(),
      ),
      GoRoute(
        path: '/subscription/methods',
        name: 'subscription-methods',
        builder: (context, state) => const SubscriptionPaymentMethodsScreen(),
      ),
      GoRoute(
        path: '/subscription/history',
        name: 'subscription-history',
        builder: (context, state) => const SubscriptionHistoryScreen(),
      ),
      GoRoute(
        path: '/subscription/usage',
        name: 'subscription-usage',
        builder: (context, state) => const UsageLimitsScreen(),
      ),
      GoRoute(
        path: '/subscription/addons',
        name: 'subscription-addons',
        builder: (context, state) => const AddonsStoreScreen(),
      ),
      GoRoute(
        path: '/subscription/addons/:id',
        name: 'addon-details',
        builder: (context, state) {
          final addonItem = state.extra as AddonItem?;
          return AddonDetailsScreen(
            addonId: state.pathParameters['id'] ?? '',
            addon: addonItem,
          );
        },
      ),
      GoRoute(
        path: '/subscription/checkout',
        name: 'subscription-checkout',
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>? ?? {};
          return CheckoutScreen(
            plan: extra['plan'] as SubscriptionPlan?,
            cycle: extra['cycle'] as BillingCycle?,
            addon: extra['addon'] as AddonItem?,
          );
        },
      ),
      GoRoute(
        path: '/subscription/invoices',
        name: 'subscription-invoices',
        builder: (context, state) => const BillingInvoicesScreen(),
      ),
      GoRoute(
        path: '/subscription/notifications',
        name: 'subscription-notifications',
        builder: (context, state) =>
            const SubscriptionNotificationsScreen(),
      ),
      GoRoute(
        path: '/subscription/analytics',
        name: 'subscription-analytics',
        builder: (context, state) => const SubscriptionAnalyticsScreen(),
      ),
      GoRoute(
        path: '/subscription/manage',
        name: 'subscription-manage',
        builder: (context, state) => const SubscriptionManagementScreen(),
      ),
      GoRoute(
        path: '/subscription/test-demo',
        name: 'subscription-test-demo',
        builder: (context, state) => const SubscriptionTestDemoScreen(),
      ),
      // ─── Reports Feature ─────────────────────────────────────────────
      GoRoute(
        path: '/reports',
        name: 'reports-dashboard',
        builder: (context, state) => const AnalyticsDashboardScreen(),
      ),
      GoRoute(
        path: '/reports/sales',
        name: 'reports-sales',
        builder: (context, state) => const SalesReportScreen(),
      ),
      GoRoute(
        path: '/reports/orders',
        name: 'reports-orders',
        builder: (context, state) => const OrdersReportScreen(),
      ),
      GoRoute(
        path: '/reports/products',
        name: 'reports-products',
        builder: (context, state) => const ProductsReportScreen(),
      ),
      GoRoute(
        path: '/reports/products/performance',
        name: 'reports-products-performance',
        builder: (context, state) => const ProductPerformanceScreen(),
      ),
      GoRoute(
        path: '/reports/customers',
        name: 'reports-customers',
        builder: (context, state) => const CustomersReportScreen(),
      ),
      GoRoute(
        path: '/reports/quotations',
        name: 'reports-quotations',
        builder: (context, state) => const QuotationsReportScreen(),
      ),
      GoRoute(
        path: '/reports/financial',
        name: 'reports-financial',
        builder: (context, state) => const FinancialReportScreen(),
      ),
      GoRoute(
        path: '/reports/shipping',
        name: 'reports-shipping',
        builder: (context, state) => const ShippingReportScreen(),
      ),
      GoRoute(
        path: '/reports/subscription',
        name: 'reports-subscription',
        builder: (context, state) => const SubscriptionReportScreen(),
      ),
      GoRoute(
        path: '/reports/advertisements',
        name: 'reports-advertisements',
        builder: (context, state) => const AdvertisementReportScreen(),
      ),
      GoRoute(
        path: '/reports/performance',
        name: 'reports-performance',
        builder: (context, state) => const PerformanceReportScreen(),
      ),
      GoRoute(
        path: '/reports/ai-insights',
        name: 'reports-ai-insights',
        builder: (context, state) => const AiInsightsScreen(),
      ),
    ],
  );
}
