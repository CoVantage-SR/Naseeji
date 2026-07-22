import 'package:flutter/material.dart';
import '../domain/entities/deal_model.dart';

class DealsDashboardWidget extends StatelessWidget {
  final List<DealModel> deals;
  final DealStatus? activeFilter;
  final bool isOnlyActionRequired;
  final ValueChanged<DealStatus?> onSelectFilter;
  final ValueChanged<bool> onToggleActionRequired;

  const DealsDashboardWidget({
    super.key,
    required this.deals,
    required this.activeFilter,
    required this.isOnlyActionRequired,
    required this.onSelectFilter,
    required this.onToggleActionRequired,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final actionRequiredCount = deals.where((d) => d.status.requiresSupplierAction).length;
    final newDealsCount = deals.where((d) => d.status == DealStatus.newDeal).length;
    final negotiationCount = deals.where((d) => d.status == DealStatus.negotiation).length;
    final productionCount = deals.where((d) => d.status == DealStatus.production).length;
    final readyDeliveryCount = deals.where((d) => d.status == DealStatus.readyForDelivery).length;
    final qualityCount = deals.where((d) => d.status == DealStatus.qualityInspection).length;
    final paymentCount = deals.where((d) => d.status == DealStatus.paymentPending).length;
    final completedCount = deals.where((d) => d.status == DealStatus.completed).length;

    return SizedBox(
      height: 64,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        children: [
          // 1. يتطلب إجراء (Special Amber Card)
          _buildMiniCard(
            context,
            title: 'يتطلب إجراء',
            count: actionRequiredCount,
            icon: Icons.notifications_active_outlined,
            color: const Color(0xFFD97706),
            isSelected: isOnlyActionRequired,
            onTap: () => onToggleActionRequired(!isOnlyActionRequired),
          ),
          const SizedBox(width: 8),

          // 2. صفقات جديدة
          _buildMiniCard(
            context,
            title: 'صفقات جديدة',
            count: newDealsCount,
            icon: Icons.fiber_new_rounded,
            color: colorScheme.primary,
            isSelected: activeFilter == DealStatus.newDeal && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.newDeal ? null : DealStatus.newDeal);
            },
          ),
          const SizedBox(width: 8),

          // 3. قيد التفاوض
          _buildMiniCard(
            context,
            title: 'قيد التفاوض',
            count: negotiationCount,
            icon: Icons.handshake_outlined,
            color: const Color(0xFF8B5CF6),
            isSelected: activeFilter == DealStatus.negotiation && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.negotiation ? null : DealStatus.negotiation);
            },
          ),
          const SizedBox(width: 8),

          // 4. قيد الإنتاج
          _buildMiniCard(
            context,
            title: 'قيد الإنتاج',
            count: productionCount,
            icon: Icons.precision_manufacturing_outlined,
            color: const Color(0xFF06B6D4),
            isSelected: activeFilter == DealStatus.production && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.production ? null : DealStatus.production);
            },
          ),
          const SizedBox(width: 8),

          // 5. جاهزة للتسليم
          _buildMiniCard(
            context,
            title: 'جاهزة للتسليم',
            count: readyDeliveryCount,
            icon: Icons.inventory_2_outlined,
            color: const Color(0xFF14B8A6),
            isSelected: activeFilter == DealStatus.readyForDelivery && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.readyForDelivery ? null : DealStatus.readyForDelivery);
            },
          ),
          const SizedBox(width: 8),

          // 6. بانتظار الجودة
          _buildMiniCard(
            context,
            title: 'بانتظار الجودة',
            count: qualityCount,
            icon: Icons.fact_check_outlined,
            color: const Color(0xFFEAB308),
            isSelected: activeFilter == DealStatus.qualityInspection && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.qualityInspection ? null : DealStatus.qualityInspection);
            },
          ),
          const SizedBox(width: 8),

          // 7. بانتظار الدفع
          _buildMiniCard(
            context,
            title: 'بانتظار الدفع',
            count: paymentCount,
            icon: Icons.account_balance_wallet_outlined,
            color: const Color(0xFF84CC16),
            isSelected: activeFilter == DealStatus.paymentPending && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.paymentPending ? null : DealStatus.paymentPending);
            },
          ),
          const SizedBox(width: 8),

          // 8. المكتملة
          _buildMiniCard(
            context,
            title: 'المكتملة',
            count: completedCount,
            icon: Icons.check_circle_outline,
            color: const Color(0xFF16A34A),
            isSelected: activeFilter == DealStatus.completed && !isOnlyActionRequired,
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(activeFilter == DealStatus.completed ? null : DealStatus.completed);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMiniCard(
    BuildContext context, {
    required String title,
    required int count,
    required IconData icon,
    required Color color,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? color : colorScheme.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? color : colorScheme.outlineVariant.withValues(alpha: 0.5),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(5),
              decoration: BoxDecoration(
                color: isSelected ? Colors.white.withValues(alpha: 0.2) : color.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 14,
                color: isSelected ? Colors.white : color,
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected ? Colors.white : colorScheme.onSurface,
                  ),
                ),
                Text(
                  '$count صفقة',
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? Colors.white.withValues(alpha: 0.9) : colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
