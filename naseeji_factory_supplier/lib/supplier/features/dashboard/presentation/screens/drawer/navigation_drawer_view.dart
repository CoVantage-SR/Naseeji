import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import 'package:naseeji_factory/supplier/features/profile/presentation/controllers/profile_controller.dart';
import 'widgets/drawer_bottom_view.dart';
import 'widgets/drawer_header_view.dart';
import 'widgets/drawer_item.dart';

class NavigationDrawerView extends ConsumerWidget {
  const NavigationDrawerView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileControllerProvider);

    // Get current route to highlight active drawer item
    String currentRoute = '/home';
    try {
      currentRoute = GoRouterState.of(context).uri.path;
    } catch (_) {}

    return Drawer(
      child: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Drawer Header
            profileAsync.when(
              loading: () => DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Center(
                  child: CircularProgressIndicator(color: AppColors.primary),
                ),
              ),
              error: (err, stack) => DrawerHeader(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surface,
                ),
                child: Center(child: Text('خطأ: $err')),
              ),
              data: (profile) => DrawerHeaderView(profile: profile),
            ),

            const Divider(height: 1, color: AppColors.outlineVariant),

            // Scrollable Menu Items
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(vertical: 12),
                children: [
                  DrawerItem(
                    icon: Icons.grid_view,
                    title: 'الرئيسية',
                    path: '/home',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/home');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.inventory_2_outlined,
                    title: 'المنتجات',
                    path: '/products',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/products');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.shopping_cart_outlined,
                    title: 'الطلبات',
                    path: '/orders',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/orders');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.forum_outlined,
                    title: 'مركز الرسائل',
                    path: '/messages',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/messages');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.description_outlined,
                    title: 'عروض الأسعار',
                    path: '/quotes',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/quotations');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.handshake_outlined,
                    title: 'الاتفاقيات',
                    path: '/agreements',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/agreements');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.local_shipping_outlined,
                    title: 'الشحن',
                    path: '/shipping',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/shipping');
                    },
                  ),

                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 8.0,
                    ),
                    child: Divider(height: 1, color: AppColors.outlineVariant),
                  ),

                  DrawerItem(
                    icon: Icons.groups_outlined,
                    title: 'العملاء',
                    path: '/customers',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/customers');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.account_balance_wallet_outlined,
                    title: 'الإدارة المالية',
                    path: '/finance',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/finance');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.card_membership_outlined,
                    title: 'الاشتراكات والفوترة',
                    path: '/subscription',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/subscription');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.analytics_outlined,
                    title: 'التقارير والإحصائيات',
                    path: '/reports',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.go('/reports');
                    },
                  ),
                  DrawerItem(
                    icon: Icons.history_toggle_off_rounded,
                    title: 'سجل العمليات والنشاط',
                    path: '/operations-log',
                    currentRoute: currentRoute,
                    onTap: () {
                      Navigator.pop(context);
                      context.push('/operations-log');
                    },
                  ),
                ],
              ),
            ),

            const Divider(height: 1, color: AppColors.outlineVariant),

            // Bottom Settings & Actions
            const DrawerBottomView(),
          ],
        ),
      ),
    );
  }
}

