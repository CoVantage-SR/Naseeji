import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import 'package:naseeji_supplier/features/profile/presentation/controllers/profile_controller.dart';
import 'products_tab.dart';
import 'categories_tab.dart';
import 'inventory_tab.dart';
import 'marketing_tab.dart';
import 'analytics_tab.dart';
import '../widgets/premium_badge.dart';
import '../widgets/vip_feature_guard.dart';

class ProductsModuleScreen extends ConsumerStatefulWidget {
  const ProductsModuleScreen({super.key});

  @override
  ConsumerState<ProductsModuleScreen> createState() => _ProductsModuleScreenState();
}

class _ProductsModuleScreenState extends ConsumerState<ProductsModuleScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: VipFeatureGuard(
          onCancelTap: () => context.go('/home'),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.white,
              elevation: 0.5,
              title: const Text(
                'إدارة المنتجات',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.onSurface),
              ),
              centerTitle: true,
              actions: [
                // Quick VIP toggle for testing
                profileAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (profile) => Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: ChoiceChip(
                      label: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            profile.isVip ? Icons.star : Icons.star_border,
                            size: 14,
                            color: profile.isVip ? Colors.white : AppColors.outline,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            profile.isVip ? 'مورد VIP' : 'ترقية VIP',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: profile.isVip ? Colors.white : AppColors.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                      selected: profile.isVip,
                      selectedColor: const Color(0xFFFFA500),
                      backgroundColor: AppColors.surfaceContainerLow,
                      onSelected: (_) => ref.read(profileControllerProvider.notifier).toggleVipStatus(),
                    ),
                  ),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                isScrollable: true,
                tabAlignment: TabAlignment.start,
                indicatorColor: const Color(0xFF0040E0),
                labelColor: const Color(0xFF0040E0),
                unselectedLabelColor: AppColors.outline,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
                indicatorWeight: 3,
                tabs: const [
                  Tab(text: 'منتجاتنا'),
                  Tab(text: 'التصنيفات'),
                  Tab(text: 'المخزون'),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('التسويق'),
                        SizedBox(width: 6),
                        PremiumBadge(fontSize: 8, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2)),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('التحليلات'),
                        SizedBox(width: 6),
                        PremiumBadge(fontSize: 8, padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                const ProductsTab(),
                const CategoriesTab(),
                const InventoryTab(),
                MarketingTab(onCancelVip: () => _tabController.animateTo(0)),
                AnalyticsTab(onCancelVip: () => _tabController.animateTo(0)),
              ],
            ),
          ),
        ),
        bottomNavigationBar: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppBottomNavigationBar(currentIndex: 1),
        ),
      ),
    );
  }
}
