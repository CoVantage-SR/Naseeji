import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../presentation/widgets/subscription_usage_card.dart';
import '../../../subscription/presentation/controllers/subscription_controllers.dart';

class ProductUsageScreen extends ConsumerWidget {
  const ProductUsageScreen({super.key});

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
            'تفاصيل استهلاك الموارد والحدود B2B',
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
                // Compute standard limits
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
                        'دورة الفوترة الحالية تنتهي بتاريخ: ${sub.expiryDate.year}/${sub.expiryDate.month.toString().padLeft(2, '0')}/${sub.expiryDate.day.toString().padLeft(2, '0')}',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 16),

                      SubscriptionUsageCard(
                        title: 'المنتجات وخامات التوريد المضافة',
                        used: usage.productsUsed.toDouble(),
                        max: maxProducts,
                        unit: 'منتج',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'مقاطع الفيديو والوسائط التوضيحية المرفوعة',
                        used: usage.aiReportsUsed.toDouble(), // Simulated video counts
                        max: maxReports,
                        unit: 'فيديو',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'كتالوجات وملفات الـ PDF المتاحة للمصانع',
                        used: usage.branchesUsed.toDouble(), // Simulated catalog counts
                        max: maxBranches,
                        unit: 'ملف كتالوج',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'الإعلانات الممولة النشطة الجارية',
                        used: usage.advertisementsUsed.toDouble(),
                        max: maxAds,
                        unit: 'إعلان',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'المنتجات المميزة والرعايات بالصدارة',
                        used: usage.featuredProductsUsed.toDouble(),
                        max: maxFeatured,
                        unit: 'منتج مميز',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'مساحة تخزين الملفات والتصاميم المرفوعة',
                        used: usage.storageUsedGb,
                        max: maxStorage,
                        unit: 'جيجابايت',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'الموظفون الإضافيون والحسابات الفرعية للمبيعات',
                        used: usage.employeesUsed.toDouble(),
                        max: maxEmployees,
                        unit: 'موظف',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'الحملات التسويقية والخصومات المفتوحة',
                        used: usage.campaignsUsed.toDouble(),
                        max: maxCampaigns,
                        unit: 'حملة تسويقية',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'كوبونات الخصم النشطة الفعالة بالمنصة',
                        used: usage.couponsUsed.toDouble(),
                        max: maxCoupons,
                        unit: 'كوبون خصم',
                        onActionTap: () => Navigator.pop(context),
                      ),
                      SubscriptionUsageCard(
                        title: 'إشعارات البث الحصري للمشترين والمصانع',
                        used: usage.notificationsUsed.toDouble(),
                        max: maxNotifs,
                        unit: 'رسالة بث',
                        onActionTap: () => Navigator.pop(context),
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



