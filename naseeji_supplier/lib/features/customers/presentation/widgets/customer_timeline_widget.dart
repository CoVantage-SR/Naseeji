import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/customer_model.dart';

class CustomerTimelineWidget extends StatelessWidget {
  final List<CustomerTimelineEvent> events;

  const CustomerTimelineWidget({super.key, required this.events});

  @override
  Widget build(BuildContext context) {
    if (events.isEmpty) {
      return Center(
        child: Padding(
          padding: EdgeInsets.all(32),
          child: Text('لا توجد أحداث في السجل', style: TextStyle(color: AppColors.outline, fontSize: 13)),
        ),
      );
    }
    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: events.length,
      itemBuilder: (_, i) => _buildEvent(events[i], isLast: i == events.length - 1),
    );
  }

  Widget _buildEvent(CustomerTimelineEvent event, {required bool isLast}) {
    final categoryData = _getCategoryData(event.category);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left line + dot
          SizedBox(
            width: 40,
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: categoryData.$2.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(categoryData.$1, size: 14, color: categoryData.$2),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [categoryData.$2.withValues(alpha: 0.3), Colors.transparent],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          SizedBox(width: 10),
          // Content
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: isLast ? 0 : 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          event.title,
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.calendar_today_outlined, size: 10, color: AppColors.outline),
                      SizedBox(width: 4),
                      Text('${event.date} ${event.time}', style: TextStyle(fontSize: 9, color: AppColors.outline)),
                      SizedBox(width: 8),
                      const Icon(Icons.person_outline, size: 10, color: AppColors.outline),
                      SizedBox(width: 4),
                      Text(event.responsibleUser, style: TextStyle(fontSize: 9, color: AppColors.outline)),
                    ],
                  ),
                  if (event.notes.isNotEmpty) ...[
                    SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLow,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(event.notes, style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, height: 1.4)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  (IconData, Color) _getCategoryData(String category) {
    switch (category) {
      case 'order': return (Icons.shopping_bag_outlined, AppColors.primary);
      case 'quotation': return (Icons.description_outlined, AppColors.secondary);
      case 'agreement': return (Icons.handshake_outlined, const Color(0xFF993100));
      case 'payment': return (Icons.payments_outlined, Colors.green);
      case 'shipment': return (Icons.local_shipping_outlined, Colors.orange);
      default: return (Icons.circle_outlined, AppColors.outline);
    }
  }
}