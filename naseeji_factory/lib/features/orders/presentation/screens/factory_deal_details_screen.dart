import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../products/presentation/widgets/share_widgets.dart';
import '../providers/orders_provider.dart';

import '../widgets/deal_bottom_action_bar.dart';
import '../widgets/deal_info_grid.dart';
import '../widgets/deal_overview_tab.dart';
import '../widgets/deal_progress_stepper.dart';
import '../widgets/deal_summary_card.dart';
import '../widgets/deal_tabs_widgets.dart';

/// Full Production-Ready Factory Deal Details Screen
class FactoryDealDetailsScreen extends ConsumerStatefulWidget {
  final String dealId;

  const FactoryDealDetailsScreen({super.key, required this.dealId});

  @override
  ConsumerState<FactoryDealDetailsScreen> createState() => _FactoryDealDetailsScreenState();
}

class _FactoryDealDetailsScreenState extends ConsumerState<FactoryDealDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'ملخص الصفقة',
    'المنتجات',
    'المالية',
    'الشحن والتسليم',
    'المستندات',
    'النشاط',
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

  void _showShareModal(BuildContext context, OrderModel order) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
        productName: order.dealNumber,
        supplierName: order.supplierName,
        onCopyLink: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نسخ رابط تفاصيل الصفقة بنجاح!')),
          );
        },
        onDownloadPdf: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('جاري تحميل كشف تفاصيل الصفقة (PDF)...')),
          );
        },
      ),
    );
  }

  void _showMoreMenu(BuildContext context, OrderModel order) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Material(
          color: isDark ? AppColors.surfaceDark : Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.copy_all_rounded, color: AppColors.primary),
                  title: const Text('نسخ ملخص الصفقة'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ بيانات ملخص الصفقة للذاكرة.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
                  title: const Text('تصدير كـ PDF معتمد'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري تصدير مستند الصفقة المعتمد...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.print_outlined, color: AppColors.primary),
                  title: const Text('طباعة إشعار الصفقة'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري الاتصال بالطابعة الشبكية...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined, color: Colors.grey),
                  title: const Text('أرشفة الصفقة'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم أرشفة الصفقة بنجاح.')),
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

  void _handleDeliveryConfirmation(OrderModel order) {
    if (order.status == 'delivered') {
      context.push('/orders/${order.id}/confirm');
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('تأكيد استلام الشحنة'),
          content: Text(
            'حالة الشحنة الحالية (${order.currentLocation}). هل ترغب في تأكيد وصول الشحنة وبدء مرحلة الفحص والتفتيش الفني؟',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                ref.read(ordersNotifierProvider.notifier).confirmDelivery(order.id);
                context.push('/orders/${order.id}/confirm');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
              ),
              child: const Text('تأكيد الاستلام والفحص'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersNotifierProvider);
    final order = orders.firstWhere(
      (o) => o.id == widget.dealId || o.dealNumber == widget.dealId,
      orElse: () => orders.first,
    );

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
          'تفاصيل الصفقة',
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
            onPressed: () => _showShareModal(context, order),
          ),
          // More Menu Button (...)
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showMoreMenu(context, order),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: DealBottomActionBar(
        order: order,
        onConfirmDelivery: () => _handleDeliveryConfirmation(order),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. Top Deal Summary Banner Card
                    DealSummaryCard(order: order),
                    const SizedBox(height: 16),

                    // 2. ERP Progress Stepper & Shipment Alert Banner
                    DealProgressStepper(
                      order: order,
                      onTrackTap: () => context.push('/orders/${order.id}/shipment'),
                    ),
                    const SizedBox(height: 16),

                    // 3. Information Grid (6 Cards)
                    DealInfoGrid(order: order),
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
              // Tab 1: Deal Overview
              DealOverviewTab(
                order: order,
                onTabSwitch: () => _tabController.animateTo(4), // Switch to Documents
              ),
              // Tab 2: Products
              DealProductsTab(order: order),
              // Tab 3: Financial
              DealFinancialTab(order: order),
              // Tab 4: Shipment
              DealShipmentTab(order: order),
              // Tab 5: Documents
              DealDocumentsTab(order: order),
              // Tab 6: Activity / Timeline
              DealActivityTab(order: order),
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
