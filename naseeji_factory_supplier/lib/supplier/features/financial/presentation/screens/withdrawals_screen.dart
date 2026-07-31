import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../controllers/financial_controllers.dart';
import '../widgets/withdrawal_card.dart';
import '../../domain/entities/financial_models.dart';

class WithdrawalsScreen extends ConsumerWidget {
  const WithdrawalsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final withdrawalsAsync = ref.watch(financialWithdrawalsControllerProvider);
    final walletAsync = ref.watch(financialWalletControllerProvider);
    final methodsAsync = ref.watch(financialPaymentMethodsControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'تسويات سحب الرصيد البنكي',
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
                ref.read(financialWithdrawalsControllerProvider.notifier).refresh();
                ref.read(financialWalletControllerProvider.notifier).refresh();
              },
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Available Balance card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
                      ),
                      child: Column(
                        children: [
                          Text(
                            'الرصيد المتاح للسحب البنكي حالياً',
                            style: TextStyle(fontSize: 12, color: AppColors.outline, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Text(
                            '${wallet.availableBalance.toStringAsFixed(2)} جنيه',
                            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                '1,000.00 جنيه',
                                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                              ),
                              Text(
                                'الحد الأدنى لعملية السحب',
                                style: TextStyle(fontSize: 12, color: AppColors.outline),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16),

                    // Default linked bank account
                    methodsAsync.when(
                      loading: () => const SizedBox.shrink(),
                      error: (err, s) => const SizedBox.shrink(),
                      data: (methods) {
                        final defaultMethod = methods.firstWhere(
                          (m) => m.isDefault,
                          orElse: () => methods.isNotEmpty ? methods.first : const PaymentMethod(id: '', type: 'bank_account', title: 'لا يوجد حساب افتراضي', subtitle: 'الرجاء إضافة حساب بنكي', accountHolder: '', identifier: '', isDefault: false, isVerified: false),
                        );

                        return Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F2FF),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: AppColors.primary.withValues(alpha: 0.15)),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.account_balance, color: AppColors.primary, size: 20),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      defaultMethod.title,
                                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                                    ),
                                    SizedBox(height: 2),
                                    Text(
                                      defaultMethod.identifier.isNotEmpty ? 'الآيبان: ${defaultMethod.identifier}' : defaultMethod.subtitle,
                                      textDirection: TextDirection.ltr,
                                      style: TextStyle(fontSize: 10, color: AppColors.outline),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 12),
                              Text(
                                'حساب الاستلام:',
                                style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    SizedBox(height: 24),

                    // Actions Button
                    ElevatedButton.icon(
                      onPressed: () => context.push('/finance/withdrawals/request'),
                      icon: const Icon(Icons.add_card, size: 18),
                      label: Text('طلب تسوية سحب جديد'),
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size.fromHeight(52),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    SizedBox(height: 24),

                    // Withdrawal requests history
                    Text(
                      'سجل عمليات وتصفيات الحساب',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurface),
                    ),
                    SizedBox(height: 10),

                    withdrawalsAsync.when(
                      loading: () => Center(child: CircularProgressIndicator()),
                      error: (err, stack) => Center(child: Text('خطأ: $err')),
                      data: (list) {
                        if (list.isEmpty) {
                          return Center(child: Text('لا توجد عمليات سحب سابقة'));
                        }

                        return ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: list.length,
                          itemBuilder: (context, index) {
                            return WithdrawalCard(
                              request: list[index],
                              onCancel: (id) async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text('تأكيد الإلغاء', textAlign: TextAlign.right),
                                    content: Text('هل أنت متأكد من رغبتك في إلغاء طلب السحب هذا؟ سيعاد الرصيد لمحفظتك فوراً.', textAlign: TextAlign.right),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text('تراجع')),
                                      TextButton(onPressed: () => Navigator.pop(ctx, true), child: Text('تأكيد الإلغاء', style: TextStyle(color: Colors.red))),
                                    ],
                                  ),
                                );

                                if (confirm == true) {
                                  await ref.read(financialWithdrawalsControllerProvider.notifier).cancelWithdrawal(id);
                                }
                              },
                            );
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
}
