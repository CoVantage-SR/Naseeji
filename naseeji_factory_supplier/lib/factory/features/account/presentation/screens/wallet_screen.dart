import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../providers/account_provider.dart';
import '../widgets/account_dialogs.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final wallet = ref.watch(walletProvider);
    final isDark = context.theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.surfaceDark : AppColors.surfaceLight;
    final border = isDark ? AppColors.borderDark : AppColors.borderLight;
    final textPrimary = isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;
    final textSecondary = isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Scaffold(
      appBar: AppBar(
        title: const Text('المحفظة والحساب البنكي'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_forward_rounded),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(),
          children: [
            // Balance Card
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.primaryDark, AppColors.primary],
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                ),
                borderRadius: AppRadius.rLG,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'الرصيد المتاح للسحب',
                        style: TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          borderRadius: AppRadius.rRound,
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.shield_rounded, color: Colors.white, size: 12),
                            SizedBox(width: 4),
                            Text('حساب موثق', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${_formatCurrency(wallet.balance)} ${wallet.currency}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.history_toggle_off_rounded, color: Colors.white70, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        'الرصيد المعلق: ${_formatCurrency(wallet.pendingBalance)} ${wallet.currency}',
                        style: const TextStyle(color: Colors.white70, fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppColors.primaryDark,
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                          ),
                          icon: const Icon(Icons.arrow_upward_rounded, size: 18),
                          label: const Text('سحب أرباح'),
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => WithdrawMoneyDialog(
                                currentBalance: wallet.balance,
                                onWithdraw: (amt, bankId) {
                                  ref.read(accountNotifierProvider.notifier).withdrawMoney(amt, bankId);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('تم إرسال طلب سحب ${amt.toInt()} ج.م للبنك بنجاح.')),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                          ),
                          icon: const Icon(Icons.add_rounded, size: 18),
                          label: const Text('إيداع سريح'),
                          onPressed: () {
                            ref.read(accountNotifierProvider.notifier).depositMoney(10000);
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('تم إضافة إيداع تجريبي بقيمة 10,000 ج.م للمحفظة!')),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            AppSpacing.hLG,

            // Bank accounts & Instapay section
            Text('طرق السحب والإيداع المرتبطة', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
            AppSpacing.hSM,
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
                  ...wallet.bankAccounts.map((bank) => ListTile(
                        leading: const Icon(Icons.account_balance_rounded, color: AppColors.primary),
                        title: Text(bank.bankName, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                        subtitle: Text('${bank.accountName} • ${bank.accountNumber}', style: TextStyle(color: textSecondary, fontSize: 11)),
                        trailing: bank.isDefault
                            ? Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                                decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.1), borderRadius: AppRadius.rRound),
                                child: const Text('رئيسي', style: TextStyle(color: AppColors.primary, fontSize: 10, fontWeight: FontWeight.bold)),
                              )
                            : null,
                      )),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.bolt_rounded, color: AppColors.secondary),
                    title: Text('عنوان انستا باي Instapay', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                    subtitle: Text(wallet.instapayHandle, style: TextStyle(color: textSecondary, fontSize: 11)),
                    trailing: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 18),
                  ),
                ],
              ),
            ),

            AppSpacing.hLG,

            // Transactions History
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('سجل المعاملات المالية', style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 15)),
                TextButton(
                  onPressed: () => context.push('/purchases/invoices'),
                  child: const Text('عرض الفواتير'),
                ),
              ],
            ),
            AppSpacing.hSM,

            ...wallet.transactions.map((txn) => Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: surface,
                    borderRadius: AppRadius.rMD,
                    border: Border.all(color: border),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: (txn.isCredit ? AppColors.success : AppColors.error).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          txn.isCredit ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: txn.isCredit ? AppColors.success : AppColors.error,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(txn.title, style: TextStyle(color: textPrimary, fontWeight: FontWeight.bold, fontSize: 13)),
                            const SizedBox(height: 2),
                            Text('${txn.type} • ${txn.date}', style: TextStyle(color: textSecondary, fontSize: 11)),
                          ],
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${txn.isCredit ? '+' : '-'}${_formatCurrency(txn.amount)} ${wallet.currency}',
                            style: TextStyle(
                              color: txn.isCredit ? AppColors.success : textPrimary,
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            txn.status,
                            style: TextStyle(
                              color: txn.status == 'مكتمل' ? AppColors.success : AppColors.warning,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  String _formatCurrency(double amount) {
    return amount.toInt().toString().replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+$)'),
          (match) => '${match[1]},',
        );
  }
}



