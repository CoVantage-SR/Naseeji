import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';

class ShipmentHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const ShipmentHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تتبع شحنة الطلب: ${order.id}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
              StatusChip(label: 'بوليصة الشحن نشطة', color: AppColors.success),
            ],
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          _buildItem('شركة النقل', order.shippingCompany),
          _buildItem('رقم البوليصة', order.trackingNumber),
          _buildItem('الوزن التقريبي', '٣.٥ طن متري'),
          _buildItem('الحالة والناقل', order.carrierStatus),
        ],
      ),
    );
  }

  Widget _buildItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(flex: 2, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10, fontWeight: FontWeight.bold))),
          Expanded(flex: 3, child: Text(value, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10))),
        ],
      ),
    );
  }
}

class TrackingTimelineWidget extends StatelessWidget {
  final String status;

  const TrackingTimelineWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final stages = [
      {'title': 'خرجت الشحنة من مقر المورد', 'desc': 'تم استلام الشحنة وتوقيع الأوراق الجمركية واللوجستية', 'time': '2026/07/13 - 10:00 ص', 'done': true},
      {'title': 'تم استلام الشحنة من شركة النقل', 'desc': 'في طريقها لمستودع الفرز الرئيسي', 'time': '2026/07/13 - 02:00 م', 'done': true},
      {'title': 'الشحنة في العبور (In Transit)', 'desc': 'طريق القاهرة - الإسكندرية الصحراوي', 'time': '2026/07/14 - 08:00 ص', 'done': status == 'shipping' || status == 'delivered'},
      {'title': 'وصلت لمركز التوزيع الإقليمي', 'desc': 'جاري الفرز والتحميل لسيارات التوصيل النهائي', 'time': 'بانتظار الوصول', 'done': status == 'delivered'},
      {'title': 'خرجت للتوصيل النهائي', 'desc': 'سيارة التوصيل رقم ٩٩٣١ س ر ج م', 'time': 'بانتظار التحميل', 'done': status == 'delivered'},
      {'title': 'تم التسليم والاعتماد', 'desc': 'تم تسليم الشحنة وتوقيع إيصال الاستلام الفعلي', 'time': 'بانتظار الاستلام', 'done': status == 'delivered'},
    ];

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'خط سير الشحنة والعمليات اللوجستية',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: stages.length,
            itemBuilder: (context, index) {
              final stage = stages[index];
              final done = stage['done'] as bool;
              return TimelineTile(
                title: stage['title'] as String,
                description: stage['desc'] as String,
                time: stage['time'] as String,
                icon: done ? Icons.local_shipping_rounded : Icons.radio_button_unchecked_rounded,
                color: done ? AppColors.success : Colors.grey,
                isLast: index == stages.length - 1,
              );
            },
          ),
        ],
      ),
    );
  }
}

class ShipmentProgressWidget extends StatelessWidget {
  final OrderModel order;

  const ShipmentProgressWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'مؤشر التوصيل والشحن المالي',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'الموقع الحالي: ${order.currentLocation}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.primary),
              ),
              Text(
                order.status == 'delivered' ? 'مكتمل' : 'جاري العبور',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: order.status == 'delivered' ? 1.0 : 0.65,
            color: AppColors.primary,
            backgroundColor: Colors.grey.shade200,
            borderRadius: AppRadius.rRound,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class EstimatedArrivalWidget extends StatelessWidget {
  final String date;

  const EstimatedArrivalWidget({super.key, required this.date});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.primary, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'الوقت المتوقع لوصول الشحنة',
                  style: TextStyle(color: Colors.grey, fontSize: 10),
                ),
                Text(
                  date,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

