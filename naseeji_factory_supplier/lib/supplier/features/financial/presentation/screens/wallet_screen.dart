import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/wallet_balance_card.dart';
import '../widgets/transaction_card.dart';

class WalletScreen extends ConsumerWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final walletAsync = ref.watch(financialWalletControllerProvider);
    final txnsAsync = ref.watch(financialTransactionsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'المحفظة الرقمية',
          style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.bold, fontSize: 16),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: AppColors.onSurfaceVariant, size: 20),
          onPressed: () => context.pop(),
        ),
      ),
      body: Container(
        color: Theme.of(context).scaffoldBackgroundColor,
        child: walletAsync.when(
          loading: () => Center(child: CircularProgressIndicator(color: AppColors.primary)),
          error: (err, stack) => Center(child: Text('خطأ: $err')),
          data: (wallet) {
            return RefreshIndicator(
              color: AppColors.primary,
              onRefresh: () async {
                ref.read(financialWalletControllerProvider.notifier).refresh();
                ref.read(financialTransactionsControllerProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Gradient Balance Card
                    WalletBalanceCard(
                      available: wallet.availableBalance,
                      pending: wallet.pendingBalance,
                      frozen: wallet.frozenBalance,
                      onWithdraw: () => context.push('/finance/withdrawals/request'),
                    ),
                    SizedBox(height: 20),

                    // Additional stats
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          _buildStatRow('صافي الأرباح المحققة', '${wallet.totalEarnings.toStringAsFixed(2)} جنيه'),
                          const Divider(height: 20),
                          _buildStatRow('إجمالي الإيرادات مدى الحياة', '${wallet.lifetimeRevenue.toStringAsFixed(2)} جنيه'),
                          const Divider(height: 20),
                          _buildStatRow('رصيد الدعاية والإعلان بالمنصة', '${wallet.platformCredit.toStringAsFixed(2)} جنيه'),
                        ],
                      ),
                    ),
                    SizedBox(height: 24),

                    // Recent Wallet Activity
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () => context.push('/finance/transactions'),
                          child: Text('عرض الكل', style: TextStyle(color: AppColors.primary, fontSize: 12)),
                        ),
                        Text(
                          'آخر العمليات المالية للمحفظة',
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),

                    txnsAsync.when(
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (err, s) => Center(child: Text('خطأ في تحميل المعاملات: $err')),
                      data: (txns) {
                        final recent = txns.take(3).toList();
                        if (recent.isEmpty) {
                          return Center(
                            child: Text('لا توجد عمليات ماليّة مؤخراً', style: TextStyle(color: AppColors.outline)),
                          );
                        }
                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: recent.length,
                          itemBuilder: (context, index) {
                            return TransactionCard(transaction: recent[index]);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildStatRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          value,
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        Text(
          label,
          style: TextStyle(fontSize: 13, color: AppColors.outline),
        ),
      ],
    );
  }
}
