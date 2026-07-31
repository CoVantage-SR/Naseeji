import 'package:flutter/material.dart';
import '../../domain/entities/deal_model.dart';

class DealFilterBarWidget extends StatelessWidget {
  final DealStatus? selectedStatus;
  final ValueChanged<DealStatus?> onStatusChanged;

  const DealFilterBarWidget({
    super.key,
    required this.selectedStatus,
    required this.onStatusChanged,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final tabs = [
      {'status': null, 'label': 'الكل', 'count': null, 'badgeColor': null},
      {'status': DealStatus.negotiation, 'label': 'مفاوضات', 'count': 8, 'badgeColor': const Color(0xFFEA580C)},
      {'status': DealStatus.waitingSupplierReview, 'label': 'بانتظار رد المصنع', 'count': 12, 'badgeColor': const Color(0xFF2563EB)},
      {'status': DealStatus.production, 'label': 'قيد التنفيذ', 'count': 5, 'badgeColor': const Color(0xFF16A34A)},
      {'status': DealStatus.completed, 'label': 'مكتملة', 'count': null, 'badgeColor': null},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      reverse: true, // RTL layout alignment
      child: Row(
        children: tabs.map((tab) {
          final status = tab['status'] as DealStatus?;
          final label = tab['label'] as String;
          final count = tab['count'] as int?;
          final badgeColor = tab['badgeColor'] as Color?;
          final isSelected = selectedStatus == status;

          return Padding(
            padding: const EdgeInsets.only(left: 6),
            child: InkWell(
              onTap: () => onStatusChanged(isSelected ? null : status),
              borderRadius: BorderRadius.circular(10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? (isDark ? const Color(0xFF1E3A8A) : const Color(0xFFEFF6FF))
                      : (isDark ? const Color(0xFF1E293B) : const Color(0xFFF3F4F6)),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: isSelected
                        ? (isDark ? const Color(0xFF3B82F6) : const Color(0xFFBFDBFE))
                        : (isDark ? const Color(0xFF334155) : Colors.transparent),
                    width: 1,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (count != null && badgeColor != null) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: isDark ? badgeColor.withValues(alpha: 0.25) : badgeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: isDark ? badgeColor.withValues(alpha: 0.9) : badgeColor,
                            height: 1.0,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
                        color: isSelected
                            ? (isDark ? const Color(0xFF60A5FA) : const Color(0xFF2563EB))
                            : (isDark ? const Color(0xFF94A3B8) : const Color(0xFF4B5563)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}


