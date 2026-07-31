import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';

class PaymentMethodsScreen extends ConsumerWidget {
  const PaymentMethodsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final methods = ref.watch(paymentNotifierProvider);
    final wallet = ref.watch(walletProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('طرق الدفع والمحفظة'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Wallet Balance Card
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.primaryDark],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: AppRadius.rLG,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('رصيد المحفظة الحالي', style: TextStyle(color: Colors.white70, fontSize: 12)),
                const SizedBox(height: 4),
                Text('${wallet.balance.toStringAsFixed(0)} ${wallet.currency}',
                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 24)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: const Icon(Icons.add_rounded, size: 16),
                      label: const Text('شحن المحفظة'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(borderRadius: AppRadius.rSM),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text('طرق الدفع المسجلة', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: surface,
              borderRadius: AppRadius.rLG,
              border: Border.all(color: border),
            ),
            child: Column(
              children: methods.map((m) {
                final isDefault = m['isDefault'] == 'true';
                return ListTile(
                  leading: Icon(
                    m['type'] == 'بنكي' ? Icons.account_balance_rounded : Icons.credit_card_rounded,
                    color: AppColors.primary,
                  ),
                  title: Text(m['title']!, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                  subtitle: Text(m['subtitle']!, style: TextStyle(color: textSecondary, fontSize: 11)),
                  trailing: isDefault
                      ? Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                          decoration: BoxDecoration(
                            color: AppColors.primary.withValues(alpha: 0.1),
                            borderRadius: AppRadius.rRound,
                          ),
                          child: const Text('الافتراضي', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                        )
                      : null,
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}


