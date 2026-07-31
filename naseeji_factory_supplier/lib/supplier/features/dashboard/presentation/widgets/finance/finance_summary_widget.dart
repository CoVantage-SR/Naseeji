import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_section_title.dart';
import '../shared/finance_card.dart';
import '../shared/loading_widget.dart';
import '../shared/error_state_widget.dart';

class FinanceSummaryWidget extends ConsumerWidget {
  const FinanceSummaryWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitle(
          title: 'الخزينة والمركز المالي',
          subtitle: 'متابعة أين أموالك المستحقة ورصيد الضمان فوراً',
          icon: Icons.account_balance_wallet_rounded,
          actionText: 'المركز المالي',
          onActionTap: () => context.push('/financial'),
        ),
        financeAsync.when(
          loading: () => const LoadingWidget(height: 160),
          error: (err, stack) => ErrorStateWidget(
            message: 'خطأ في تحميل بيانات المالية: $err',
            onRetry: () => ref.invalidate(financeProvider),
          ),
          data: (fin) {
            return FinanceCard(finance: fin);
          },
        ),
      ],
    );
  }
}

