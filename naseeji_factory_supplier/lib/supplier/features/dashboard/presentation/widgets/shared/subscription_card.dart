import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/subscription_overview_model.dart';
import 'dashboard_card.dart';

class SubscriptionCard extends StatelessWidget {
  final SubscriptionOverviewModel subscription;

  const SubscriptionCard({
    super.key,
    required this.subscription,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final String expireFormatted =
        '${subscription.expiryDate.day.toString().padLeft(2, '0')} ${_getMonthAbbr(subscription.expiryDate.month)}';

    return DashboardCard(
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Plan & Upgrade Button
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.workspace_premium_rounded,
                    color: Colors.amber.shade800,
                    size: 20,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    subscription.currentPlan,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: colorScheme.primary,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => context.push('/subscription/plans'),
                icon: const Icon(Icons.bolt_rounded, size: 14),
                label: const Text('ترقية'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  textStyle: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Divider(color: colorScheme.outlineVariant.withValues(alpha: 0.4), height: 1),
          const SizedBox(height: 10),

          // Compact Limits Grid (Products, RFQs, Ads, Expire)
          Row(
            children: [
              Expanded(
                child: _buildLimitColumn(
                  context,
                  label: 'المنتجات',
                  value: '${subscription.productsUsed} /${subscription.productsLimit}',
                  color: colorScheme.primary,
                ),
              ),
              Expanded(
                child: _buildLimitColumn(
                  context,
                  label: 'طلبات الأسعار',
                  value: '${subscription.rfqsUsed} /${subscription.rfqsLimit}',
                  color: const Color(0xFF006B5F),
                ),
              ),
              Expanded(
                child: _buildLimitColumn(
                  context,
                  label: 'الإعلانات',
                  value: '${subscription.advertisementsUsed} /${subscription.advertisementsLimit}',
                  color: Colors.orange.shade800,
                ),
              ),
              Expanded(
                child: _buildLimitColumn(
                  context,
                  label: 'الانتهاء',
                  value: expireFormatted,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLimitColumn(
    BuildContext context, {
    required String label,
    required String value,
    required Color color,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Column(
      children: [
        Text(
          label,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }

  String _getMonthAbbr(int month) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return months[(month - 1).clamp(0, 11)];
  }
}
