import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

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
        children: [
          // Current Subscription Compact Card
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
                        Text(sub.planName, style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 18)),
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
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('تاريخ الانتهاء: ${sub.expiryDate} (${sub.remainingDays} يوم متبقي)',
                        style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.inventory_2_outlined, size: 14, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text('المنتجات المشتراة: ${sub.productsPurchased} من ${sub.productsLimit}',
                        style: TextStyle(color: textSecondary, fontSize: 12)),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {},
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
                        onPressed: () {},
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
          const SizedBox(height: 16),
          Text('سجل الفواتير السابقة', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: ListTile(
              leading: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
              title: Text('فاتورة اشتراك سنوي - خطة بريميوم', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
              subtitle: const Text('2024/06/20 • 12,000 ج.م'),
              trailing: const Icon(Icons.download_rounded, color: AppColors.primary),
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }
}
