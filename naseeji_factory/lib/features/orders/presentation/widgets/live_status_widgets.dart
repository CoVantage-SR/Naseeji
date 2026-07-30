import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_radius.dart';
import '../../../../../core/widgets/reusable_widgets.dart';
import '../providers/orders_provider.dart';

class LiveStatusHeaderWidget extends StatelessWidget {
  final OrderModel order;

  const LiveStatusHeaderWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'البث المباشر للطلب: ${order.id}',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
            ),
            const Row(
              children: [
                CircleAvatar(radius: 4, backgroundColor: AppColors.success),
                SizedBox(width: 6),
                Text('بث مباشر نشط', style: TextStyle(color: AppColors.success, fontSize: 9, fontWeight: FontWeight.bold)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'تحديثات فورية مباشرة من مصنع خط الإنتاج والشحن البري.',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class CurrentStatusCardWidget extends StatelessWidget {
  final OrderModel order;

  const CurrentStatusCardWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;

    switch (order.status) {
      case 'new':
        statusColor = AppColors.info;
        statusText = 'مؤكد حديثاً';
        break;
      case 'preparing':
        statusColor = AppColors.secondary;
        statusText = 'قيد التجهيز الفعلي';
        break;
      case 'readyToShip':
        statusColor = AppColors.warning;
        statusText = 'جاهز للتسليم والتحميل';
        break;
      case 'shipping':
        statusColor = Colors.purple;
        statusText = 'على الطريق للوصول';
        break;
      case 'delivered':
        statusColor = AppColors.success;
        statusText = 'تم التوصيل المعتمد';
        break;
      case 'cancelled':
      default:
        statusColor = AppColors.error;
        statusText = 'ملغي / تحت النزاع';
        break;
    }

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('حالة الشحنة الفورية', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('نسبة الإنجاز الإجمالية للطلب', style: TextStyle(color: Colors.grey.shade600, fontSize: 10)),
              Text('${order.progressPercentage.toInt()}%', style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 6),
          LinearProgressIndicator(
            value: order.progressPercentage / 100.0,
            color: statusColor,
            backgroundColor: Colors.grey.shade200,
            borderRadius: AppRadius.rRound,
            minHeight: 6,
          ),
        ],
      ),
    );
  }
}

class CountdownWidget extends StatelessWidget {
  final int remainingDays;

  const CountdownWidget({super.key, required this.remainingDays});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      color: AppColors.primary.withValues(alpha: 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.timer_outlined, color: AppColors.primary, size: 36),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'الزمن المتبقي للتسليم الفعلي المتوقع',
                style: TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
              ),
              Text(
                '$remainingDays أيام عمل متبقية',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: AppColors.primary),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LatestUpdatesWidget extends StatelessWidget {
  final String updateText;

  const LatestUpdatesWidget({super.key, required this.updateText});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر إشعار وتحديث تشغيلي مستلم',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
          ),
          const SizedBox(height: 8),
          const Divider(),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.notification_important_outlined, color: AppColors.secondary, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  updateText,
                  style: const TextStyle(fontSize: 11, height: 1.4, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class LatestMediaWidget extends StatelessWidget {
  const LatestMediaWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر وسائط مرئية مستلمة',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.rMD,
                    image: const DecorationImage(
                      image: NetworkImage('https://images.unsplash.com/photo-1544816155-12df9643f363'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  height: 90,
                  decoration: BoxDecoration(
                    borderRadius: AppRadius.rMD,
                    color: Colors.black.withValues(alpha: 0.05),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      const Icon(Icons.video_collection_outlined, color: Colors.grey),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.black.withValues(alpha: 0.55),
                        child: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 14),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TimelinePreviewWidget extends StatelessWidget {
  final OrderModel order;

  const TimelinePreviewWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('معاينة سريعة لجدول الأحداث', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11)),
              TextButton(
                onPressed: () => context.push('/orders/${order.id}/timeline'),
                child: const Text('عرض السجل بالكامل', style: TextStyle(fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 10),
          TimelineTile(
            title: 'إتمام 60% من الإنتاج الفعلي للطلب',
            description: 'جاري تشغيل خط اللف والتعبئة على البكر البلاستيكي المخصص.',
            time: '2026/07/12 - 11:00 ص',
            icon: Icons.check_circle_rounded,
            color: AppColors.success,
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class QuickActionsWidget extends StatelessWidget {
  final OrderModel order;

  const QuickActionsWidget({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'روابط وإجراءات سريعة للبث',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: AppColors.primary),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.push('/chat/1'),
                  icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                  label: const Text('فتح دردشة الاتفاق', style: TextStyle(fontSize: 10)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => context.push('/orders/${order.id}/shipment'),
                  icon: const Icon(Icons.local_shipping_outlined, size: 16),
                  label: const Text('تفاصيل الشحن', style: TextStyle(fontSize: 10)),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.primary,
                    side: const BorderSide(color: AppColors.primary),
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
