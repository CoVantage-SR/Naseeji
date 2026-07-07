import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/features/profile/presentation/controllers/profile_controller.dart';
import 'products_tab.dart';
import 'categories_tab.dart';
import 'inventory_tab.dart';
import 'marketing_tab.dart';
import 'analytics_tab.dart';

class ProductsModuleScreen extends ConsumerStatefulWidget {
  const ProductsModuleScreen({super.key});

  @override
  ConsumerState<ProductsModuleScreen> createState() => _ProductsModuleScreenState();
}

class _ProductsModuleScreenState extends ConsumerState<ProductsModuleScreen> {
  int _currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    final profileAsync = ref.watch(profileControllerProvider);

    final tabs = [
      const ProductsTab(),
      const CategoriesTab(),
      const InventoryTab(),
      MarketingTab(onCancelVip: () => setState(() => _currentTabIndex = 0)),
      AnalyticsTab(onCancelVip: () => setState(() => _currentTabIndex = 0)),
    ];

    final titles = [
      'منتجاتنا',
      'التصنيفات',
      'المخزون والكميات',
      'التسويق والترويج',
      'التحليلات والتقارير',
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0.5,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.onSurface),
            onPressed: () => context.go('/home'),
          ),
          title: Text(
            titles[_currentTabIndex],
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.onSurface),
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
        ),
        body: tabs[_currentTabIndex],
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              indicatorColor: const Color(0xFF0040E0).withValues(alpha: 0.15),
              indicatorShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              labelTextStyle: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0040E0),
                  );
                }
                return const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.outline,
                );
              }),
            ),
            child: NavigationBar(
              height: 65,
              backgroundColor: Colors.white,
              elevation: 0,
              selectedIndex: _currentTabIndex,
              onDestinationSelected: (index) => setState(() => _currentTabIndex = index),
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.category_outlined, color: AppColors.outline),
                  selectedIcon: Icon(Icons.category, color: Color(0xFF0040E0)),
                  label: 'المنتجات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.folder_open_outlined, color: AppColors.outline),
                  selectedIcon: Icon(Icons.folder, color: Color(0xFF0040E0)),
                  label: 'التصنيفات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.inventory_2_outlined, color: AppColors.outline),
                  selectedIcon: Icon(Icons.inventory_2, color: Color(0xFF0040E0)),
                  label: 'المخزون',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('VIP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                    backgroundColor: Color(0xFFFFA500),
                    child: Icon(Icons.campaign_outlined, color: AppColors.outline),
                  ),
                  selectedIcon: Badge(
                    label: Text('VIP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                    backgroundColor: Color(0xFFFFA500),
                    child: Icon(Icons.campaign, color: Color(0xFF0040E0)),
                  ),
                  label: 'التسويق',
                ),
                NavigationDestination(
                  icon: Badge(
                    label: Text('VIP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                    backgroundColor: Color(0xFFFFA500),
                    child: Icon(Icons.analytics_outlined, color: AppColors.outline),
                  ),
                  selectedIcon: Badge(
                    label: Text('VIP', style: TextStyle(fontSize: 8, fontWeight: FontWeight.w900, color: Colors.white)),
                    backgroundColor: Color(0xFFFFA500),
                    child: Icon(Icons.analytics, color: Color(0xFF0040E0)),
                  ),
                  label: 'التحليلات',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
