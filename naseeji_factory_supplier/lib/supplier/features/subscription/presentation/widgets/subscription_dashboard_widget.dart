import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/subscription_controller.dart';

class SubscriptionDashboardBannerWidget extends ConsumerWidget {
  const SubscriptionDashboardBannerWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(currentSubscriptionProvider);
    if (sub == null) return const SizedBox.shrink();

    if (sub.isExpired) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.red.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.red.shade300),
        ),
        child: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade900, size: 24),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'تنبيه: انتهى اشتراكك الحالي (${sub.planName})',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.red.shade900),
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'تم إيقاف إضافة أو تعديل المنتجات. الصفقات والمحادثات الجارية مستمرة بشكل طبيعي.',
                    style: TextStyle(fontSize: 10, color: Colors.black87),
                  ),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => _showRenewOrUpgradeModal(context, ref, isRenew: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade700,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 34),
                padding: const EdgeInsets.symmetric(horizontal: 10),
              ),
              child: const Text('تجديد الآن 🔄', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      );
    }

    if (sub.isExpiringSoon) {
      return Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.amber.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.amber.shade400),
        ),
        child: Row(
          children: [
            Icon(Icons.timer_outlined, color: Colors.amber.shade900, size: 22),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'ينتهي اشتراكك خلال ${sub.remainingDays} أيام. جدد الآن للحفاظ على استمرارية النشر.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.amber.shade900),
              ),
            ),
            ElevatedButton(
              onPressed: () => _showRenewOrUpgradeModal(context, ref, isRenew: true),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.amber.shade800,
                foregroundColor: Colors.white,
                minimumSize: const Size(0, 32),
                padding: const EdgeInsets.symmetric(horizontal: 8),
              ),
              child: const Text('تجديد 🔄', style: TextStyle(fontSize: 11)),
            ),
          ],
        ),
      );
    }

    return const SizedBox.shrink();
  }

  static void _showRenewOrUpgradeModal(BuildContext context, WidgetRef ref, {bool isRenew = false}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isRenew ? Icons.autorenew_rounded : Icons.workspace_premium_rounded,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  isRenew ? 'تجديد الاشتراك الحالي' : 'ترقية باقة نسيجي',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              isRenew
                  ? 'سيتم تجديد باقتك الحالية لمدة شهر إضافي بنفس الحدود المتاحة.'
                  : 'اختر الباقة المناسبة للتوسع في إضافة المنتجات والوسائط والتصدير.',
              style: const TextStyle(fontSize: 12, color: Colors.grey),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () async {
                  Navigator.pop(context);
                  if (isRenew) {
                    await ref.read(subscriptionControllerProvider.notifier).renewSubscription();
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('تم تجديد الاشتراك بنجاح 🔄'), backgroundColor: Colors.green),
                      );
                    }
                  } else {
                    context.push('/subscription/plans');
                  }
                },
                icon: Icon(isRenew ? Icons.refresh_rounded : Icons.arrow_upward_rounded),
                label: Text(isRenew ? 'تاكيد التجديد لـ 30 يوماً' : 'عرض الخطط والباقات المتاحة'),
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 42)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SubscriptionDashboardWidget extends ConsumerWidget {
  const SubscriptionDashboardWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(currentSubscriptionProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (sub == null) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.workspace_premium_rounded, color: colorScheme.primary, size: 20),
                  const SizedBox(width: 6),
                  Text(
                    sub.planName,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: sub.isExpired ? Colors.red.shade50 : Colors.green.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: sub.isExpired ? Colors.red.shade300 : Colors.green.shade300),
                ),
                child: Text(
                  sub.isExpired ? 'منتهي' : 'نشط 🟢',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: sub.isExpired ? Colors.red.shade900 : Colors.green.shade900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          // Utilization Metrics Row
          Row(
            children: [
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: 'الأيام المتبقية',
                  value: '${sub.remainingDays} يوم',
                  icon: Icons.timer_outlined,
                  color: sub.remainingDays <= 7 ? Colors.amber.shade800 : colorScheme.primary,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: 'المنتجات المستخدمة',
                  value: '${sub.productsUsed} / ${sub.productsLimit}',
                  icon: Icons.inventory_2_outlined,
                  color: sub.remainingProducts == 0 ? Colors.orange.shade800 : Colors.blue.shade800,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricItem(
                  context,
                  title: 'المنتجات المتبقية',
                  value: '${sub.remainingProducts} منتج',
                  icon: Icons.add_shopping_cart_rounded,
                  color: Colors.green.shade800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Action Buttons: Upgrade & Renew
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _showUpgradeModal(context, ref),
                  icon: const Icon(Icons.arrow_upward_rounded, size: 14),
                  label: const Text('ترقية الباقة (Upgrade)', style: TextStyle(fontSize: 11)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colorScheme.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _showRenewModal(context, ref),
                  icon: const Icon(Icons.autorenew_rounded, size: 14),
                  label: const Text('تجديد الاشتراك (Renew)', style: TextStyle(fontSize: 11)),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 36),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricItem(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 13, color: color),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 9.5, color: Colors.grey.shade700),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: color),
          ),
        ],
      ),
    );
  }

  void _showUpgradeModal(BuildContext context, WidgetRef ref) {
    final plans = ref.read(subscriptionPlansProvider);
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'اختر الباقة المراد الترقية إليها',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
            ),
            const SizedBox(height: 12),
            ...plans.map(
              (p) => Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  title: Text(p.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text('حتى ${p.productsLimit} منتج • ${p.pricePerMonth} ج.م/شهر', style: const TextStyle(fontSize: 11)),
                  trailing: ElevatedButton(
                    onPressed: () async {
                      Navigator.pop(context);
                      await ref.read(subscriptionControllerProvider.notifier).upgradePlan(p);
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('تمت الترقية إلى ${p.name} بنجاح 🚀'), backgroundColor: Colors.green),
                        );
                      }
                    },
                    style: ElevatedButton.styleFrom(minimumSize: const Size(0, 32)),
                    child: const Text('اختيار', style: TextStyle(fontSize: 11)),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showRenewModal(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('تجديد الاشتراك الحالي'),
        content: const Text('هل ترغب في تجديد اشتراكك الحالي لمدة 30 يوماً إضافية بنفس الحدود والخصائص؟'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              await ref.read(subscriptionControllerProvider.notifier).renewSubscription();
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('تم تجديد الاشتراك بنجاح لمدة شهر 🟢'), backgroundColor: Colors.green),
                );
              }
            },
            child: const Text('تأكيد التجديد'),
          ),
        ],
      ),
    );
  }
}
