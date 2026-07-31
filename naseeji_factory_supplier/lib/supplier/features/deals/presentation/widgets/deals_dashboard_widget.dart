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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final cardsData = [
      const _DashboardCardItem(
        title: 'إجمالي الصفقات',
        count: 51,
        growthText: '+10 هذا الشهر',
        icon: Icons.local_mall_outlined,
        iconColor: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      ),
      const _DashboardCardItem(
        title: 'مفاوضات',
        count: 8,
        growthText: '+1 هذا الشهر',
        icon: Icons.chat_bubble_outline_rounded,
        iconColor: Color(0xFFEA580C),
        bgColor: Color(0xFFFFF7ED),
      ),
      const _DashboardCardItem(
        title: 'بانتظار رد المصنع',
        count: 12,
        growthText: '+3 هذا الشهر',
        icon: Icons.access_time_rounded,
        iconColor: Color(0xFF2563EB),
        bgColor: Color(0xFFEFF6FF),
      ),
      const _DashboardCardItem(
        title: 'قيد التنفيذ',
        count: 7,
        growthText: '+2 هذا الشهر',
        icon: Icons.local_shipping_outlined,
        iconColor: Color(0xFF9333EA),
        bgColor: Color(0xFFF3E8FF),
      ),
      const _DashboardCardItem(
        title: 'مكتملة',
        count: 24,
        growthText: '+4 هذا الشهر',
        icon: Icons.check_circle_outline_rounded,
        iconColor: Color(0xFF16A34A),
        bgColor: Color(0xFFF0FDF4),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: cardsData.asMap().entries.map((entry) {
          final index = entry.key;
          final item = entry.value;

          return Expanded(
            child: Container(
              margin: EdgeInsets.only(
                left: index == cardsData.length - 1 ? 0 : 5,
              ),
              padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF1E293B) : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isDark ? const Color(0xFF334155) : const Color(0xFFE5E7EB),
                  width: 1,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.02),
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
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: isDark ? item.iconColor.withValues(alpha: 0.2) : item.bgColor,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      item.icon,
                      size: 14,
                      color: isDark ? item.iconColor.withValues(alpha: 0.9) : item.iconColor,
                    ),
                  ),
                  const SizedBox(height: 6),

                  // Count
                  Text(
                    '${item.count}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDark ? Colors.white : const Color(0xFF111827),
                      height: 1.0,
                    ),
                  ),
                  const SizedBox(height: 3),

                  // Label (Title)
                  Text(
                    item.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 9.2,
                      fontWeight: FontWeight.w600,
                      color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563),
                    ),
                  ),
                  const SizedBox(height: 4),

                  // Monthly Growth Text
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          item.growthText,
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                          ),
                        ),
                        Text(
                          ' ↑',
                          style: TextStyle(
                            fontSize: 8,
                            fontWeight: FontWeight.bold,
                            color: isDark ? const Color(0xFF4ADE80) : const Color(0xFF16A34A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
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

  const _DashboardCardItem({
    required this.title,
    required this.count,
    required this.growthText,
    required this.icon,
    required this.iconColor,
    required this.bgColor,
  });
}


