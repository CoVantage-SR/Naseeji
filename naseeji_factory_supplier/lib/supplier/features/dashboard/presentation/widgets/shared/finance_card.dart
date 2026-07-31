import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/finance_overview_model.dart';
import 'dashboard_card.dart';

class FinanceCard extends StatelessWidget {
  final FinanceOverviewModel finance;

  const FinanceCard({
    super.key,
    required this.finance,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return DashboardCard(
      padding: const EdgeInsets.all(14),
      onTap: () => context.push('/financial'),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Escrow Highlight Banner
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'رصيد الضمان (Escrow Balance)',
                      style: TextStyle(
                        fontSize: 11,
                        color: colorScheme.onPrimary.withValues(alpha: 0.85),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${finance.escrowBalance.toStringAsFixed(0)} ${finance.currency}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
                Icon(
                  Icons.security_rounded,
                  color: colorScheme.onPrimary,
                  size: 24,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // 4 Finance Metrics
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'الإيراد الشهري',
                  value: '${finance.monthlyRevenue.toStringAsFixed(0)} ${finance.currency}',
                  color: colorScheme.primary,
                  icon: Icons.trending_up_rounded,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'مدفوعات معلقة',
                  value: '${finance.pendingPayments.toStringAsFixed(0)} ${finance.currency}',
                  color: Colors.orange.shade800,
                  icon: Icons.hourglass_empty_rounded,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'مدفوعات محررة',
                  value: '${finance.releasedPayments.toStringAsFixed(0)} ${finance.currency}',
                  color: const Color(0xFF2E7D32),
                  icon: Icons.payments_outlined,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildMetricTile(
                  context,
                  title: 'فواتير غير مسددة',
                  value: '${finance.outstandingInvoices.toStringAsFixed(0)} ${finance.currency}',
                  color: const Color(0xFFC2185B),
                  icon: Icons.receipt_long_outlined,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 10, color: colorScheme.onSurfaceVariant),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 12,
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
