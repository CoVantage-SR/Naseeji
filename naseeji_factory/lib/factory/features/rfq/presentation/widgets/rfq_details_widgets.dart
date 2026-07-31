import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_radius.dart';
import '../../../../../../core/constants/app_spacing.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../../../../core/widgets/reusable_widgets.dart';
import '../providers/rfq_provider.dart';

/// 1. RFQStatusHeaderWidget
class RFQStatusHeaderWidget extends StatelessWidget {
  final RFQ rfq;

  const RFQStatusHeaderWidget({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (rfq.status) {
      case 'open':
        statusColor = AppColors.info;
        statusText = 'مفتوح للتقديم';
        break;
      case 'negotiation':
        statusColor = AppColors.secondary;
        statusText = 'قيد التفاوض';
        break;
      case 'approved':
        statusColor = AppColors.success;
        statusText = 'مقبول ومعتمد';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'مرفوض أو ملغي';
        break;
      case 'expired':
      default:
        statusColor = Colors.grey;
        statusText = 'منتهي الصلاحية';
        break;
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.1),
        borderRadius: AppRadius.rMD,
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline_rounded, color: statusColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'حالة الطلب الحالية: $statusText',
                  style: TextStyle(fontWeight: FontWeight.bold, color: statusColor, fontSize: 13),
                ),
                Text(
                  'تم النشر في ${rfq.createdDate} وينتهي في ${rfq.expiryDate}',
                  style: const TextStyle(fontSize: 10, color: Colors.grey),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 2. ProductInformationWidget
class ProductInformationWidget extends StatelessWidget {
  final RFQ rfq;

  const ProductInformationWidget({super.key, required this.rfq});

  @override
  Widget build(BuildContext context) {
    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'تفاصيل المنتج والمواصفات',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary),
          ),
          const SizedBox(height: 6),
          const Divider(),
          const SizedBox(height: 8),
          _buildRow('الخامة المطلوبة', rfq.material),
          _buildRow('اللون المفضل', rfq.color),
          _buildRow('المقاس / العرض', rfq.size),
          _buildRow('مستوى الجودة المطلوب', rfq.qualityLevel),
          _buildRow('الكمية المطلوبة', '${rfq.requestedQty} ${rfq.unit}'),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              label,
              style: const TextStyle(color: Colors.grey, fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(
              value,
              textAlign: TextAlign.left,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}

/// 3. RFQTimelineWidget
class RFQTimelineWidget extends StatelessWidget {
  final String status;

  const RFQTimelineWidget({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final steps = [
      {'title': 'إنشاء طلب عرض السعر', 'done': true},
      {'title': 'إرسال الدعوات للموردين', 'done': true},
      {'title': 'استلام ومناقشة العروض البديلة', 'done': status == 'negotiation' || status == 'approved'},
      {'title': 'اعتماد العرض والتحويل لأمر شراء', 'done': status == 'approved'},
    ];

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الخط الزمني للطلب',
            style: context.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
          ),
          AppSpacing.hMD,
          for (int i = 0; i < steps.length; i++) ...[
            TimelineTile(
              title: steps[i]['title'] as String,
              description: (steps[i]['done'] as bool) ? 'مكتمل' : 'قيد الانتظار',
              time: i == steps.length - 1 && status == 'approved' ? '٢٠٢٦/٠٧/١٤' : '',
              icon: (steps[i]['done'] as bool) ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: (steps[i]['done'] as bool) ? AppColors.success : Colors.grey,
              isLast: i == steps.length - 1,
            ),
          ],
        ],
      ),
    );
  }
}
