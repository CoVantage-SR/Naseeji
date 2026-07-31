import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../../../products/presentation/providers/products_provider.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';
import '../../../products/presentation/widgets/share_widgets.dart';
import '../widgets/supplier_header_card.dart';

import '../widgets/supplier_overview_tab.dart';
import '../widgets/supplier_primary_actions.dart';
import '../widgets/supplier_stats_cards.dart';
import '../widgets/supplier_tabs_widgets.dart';

/// Full Production-Ready Factory Supplier Details Screen
class FactorySupplierDetailsScreen extends ConsumerStatefulWidget {
  final String supplierId;

  const FactorySupplierDetailsScreen({super.key, required this.supplierId});

  @override
  ConsumerState<FactorySupplierDetailsScreen> createState() => _FactorySupplierDetailsScreenState();
}

class _FactorySupplierDetailsScreenState extends ConsumerState<FactorySupplierDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'نبذة عن المورد',
    'المنتجات',
    'الشهادات',
    'التقييمات',
    'المعلومات التجارية',
    'معلومات الشركة',
    'الصفقات المكتملة',
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _tabs.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _showShareModal(BuildContext context, Supplier supplier) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
        productName: supplier.name,
        supplierName: supplier.type,
        onCopyLink: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نسخ رابط الملف الشخصي للمورد بنجاح!')),
          );
        },
        onDownloadPdf: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('جاري تحميل الملف التعريفي الخاص بالمورد (PDF)...')),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final suppliers = ref.watch(suppliersNotifierProvider);
    final supplier = suppliers.firstWhere(
      (s) => s.id == widget.supplierId,
      orElse: () => suppliers.first,
    );

    final allProducts = ref.watch(productsNotifierProvider);
    final supplierProducts = allProducts.where((p) => p.supplierId == supplier.id).toList();

    // Default product for RFQ action fallback
    final defaultProduct = supplierProducts.isNotEmpty ? supplierProducts.first : allProducts.first;

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;
    final appBarTextColor = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    return Scaffold(
      backgroundColor: isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
        foregroundColor: appBarTextColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        iconTheme: IconThemeData(color: appBarTextColor),
        title: Text(
          'تفاصيل المورد',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: appBarTextColor,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_rounded, color: appBarTextColor),
          onPressed: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              context.go('/home');
            }
          },
        ),
        actions: [
          // Share Button
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showShareModal(context, supplier),
          ),
          // Favorite Toggle Button
          IconButton(
            icon: Icon(
              supplier.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: supplier.isFavorite ? AppColors.error : null,
            ),
            onPressed: () {
              checkGuestAction(
                context,
                ref,
                () {
                  ref.read(suppliersNotifierProvider.notifier).toggleFavorite(supplier.id);
                  final isFavNow = !supplier.isFavorite;
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        isFavNow
                            ? 'تم إضافة ${supplier.name} إلى قائمة المفضلة'
                            : 'تم إزالة ${supplier.name} من المفضلة',
                      ),
                    ),
                  );
                },
              );
            },
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Supplier Header Card
                    SupplierHeaderCard(supplier: supplier),
                    const SizedBox(height: 16),

                    // 2. 5 Statistics Cards Bar
                    SupplierStatsCards(
                      supplier: supplier,
                      onStatTap: (index) {
                        _tabController.animateTo(index);
                      },
                    ),
                    const SizedBox(height: 16),

                    // 3. Primary Actions Grid
                    SupplierPrimaryActions(
                      supplier: supplier,
                      defaultProduct: defaultProduct,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // 4. Sticky TabBar Header
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverTabBarDelegate(
                TabBar(
                  controller: _tabController,
                  isScrollable: true,
                  labelColor: primaryColor,
                  unselectedLabelColor: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
                  indicatorColor: primaryColor,
                  indicatorWeight: 3,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  tabs: _tabs.map((t) => Tab(text: t)).toList(),
                ),
                backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
              ),
            ),
          ];
        },
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: TabBarView(
            controller: _tabController,
            children: [
              // Tab 1: Overview
              SupplierOverviewTab(
                supplier: supplier,
                onCategoryTap: () => _tabController.animateTo(1),
              ),
              // Tab 2: Products
              SupplierProductsTab(supplier: supplier, products: supplierProducts),
              // Tab 3: Certificates
              SupplierCertificatesTab(supplier: supplier),
              // Tab 4: Reviews
              SupplierReviewsTab(supplier: supplier),
              // Tab 5: Commercial Information
              SupplierCommercialInfoTab(supplier: supplier),
              // Tab 6: Company Information
              SupplierCompanyInfoTab(supplier: supplier),
              // Tab 7: Completed Deals
              SupplierCompletedDealsTab(supplier: supplier),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar tabBar;
  final Color backgroundColor;

  _SliverTabBarDelegate(this.tabBar, {required this.backgroundColor});

  @override
  double get minExtent => tabBar.preferredSize.height;
  @override
  double get maxExtent => tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: backgroundColor,
      child: tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return tabBar != oldDelegate.tabBar || backgroundColor != oldDelegate.backgroundColor;
  }
}



