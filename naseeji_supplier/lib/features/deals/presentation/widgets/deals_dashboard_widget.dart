import 'package:flutter/material.dart';
import '../../domain/entities/deal_model.dart';

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
    final cardsData = [
      _DashboardCardItem(
        title: 'إجمالي الصفقات',
        count: 51,
        growthText: '+ 10 هذا الشهر',
        icon: Icons.local_mall_outlined,
        iconColor: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
        statusKey: null,
      ),
      _DashboardCardItem(
        title: 'مفاوضات',
        count: 8,
        growthText: '+ 1 هذا الشهر',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: const Color(0xFFEA580C),
        bgColor: const Color(0xFFFFF7ED),
        statusKey: DealStatus.negotiation,
      ),
      _DashboardCardItem(
        title: 'بانتظار رد المصنع',
        count: 12,
        growthText: '+ 3 هذا الشهر',
        icon: Icons.access_time_rounded,
        iconColor: const Color(0xFF2563EB),
        bgColor: const Color(0xFFEFF6FF),
        statusKey: DealStatus.waitingSupplierReview,
      ),
      _DashboardCardItem(
        title: 'قيد التنفيذ',
        count: 7,
        growthText: '+ 2 هذا الشهر',
        icon: Icons.local_shipping_outlined,
        iconColor: const Color(0xFF9333EA),
        bgColor: const Color(0xFFF3E8FF),
        statusKey: DealStatus.production,
      ),
      _DashboardCardItem(
        title: 'مكتملة',
        count: 24,
        growthText: '+ 4 هذا الشهر',
        icon: Icons.check_circle_outline_rounded,
        iconColor: const Color(0xFF16A34A),
        bgColor: const Color(0xFFF0FDF4),
        statusKey: DealStatus.completed,
      ),
    ];

    return SizedBox(
      height: 124,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: cardsData.length,
        separatorBuilder: (_, __) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final item = cardsData[index];
          final isSelected = activeFilter == item.statusKey;

          return InkWell(
            onTap: () {
              if (isOnlyActionRequired) onToggleActionRequired(false);
              onSelectFilter(isSelected ? null : item.statusKey);
            },
            borderRadius: BorderRadius.circular(14),
            child: Container(
              width: 106,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? item.iconColor : const Color(0xFFE5E7EB),
                  width: isSelected ? 1.5 : 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Icon
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: item.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      size: 16,
                      color: item.iconColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Count
                  Text(
                    '${item.count}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111827),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 2),

                  // Label
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Monthly Growth Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        '↑ ',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                      Text(
                        item.growthText,
                        style: const TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF16A34A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _DashboardCardItem {
  final String title;
  final int count;
  final String growthText;
  final IconData icon;
  final Color iconColor;
  final Color bgColor;
  final DealStatus? statusKey;

  const _DashboardCardItem({
    required this.title,
    required this.count,
    required this.growthText,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
    this.statusKey,
  });
}
