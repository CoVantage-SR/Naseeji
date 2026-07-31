import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/dashboard_providers.dart';
import '../shared/dashboard_card_widget.dart';
import '../shared/dashboard_section_title_widget.dart';
import '../shared/dashboard_loading_widget.dart';

class FinanceOverviewWidget extends ConsumerWidget {
  const FinanceOverviewWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final financeAsync = ref.watch(financeProvider);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DashboardSectionTitleWidget(
          title: 'الملخص المالي والضمان (Escrow)',
          subtitle: 'متابعة المستحقات والأموال المعلقة والمدفوعات',
          icon: Icons.account_balance_wallet_rounded,
          actionText: 'المركز المالي',
          onActionTap: () => context.push('/financial'),
        ),
        financeAsync.when(
          loading: () => const DashboardLoadingWidget(height: 180),
          error: (err, stack) => Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('خطأ في تحميل الملخص المالي: $err'),
          ),
          data: (fin) {
            return DashboardCardWidget(
              padding: const EdgeInsets.all(16),
              gradient: LinearGradient(
                colors: [
                  colorScheme.surface,
                  colorScheme.primaryContainer.withValues(alpha: 0.05),
                ],
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
              ),
              child: Column(
                children: [
                  // Main Escrow Highlight Box
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.primary.withValues(alpha: 0.25),
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
                            Text(
                              'رصيد الضمان المحتجز (Escrow Balance)',
                              style: TextStyle(
                                fontSize: 13,
                                color: colorScheme.onPrimary.withValues(alpha: 0.85),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Icon(
                              Icons.security_rounded,
                              color: colorScheme.onPrimary,
                              size: 20,
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          '${fin.escrowBalance.toStringAsFixed(2)} ${fin.currency}',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: colorScheme.onPrimary,
                            height: 1.1,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'يُحَرَّر تلقائياً فور تأكيد تسليم الشحنة',
                          style: TextStyle(
                            fontSize: 11,
                            color: colorScheme.onPrimary.withValues(alpha: 0.75),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 14),

                  // 4 Financial Metrics Grid
                  Row(
                    children: [
                      Expanded(
                        child: _buildFinanceMetricCard(
                          context,
                          title: 'مدفوعات معلقة',
                          value: '${fin.pendingPayments.toStringAsFixed(0)} ${fin.currency}',
                          icon: Icons.hourglass_empty_rounded,
                          color: Colors.orange.shade800,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildFinanceMetricCard(
                          context,
                          title: 'مدفوعات محررة',
                          value: '${fin.releasedPayments.toStringAsFixed(0)} ${fin.currency}',
                          icon: Icons.payments_outlined,
                          color: const Color(0xFF2E7D32),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: _buildFinanceMetricCard(
                          context,
                          title: 'الإيراد الشهري',
                          value: '${fin.monthlyRevenue.toStringAsFixed(0)} ${fin.currency}',
                          icon: Icons.trending_up_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: _buildFinanceMetricCard(
                          context,
                          title: 'فواتير غير مسددة',
                          value: '${fin.outstandingInvoices.toStringAsFixed(0)} ${fin.currency}',
                          icon: Icons.receipt_long_outlined,
                          color: const Color(0xFFC2185B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFinanceMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: colorScheme.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}



