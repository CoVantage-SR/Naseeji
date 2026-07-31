import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/usage_progress_card.dart';

class UsageLimitsScreen extends ConsumerWidget {
  const UsageLimitsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subAsync = ref.watch(activeSubscriptionControllerProvider);
    final usageAsync = ref.watch(subscriptionUsageControllerProvider);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Theme.of(context).colorScheme.surface,
          elevation: 0.5,
          title: Text(
            'تفاصيل استهلاك الموارد',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: subAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (sub) => usageAsync.when(
              loading: () => Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('خطأ: $e')),
              data: (usage) {
                // Hardcode starter capacity limits as standard for Starter plan
                final double maxProducts = sub.planId == 'free' ? 10.0 : 50.0;
                final double maxAds = sub.planId == 'free' ? 1.0 : 5.0;
                final double maxFeatured = sub.planId == 'free' ? 0.0 : 3.0;
                final double maxStorage = sub.planId == 'free' ? 1.0 : 5.0;
                final double maxEmployees = sub.planId == 'free' ? 1.0 : 5.0;
                final double maxBranches = sub.planId == 'free' ? 1.0 : 2.0;
                final double maxCampaigns = sub.planId == 'free' ? 1.0 : 10.0;
                final double maxCoupons = sub.planId == 'free' ? 2.0 : 20.0;
                final double maxNotifs = sub.planId == 'free' ? 50.0 : 1000.0;
                final double maxReports = sub.planId == 'free' ? 0.0 : 20.0;

                return SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'مؤشر الطاقة الاستيعابية والحدود الحالية للمنشأة',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(height: 16),

                      UsageProgressCard(
                        title: 'كتالوج المنتجات وخامات النسيج المضافة',
                        usedValue: usage.productsUsed.toDouble(),
                        maxValue: maxProducts,
                        unit: 'منتج',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'الإعلانات الممولة النشطة الجارية بالمنصة',
                        usedValue: usage.advertisementsUsed.toDouble(),
                        maxValue: maxAds,
                        unit: 'إعلان',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'المنتجات المميزة بالظهور في الصفحة الأولى',
                        usedValue: usage.featuredProductsUsed.toDouble(),
                        maxValue: maxFeatured,
                        unit: 'منتج مروج',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'مساحة تخزين الملفات والتصاميم المرفوعة',
                        usedValue: usage.storageUsedGb,
                        maxValue: maxStorage,
                        unit: 'جيجابايت',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'الموظفون الإضافيون للمبيعات والعمليات',
                        usedValue: usage.employeesUsed.toDouble(),
                        maxValue: maxEmployees,
                        unit: 'موظف',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'الفروع ومخازن خامات المنشأة',
                        usedValue: usage.branchesUsed.toDouble(),
                        maxValue: maxBranches,
                        unit: 'فرع مخزن',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'الحملات التسويقية المفتوحة شهرياً',
                        usedValue: usage.campaignsUsed.toDouble(),
                        maxValue: maxCampaigns,
                        unit: 'حملة',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'كوبونات الخصم النشطة للمصانع',
                        usedValue: usage.couponsUsed.toDouble(),
                        maxValue: maxCoupons,
                        unit: 'كوبون',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'إشعارات البث الحصري لعملاء B2B',
                        usedValue: usage.notificationsUsed.toDouble(),
                        maxValue: maxNotifs,
                        unit: 'رسالة إشعار',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                      UsageProgressCard(
                        title: 'تقارير الأداء المالي واستشارات النمو',
                        usedValue: usage.aiReportsUsed.toDouble(),
                        maxValue: maxReports,
                        unit: 'تقرير تحليل',
                        onUpgrade: () => context.push('/subscription/plans'),
                        onBuyAddon: () => context.push('/subscription/addons'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}



