import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../controllers/subscription_controllers.dart';
import '../widgets/subscription_status_card.dart';
import '../widgets/usage_progress_card.dart';

class SubscriptionDashboardScreen extends ConsumerWidget {
  const SubscriptionDashboardScreen({super.key});

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
            'لوحة الاشتراكات والفوترة B2B',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Theme.of(context).colorScheme.onSurface),
            onPressed: () => context.go('/home'),
          ),
        ),
        body: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: subAsync.when(
            loading: () => Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('خطأ: $e')),
            data: (sub) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Subscription Health Banner
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFF006B5F).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: const Color(0xFF006B5F).withValues(alpha: 0.3)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'حالة الاشتراك: ممتازة',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF006B5F)),
                          ),
                          Text(
                            'متبقي ${sub.remainingDays} يوم على تجديد الخدمة القادم',
                            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Active Subscription Card
                    SubscriptionStatusCard(
                      subscription: sub,
                      onAutoRenewChanged: (val) {
                        ref.read(activeSubscriptionControllerProvider.notifier).toggleAutoRenew(val);
                      },
                      onUpgrade: () => context.push('/subscription/plans'),
                      onRenew: () {
                        ref.read(activeSubscriptionControllerProvider.notifier).renew();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('تم تجديد اشتراك باقتك الحالية بنجاح!')),
                        );
                      },
                    ),
                    SizedBox(height: 24),

                    // Quick Actions
                    Text(
                      'إجراءات سريعة للاشتراك والفوترة',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                      textAlign: TextAlign.right,
                    ),
                    SizedBox(height: 12),
                    _buildQuickActions(context),
                    SizedBox(height: 24),

                    // Usages section
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.push('/subscription/usage'),
                          child: Text('عرض التفاصيل كاملة', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF0040E0))),
                        ),
                        Text(
                          'استهلاك موارد الباقة الحالية',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    usageAsync.when(
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (err, _) => Text('خطأ: $err'),
                      data: (usage) {
                        // starter limits hardcoded for quick dashboard bars
                        return Column(
                          children: [
                            UsageProgressCard(
                              title: 'المنتجات وخامات التوريد المضافة',
                              usedValue: usage.productsUsed.toDouble(),
                              maxValue: sub.planId == 'free' ? 10.0 : 50.0,
                              unit: 'منتج',
                              onUpgrade: () => context.push('/subscription/plans'),
                              onBuyAddon: () => context.push('/subscription/addons'),
                            ),
                            UsageProgressCard(
                              title: 'الإعلانات الممولة الجارية بالمنصة',
                              usedValue: usage.advertisementsUsed.toDouble(),
                              maxValue: sub.planId == 'free' ? 1.0 : 5.0,
                              unit: 'إعلان نشط',
                              onUpgrade: () => context.push('/subscription/plans'),
                              onBuyAddon: () => context.push('/subscription/addons'),
                            ),
                            UsageProgressCard(
                              title: 'مساحة التخزين المستخدمة للملفات',
                              usedValue: usage.storageUsedGb,
                              maxValue: sub.planId == 'free' ? 1.0 : 5.0,
                              unit: 'جيجابايت',
                              onUpgrade: () => context.push('/subscription/plans'),
                              onBuyAddon: () => context.push('/subscription/addons'),
                            ),
                            UsageProgressCard(
                              title: 'الموظفون الإضافيون والحسابات الفرعية',
                              usedValue: usage.employeesUsed.toDouble(),
                              maxValue: sub.planId == 'free' ? 1.0 : 5.0,
                              unit: 'حساب موظف',
                              onUpgrade: () => context.push('/subscription/plans'),
                              onBuyAddon: () => context.push('/subscription/addons'),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    final actions = [
      {'label': 'ترقية الباقة', 'icon': Icons.upgrade, 'route': '/subscription/plans'},
      {'label': 'شراء ملحقات', 'icon': Icons.grid_view, 'route': '/subscription/addons'},
      {'label': 'المركز المالي', 'icon': Icons.account_balance_wallet_outlined, 'route': '/subscription/billing'},
      {'label': 'الفواتير والرسوم', 'icon': Icons.receipt_long, 'route': '/subscription/invoices'},
      {'label': 'وسائل الدفع', 'icon': Icons.credit_card, 'route': '/subscription/methods'},
      {'label': 'تقارير الأداء', 'icon': Icons.analytics_outlined, 'route': '/subscription/analytics'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 1.1,
      ),
      itemCount: actions.length,
      itemBuilder: (context, index) {
        final act = actions[index];
        return Card(
          elevation: 0.5,
          color: Theme.of(context).colorScheme.surface,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
            side: BorderSide(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: InkWell(
            onTap: () => context.push(act['route'] as String),
            borderRadius: BorderRadius.circular(10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(act['icon'] as IconData, color: const Color(0xFF0040E0), size: 24),
                SizedBox(height: 6),
                Text(
                  act['label'] as String,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
