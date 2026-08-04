import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';
import '../widgets/account_dialogs.dart';

class SubscriptionScreen extends ConsumerWidget {
  const SubscriptionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final sub = ref.watch(subscriptionProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('الاشتراك والفواتير'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        physics: const BouncingScrollPhysics(),
        children: [
          // Current Subscription Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('الخطة الحالية', style: TextStyle(color: textSecondary, fontSize: 12)),
                        Text('باقة ${sub.planName}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.success.withValues(alpha: 0.1),
                        borderRadius: AppRadius.rRound,
                      ),
                      child: Text(sub.status, style: const TextStyle(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Row(
                  children: [
                    const Icon(Icons.date_range_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('تاريخ البدء: ${sub.startDate}', style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('تاريخ الانتهاء: ${sub.expiryDate} (${sub.remainingDays} يوم متبقي)',
                        style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 10),
                const Divider(height: 1),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('المنتجات المضافة في المنصة:', style: TextStyle(color: textPrimary, fontSize: 12, fontWeight: FontWeight.bold)),
                    Text('${sub.productsPurchased} من ${sub.productsLimit}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: AppRadius.rRound,
                  child: LinearProgressIndicator(
                    value: sub.productsPurchased / sub.productsLimit,
                    backgroundColor: border,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                    minHeight: 6,
                  ),
                ),
                const SizedBox(height: 6),
                Text('المنتجات المتبقية المتاحة للإضافة: ${sub.productsLimit - sub.productsPurchased} منتج', style: TextStyle(color: textSecondary, fontSize: 11)),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => RenewPlanDialog(
                              onConfirm: () {
                                ref.read(accountNotifierProvider.notifier).renewSubscription(sub.planName);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('تم تجديد الاشتراك بنجاح!')),
                                );
                              },
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('تجديد الاشتراك'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (_) => UpgradePlanDialog(
                              onSelectPlan: (newPlan) {
                                ref.read(accountNotifierProvider.notifier).renewSubscription(newPlan);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text('تم الترقية إلى باقة $newPlan بنجاح!')),
                                );
                              },
                            ),
                          );
                        },
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                        ),
                        child: const Text('ترقية الخطة'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Invoices & History
          Text('سجل الفواتير وعمليات التجديد', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Material(
            color: surface,
            borderRadius: AppRadius.rLG,
            clipBehavior: Clip.antiAlias,
            shape: RoundedRectangleBorder(
              borderRadius: AppRadius.rLG,
              side: BorderSide(color: border),
            ),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  title: Text('فاتورة تجديد الاشتراك السنوي - خطة بريميوم', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('2024/06/20 • 12,000 ج.م • تم الدفع'),
                  trailing: IconButton(
                    icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                    tooltip: 'تحميل الفاتورة',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري تحميل الفاتورة بصيغة PDF...')),
                      );
                    },
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                  title: Text('فاتورة حزمة منتجات إضافية (10 منتجات)', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: const Text('2025/01/15 • 2,500 ج.م • تم الدفع'),
                  trailing: IconButton(
                    icon: const Icon(Icons.file_download_outlined, color: AppColors.primary),
                    tooltip: 'تحميل الفاتورة',
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('جاري تحميل الفاتورة بصيغة PDF...')),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



