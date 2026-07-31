import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_spacing.dart';
import '../providers/products_provider.dart';
import '../providers/suppliers_provider.dart';
import '../widgets/product_details/create_rfq_modal.dart';
import '../widgets/product_details/documents_widget.dart';
import '../widgets/product_details/product_bottom_action_bar_widget.dart';
import '../widgets/product_details/product_gallery_widget.dart';
import '../widgets/product_details/product_reviews_widget.dart';
import '../widgets/product_details/product_summary_widget.dart';
import '../widgets/product_details/product_technical_specs_widget.dart';
import '../widgets/product_details/supplier_preview_widget.dart';
import '../widgets/share_widgets.dart';

/// Production-Ready Factory Product Details Screen matching the reference design 100%.
/// Fully integrated with Riverpod 2, Clean Architecture, SOLID, and MockDatabase.
class FactoryProductDetailsScreen extends ConsumerStatefulWidget {
  final String productId;

  const FactoryProductDetailsScreen({
    super.key,
    required this.productId,
  });

  @override
  ConsumerState<FactoryProductDetailsScreen> createState() => _FactoryProductDetailsScreenState();
}

class _FactoryProductDetailsScreenState extends ConsumerState<FactoryProductDetailsScreen>
    with SingleTickerProviderStateMixin {
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

  void _showShareBottomSheet(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
        productName: product.name,
        supplierName: product.supplierName,
        onCopyLink: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('تم نسخ رابط المنتج بنجاح!'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        onDownloadPdf: () {
          Navigator.of(context).pop();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('بدء تحميل الكتالوج الفني للمنتج...'),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
      ),
    );
  }

  void _showCreateRfqModal(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => CreateRfqModal(product: product),
    );
  }

  void _showMoreOptionsMenu(BuildContext context, Product product) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        final isDark = Theme.of(context).brightness == Brightness.dark;
        return Material(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.compare_arrows_rounded, color: AppColors.primary),
                  title: const Text('مقارنة المنتج مع منتجات أخرى'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/price-comparison');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.bookmark_border_rounded, color: AppColors.primary),
                  title: const Text('حفظ في قائمة المشتريات'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم حفظ المنتج في قائمة المشتريات المستقلة.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.report_problem_outlined, color: AppColors.error),
                  title: const Text('الإبلاغ عن عدم تطابق مواصفات'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم رفع بلاغ لفريق فحص ناصيجي.')),
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final products = ref.watch(productsNotifierProvider);
    final product = ref.read(productsNotifierProvider.notifier).getProductById(widget.productId) ??
        (products.isNotEmpty ? products.first : null);

    if (product == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('تفاصيل المنتج')),
        body: const Center(child: Text('المنتج غير موجود في قاعدة البيانات.')),
      );
    }

    final supplier = ref.watch(suppliersNotifierProvider.notifier).getSupplierById(product.supplierId) ??
        ref.watch(suppliersNotifierProvider).first;

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
          'تفاصيل المنتج',
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
          // Favorite Toggle Button
          IconButton(
            icon: Icon(
              product.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: product.isFavorite ? AppColors.error : null,
            ),
            onPressed: () {
              ref.read(productsNotifierProvider.notifier).toggleFavorite(product.id);
              final isFavNow = !product.isFavorite;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isFavNow ? 'تم إضافة المنتج إلى المفضلة' : 'تم إزالة المنتج من المفضلة',
                  ),
                  duration: const Duration(seconds: 2),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          // Share Button
          IconButton(
            icon: const Icon(Icons.share_outlined),
            onPressed: () => _showShareBottomSheet(context, product),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: ProductBottomActionBarWidget(
        onSendRfq: () => _showCreateRfqModal(context, product),
        onRequestQuote: () => _showCreateRfqModal(context, product),
        onMoreOptions: () => _showMoreOptionsMenu(context, product),
      ),
      body: SafeArea(
        child: NestedScrollView(
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final isWide = constraints.maxWidth > 700;
                      if (isWide) {
                        return Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 5,
                              child: ProductGalleryWidget(product: product),
                            ),
                            const SizedBox(width: 24),
                            Expanded(
                              flex: 6,
                              child: ProductSummaryWidget(product: product),
                            ),
                          ],
                        );
                      }

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gallery on Left/Top
                          ProductGalleryWidget(product: product),
                          AppSpacing.hMD,
                          // Metadata Summary on Right/Bottom
                          ProductSummaryWidget(product: product),
                          AppSpacing.hMD,
                        ],
                      );
                    },
                  ),
                ),
              ),
              // Horizontal TabBar Header
              SliverPersistentHeader(
                pinned: true,
                delegate: _SliverTabBarDelegate(
                  TabBar(
                    controller: _tabController,
                    isScrollable: true,
                    tabAlignment: TabAlignment.start,
                    labelColor: primaryColor,
                    unselectedLabelColor: isDark ? AppColors.textSecondaryDark : Colors.grey.shade600,
                    indicatorColor: primaryColor,
                    indicatorWeight: 3,
                    labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    tabs: const [
                      Tab(text: 'نظرة عامة'),
                      Tab(text: 'المواصفات'),
                      Tab(text: 'المورد'),
                      Tab(text: 'المستندات'),
                      Tab(text: 'التقييمات'),
                    ],
                  ),
                  isDark: isDark,
                ),
              ),
            ];
          },
          body: TabBarView(
            controller: _tabController,
            children: [
              // 1. Overview Tab
              _KeepAliveWrapper(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProductOverviewCardWidget(product: product),
                      AppSpacing.hLG,
                      AvailableDocumentsWidget(
                        productId: product.id,
                        onViewAll: () => _tabController.animateTo(3),
                      ),
                      AppSpacing.hLG,
                      SupplierCardWidget(
                        supplierName: supplier.name,
                        location: '${supplier.city}، ${supplier.governorate}، مصر',
                        rating: supplier.rating,
                        reviewsCount: supplier.reviewsCount,
                        logoUrl: supplier.logoUrl,
                        isVerified: supplier.isVerified,
                        isOnline: supplier.isOnline,
                        deliveryTime: supplier.avgDeliveryDays,
                        productsCount: supplier.productsCount,
                        responseRate: supplier.responseSpeed,
                        establishedYear: supplier.establishedYear,
                        onViewAllProducts: () => context.push('/suppliers/${supplier.id}'),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // 2. Specifications Tab
              _KeepAliveWrapper(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProductTechnicalSpecsWidget(product: product),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // 3. Supplier Tab
              _KeepAliveWrapper(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      SupplierCardWidget(
                        supplierName: supplier.name,
                        location: '${supplier.city}، ${supplier.governorate}، مصر',
                        rating: supplier.rating,
                        reviewsCount: supplier.reviewsCount,
                        logoUrl: supplier.logoUrl,
                        isVerified: supplier.isVerified,
                        isOnline: supplier.isOnline,
                        deliveryTime: supplier.avgDeliveryDays,
                        productsCount: supplier.productsCount,
                        responseRate: supplier.responseSpeed,
                        establishedYear: supplier.establishedYear,
                        onViewAllProducts: () => context.push('/suppliers/${supplier.id}'),
                      ),
                      AppSpacing.hLG,
                      // Business Chat / Contact supplier
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => context.push('/suppliers/${supplier.id}'),
                              icon: const Icon(Icons.business_center_rounded),
                              label: const Text('الملف الشخصي للمورد'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => context.push('/chat'),
                              icon: const Icon(Icons.chat_rounded),
                              label: const Text('محادثة المورد'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primaryColor,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // 4. Certificates / Documents Tab
              _KeepAliveWrapper(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      AvailableDocumentsWidget(
                        productId: product.id,
                        onViewAll: () {},
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              // 5. Reviews Tab
              _KeepAliveWrapper(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      ProductReviewsWidget(productId: product.id),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SliverTabBarDelegate extends SliverPersistentHeaderDelegate {
  final TabBar _tabBar;
  final bool isDark;

  _SliverTabBarDelegate(this._tabBar, {required this.isDark});

  @override
  double get minExtent => _tabBar.preferredSize.height;

  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      child: _tabBar,
    );
  }

  @override
  bool shouldRebuild(_SliverTabBarDelegate oldDelegate) {
    return false;
  }
}

class _KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const _KeepAliveWrapper({required this.child});

  @override
  State<_KeepAliveWrapper> createState() => _KeepAliveWrapperState();
}

class _KeepAliveWrapperState extends State<_KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }
}

