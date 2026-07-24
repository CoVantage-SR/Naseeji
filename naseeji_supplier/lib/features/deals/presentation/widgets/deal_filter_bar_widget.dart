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
                  color: isSelected ? const Color(0xFFEFF6FF) : const Color(0xFFF3F4F6),
                  borderRadius: BorderRadius.circular(10),
                  border: isSelected
                      ? Border.all(color: const Color(0xFFBFDBFE), width: 1)
                      : null,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (count != null && badgeColor != null) ...[
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: badgeColor.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '$count',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                            color: badgeColor,
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
                        color: isSelected ? const Color(0xFF2563EB) : const Color(0xFF4B5563),
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
