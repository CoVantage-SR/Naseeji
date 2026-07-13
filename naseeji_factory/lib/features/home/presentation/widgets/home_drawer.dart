import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/mini_profile_provider.dart';
import 'drawer_widgets.dart';

class HomeDrawer extends ConsumerWidget {
  final String currentRoute;

  const HomeDrawer({super.key, this.currentRoute = '/home'});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profile = ref.watch(miniProfileNotifierProvider);

    void navigate(String route) {
      context.pop(); // close drawer
      if (route == '/home' || route == '/products' || route == '/rfq' || route == '/orders' || route == '/profile') {
        context.go(route);
      } else {
        context.push(route);
      }
    }

    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            const DrawerHeaderWidget(),
            ProfileSummaryWidget(
              name: profile.name,
              legalEntity: profile.legalEntity,
              onTap: () => navigate('/mini-profile'),
            ),
            const Divider(height: 1),
            Expanded(
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerItemWidget(
                    title: 'الرئيسية',
                    icon: Icons.dashboard_rounded,
                    isSelected: currentRoute == '/home',
                    onTap: () => navigate('/home'),
                  ),
                  DrawerItemWidget(
                    title: 'المنتجات',
                    icon: Icons.shopping_bag_outlined,
                    isSelected: currentRoute == '/products',
                    onTap: () => navigate('/products'),
                  ),
                  DrawerItemWidget(
                    title: 'الموردين',
                    icon: Icons.people_outline_rounded,
                    isSelected: currentRoute == '/suppliers',
                    onTap: () => navigate('/search?type=suppliers'),
                  ),
                  DrawerItemWidget(
                    title: 'طلبات عروض الأسعار',
                    icon: Icons.request_quote_outlined,
                    isSelected: currentRoute == '/rfq',
                    onTap: () => navigate('/rfq'),
                  ),
                  DrawerItemWidget(
                    title: 'الطلبات',
                    icon: Icons.receipt_long_outlined,
                    isSelected: currentRoute == '/orders',
                    onTap: () => navigate('/orders'),
                  ),
                  DrawerItemWidget(
                    title: 'المحادثات',
                    icon: Icons.chat_bubble_outline_rounded,
                    isSelected: currentRoute == '/chat',
                    onTap: () => navigate('/chat'),
                  ),
                  DrawerItemWidget(
                    title: 'الموردين المفضلين',
                    icon: Icons.favorite_border_rounded,
                    isSelected: currentRoute == '/favorites',
                    onTap: () => navigate('/search?type=suppliers&favorites=true'),
                  ),
                  DrawerItemWidget(
                    title: 'سجل المشتريات',
                    icon: Icons.history_rounded,
                    isSelected: currentRoute == '/purchase-history',
                    onTap: () => navigate('/statistics'),
                  ),
                  DrawerItemWidget(
                    title: 'التقارير والإحصائيات',
                    icon: Icons.analytics_outlined,
                    isSelected: currentRoute == '/statistics',
                    onTap: () => navigate('/statistics'),
                  ),
                  DrawerItemWidget(
                    title: 'الإعدادات',
                    icon: Icons.settings_outlined,
                    isSelected: currentRoute == '/settings',
                    onTap: () => navigate('/settings'),
                  ),
                  const Divider(),
                  DrawerItemWidget(
                    title: 'الدعم الفني',
                    icon: Icons.support_agent_rounded,
                    onTap: () => navigate('/notifications'),
                  ),
                  DrawerItemWidget(
                    title: 'الشروط والأحكام',
                    icon: Icons.description_outlined,
                    onTap: () {},
                  ),
                  DrawerItemWidget(
                    title: 'سياسة الخصوصية',
                    icon: Icons.privacy_tip_outlined,
                    onTap: () {},
                  ),
                ],
              ),
            ),
            LogoutButtonWidget(
              onTap: () {
                context.pop();
                context.go('/login');
              },
            ),
          ],
        ),
      ),
    );
  }
}
