import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../products/presentation/widgets/share_widgets.dart';
import '../providers/rfq_provider.dart';

import '../widgets/rfq_bottom_action_bar.dart';
import '../widgets/rfq_header_card.dart';
import '../widgets/rfq_info_grid.dart';
import '../widgets/rfq_status_stepper.dart';
import '../widgets/rfq_suppliers_offers_summary.dart';
import '../widgets/rfq_tabs_widgets.dart';

/// Full Production-Ready RFQ Details Screen matching Reference Image 1
class RFQDetailsScreen extends ConsumerStatefulWidget {
  final String rfqId;

  const RFQDetailsScreen({super.key, required this.rfqId});

  @override
  ConsumerState<RFQDetailsScreen> createState() => _RFQDetailsScreenState();
}

class _RFQDetailsScreenState extends ConsumerState<RFQDetailsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final List<String> _tabs = [
    'تفاصيل الطلب',
    'المواصفات',
    'المرفقات',
    'شروط الطلب',
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

  void _showShareModal(BuildContext context, RFQ rfq) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ShareProductBottomSheet(
        productName: rfq.rfqNumber,
        supplierName: rfq.title,
        onCopyLink: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('تم نسخ رابط طلب عرض السعر (RFQ) بنجاح!')),
          );
        },
        onDownloadPdf: () {
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('جاري تحميل كشف المواصفات والطلب (PDF)...')),
          );
        },
      ),
    );
  }

  void _showMoreMenu(BuildContext context, RFQ rfq) {
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
                  title: const Text('تكرار طلب عرض السعر (Duplicate RFQ)'),
                  onTap: () {
                    Navigator.pop(context);
                    context.push('/rfq/create');
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.picture_as_pdf_outlined, color: AppColors.primary),
                  title: const Text('تصدير المواصفات والطلب كـ PDF'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('جاري تصدير ملف الـ RFQ المعتمد...')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.archive_outlined, color: Colors.grey),
                  title: const Text('أرشفة الطلب'),
                  onTap: () {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نقل طلب RFQ إلى الأرشيف.')),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.cancel_outlined, color: AppColors.error),
                  title: const Text('إلغاء طلب عرض السعر'),
                  onTap: () {
                    Navigator.pop(context);
                    _confirmCancelRFQ(rfq);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmCancelRFQ(RFQ rfq) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('إلغاء طلب RFQ'),
        content: Text('هل أنت أربك في إلغاء طلب عرض السعر (${rfq.rfqNumber})؟ سيتم إشعار الموردين بالإلغاء.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('تراجع')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(rFQNotifierProvider.notifier).cancelRFQ(rfq.id);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('تم إلغاء طلب عرض السعر بنجاح.')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error, foregroundColor: Colors.white),
            child: const Text('تأكيد الإلغاء'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rfqs = ref.watch(rFQNotifierProvider);
    final rfq = rfqs.firstWhere(
      (r) => r.id == widget.rfqId || r.rfqNumber == widget.rfqId,
      orElse: () => rfqs.first,
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
          'تفاصيل طلب RFQ',
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
            onPressed: () => _showShareModal(context, rfq),
          ),
          // More Menu Button (...)
          IconButton(
            icon: const Icon(Icons.more_vert_rounded),
            onPressed: () => _showMoreMenu(context, rfq),
          ),
          const SizedBox(width: 4),
        ],
      ),
      bottomNavigationBar: RFQBottomActionBar(
        rfq: rfq,
        onEditTap: () => context.push('/rfq/create'),
        onMoreTap: () => _showMoreMenu(context, rfq),
      ),
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    // 1. RFQ Header Summary Card
                    RFQHeaderCard(rfq: rfq),
                    const SizedBox(height: 16),

                    // 2. Status Stepper Bar (5 Steps)
                    RFQStatusStepper(rfq: rfq),
                    const SizedBox(height: 16),

                    // 3. Information Section (6 Cards)
                    RFQInfoGrid(rfq: rfq),
                    const SizedBox(height: 16),

                    // 4. Suppliers & Offers Metric Bar + Latest Offers List
                    RFQSuppliersOffersSummary(rfq: rfq),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            // 5. Sticky TabBar Header
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
              // Tab 1: RFQ Details / Description
              RFQDetailsTab(rfq: rfq),
              // Tab 2: Specs
              RFQSpecsTab(rfq: rfq),
              // Tab 3: Attachments
              RFQAttachmentsTab(rfq: rfq),
              // Tab 4: Terms
              RFQTermsTab(rfq: rfq),
              // Tab 5: Activity
              RFQActivityTab(rfq: rfq),
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
