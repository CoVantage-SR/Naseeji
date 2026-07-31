import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../providers/orders_provider.dart';
import 'orders_reusable_widgets.dart';

class TimelineHeaderWidget extends StatelessWidget {
  final String orderId;

  const TimelineHeaderWidget({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'سجل تتبع الأحداث التاريخي للطلب: $orderId',
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.primary),
        ),
        const SizedBox(height: 4),
        const Text(
          'تحديثات الحالة المعتمدة، خطوات الإنتاج، ومذكرات الاستلام والتوصيل الرسمية.',
          style: TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 10),
        const Divider(),
      ],
    );
  }
}

class TimelineWidget extends StatelessWidget {
  final List<OrderTimelineItem> items;

  const TimelineWidget({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 40.0),
          child: Text('لا توجد أحداث مسجلة حالياً.'),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        final isLast = index == items.length - 1;
        return TimelineItemWidget(
          item: item,
          isLast: isLast,
        );
      },
    );
  }
}

class TimelineItemWidget extends StatelessWidget {
  final OrderTimelineItem item;
  final bool isLast;

  const TimelineItemWidget({
    super.key,
    required this.item,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.1),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.3),
                  width: 1.5,
                ),
              ),
              child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 16),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 100,
                color: Colors.grey.shade300,
              ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.stage,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Text(
                    '${item.date} • ${item.time}',
                    style: const TextStyle(color: Colors.grey, fontSize: 9),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.notes,
                style: const TextStyle(fontSize: 10, height: 1.4),
              ),
              const SizedBox(height: 6),
              Text(
                'بواسطة: ${item.updatedBy}',
                style: const TextStyle(color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
              ),
              if (item.attachments.isNotEmpty) ...[
                const SizedBox(height: 8),
                TimelineAttachmentWidget(attachments: item.attachments),
              ],
              const SizedBox(height: 16),
            ],
          ),
        ),
      ],
    );
  }
}

class TimelineAttachmentWidget extends StatelessWidget {
  final List<String> attachments;

  const TimelineAttachmentWidget({super.key, required this.attachments});

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: attachments.map((fileName) {
        return AttachmentCard(
          fileName: fileName,
          onTap: () {},
        );
      }).toList(),
    );
  }
}



