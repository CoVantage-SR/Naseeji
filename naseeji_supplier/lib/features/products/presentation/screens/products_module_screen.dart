import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'package:naseeji_supplier/core/widgets/app_bottom_navigation_bar.dart';
import 'package:naseeji_supplier/core/widgets/general_widgets.dart';
import 'products_tab.dart';
import 'categories_tab.dart';
import 'inventory_tab.dart';
import 'marketing_tab.dart';
import 'analytics_tab.dart';
import '../widgets/premium_badge.dart';
import '../widgets/subscription_required_widget.dart';
import '../../../subscription/presentation/controllers/subscription_controllers.dart';
import '../../../subscription/domain/entities/subscription_models.dart';

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
    final subAsync = ref.watch(activeSubscriptionControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: subAsync.when(
          loading: () => Center(child: CircularProgressIndicator()),
          error: (e, _) => Center(child: Text('خطأ: $e')),
          data: (sub) {
            // Case 1: No subscription (or free plan if we require subscription)
            if (sub.planId == 'free' || sub.planId.isEmpty) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0.5,
                  title: Text(
                    'إدارة المنتجات',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () => context.go('/home'),
                  ),
                ),
                body: SubscriptionRequiredWidget(
                  onChoosePlan: () => context.push('/subscription/plans'),
                ),
              );
            }

            // Case 2: Subscription Expired
            if (sub.status == SubscriptionStatus.expired) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0.5,
                  title: Text(
                    'الاشتراك منتهي الصلاحية',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () => context.go('/home'),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: const Color(0xFFBA1A1A).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '⚠️',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'اشتراكك منتهي الصلاحية',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'منتجات خامات المنسوجات الخاصة بك مخفية مؤقتاً عن المشترين والمصانع حتى تقوم بتجديد باقة الاشتراك.',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      PrimaryButton(
                        text: 'تجديد الاشتراك الآن',
                        onPressed: () async {
                          await ref.read(activeSubscriptionControllerProvider.notifier).renew();
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم تجديد الباقة وتفعيل المنتجات بنجاح!')),
                            );
                          }
                        },
                      ),
                      SizedBox(height: 12),
                      OutlinedButton(
                        onPressed: () => context.push('/subscription/plans'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0040E0),
                          side: const BorderSide(color: Color(0xFF0040E0)),
                          minimumSize: const Size.fromHeight(56),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text('مقارنة الخطط والباقات B2B', style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
                ),
              );
            }

            // Case 3: Suspended
            if (sub.status == SubscriptionStatus.cancelled || sub.status == SubscriptionStatus.pending) {
              return Scaffold(
                appBar: AppBar(
                  backgroundColor: Theme.of(context).colorScheme.surface,
                  elevation: 0.5,
                  title: Text(
                    'الاشتراك معلق',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                  ),
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
                    onPressed: () => context.go('/home'),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Container(
                        height: 100,
                        decoration: BoxDecoration(
                          color: AppColors.outline.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '🚫',
                            style: TextStyle(fontSize: 40),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        'تم تعليق الاشتراك',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 12),
                      Text(
                        'لقد تم تعطيل إدارة ونشر المنتجات للمؤسسة مؤقتاً لوجود مستحقات مالية معلقة أو بطلب الإدارة. يرجى مراجعة الدعم الفني.',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.5),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 32),
                      PrimaryButton(
                        text: 'التواصل مع الدعم الفني لنسيجي',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('تم إرسال طلب تواصل للدعم الفني وسيتصل بك أحد ممثلينا قريباً.')),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            // Case 4: Subscription Active
            return Scaffold(
              appBar: AppBar(
                backgroundColor: Theme.of(context).colorScheme.surface,
                elevation: 0.5,
                title: Text(
                  'إدارة المنتجات',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
                ),
                centerTitle: true,
                actions: [
                  Padding(
                    padding: const EdgeInsets.only(left: 8, top: 12, bottom: 12),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF0040E0).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        sub.planName,
                        style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Color(0xFF0040E0)),
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
                  labelStyle: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  unselectedLabelStyle: TextStyle(fontWeight: FontWeight.w600, fontSize: 12),
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
            );
          },
        ),
        bottomNavigationBar: const Directionality(
          textDirection: TextDirection.ltr,
          child: AppBottomNavigationBar(currentIndex: 1),
        ),
      ),
    );
  }
}
