import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationStatusCard extends StatelessWidget {
  final QuotationModel quotation;

  const QuotationStatusCard({super.key, required this.quotation});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String statusText = '';
    double progress = 0.0;
    String stageText = '';
    String completionText = '';

    switch (quotation.status) {
      case QuotationStatus.draft:
        statusColor = Colors.grey;
        statusText = 'مسودة عرض السعر';
        progress = 0.15;
        stageText = 'تجهيز العرض الفني والمالي';
        completionText = 'غير مرسل';
        break;
      case QuotationStatus.sent:
        statusColor = Colors.blue;
        statusText = 'تم إرسال العرض للمشتري';
        progress = 0.40;
        stageText = 'مراجعة المشتري ومطابقة المواصفات';
        completionText = 'بانتظار الرد';
        break;
      case QuotationStatus.underNegotiation:
        statusColor = Colors.orange;
        statusText = 'قيد التفاوض النشط';
        progress = 0.60;
        stageText = 'تبادل عروض مقابل وتعديل الأسعار';
        completionText = 'تعديلات مستمرة';
        break;
      case QuotationStatus.accepted:
        statusColor = Colors.green;
        statusText = 'مقبول ومعتمد';
        progress = 1.0;
        stageText = 'تم قبول العرض وإنشاء اتفاقية رقم ${quotation.orderNumber ?? ""}';
        completionText = 'مكتمل';
        break;
      case QuotationStatus.rejected:
        statusColor = Colors.red;
        statusText = 'مرفوض من المصنع';
        progress = 1.0;
        stageText = 'عرض مرفوض ومؤرشف في السجل';
        completionText = 'مغلق';
        break;
      case QuotationStatus.expired:
        statusColor = Colors.grey.shade700;
        statusText = 'منتهي الصلاحية';
        progress = 1.0;
        stageText = 'انقضت مهلة سريان العرض';
        completionText = 'غير صالح';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                statusText,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: statusColor),
              ),
              Text(
                'مستوى التقدم: ${(progress * 100).toInt()}%',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: statusColor),
              ),
            ],
          ),
          SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              color: statusColor,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              minHeight: 6,
            ),
          ),
          SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('المرحلة الحالية:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
              Text(
                stageText,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('حالة الاعتماد:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
              Text(
                completionText,
                style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: statusColor),
              ),
            ],
          ),
          if (quotation.status == QuotationStatus.rejected && quotation.rejectionReason != null) ...[
            SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(8)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('سبب الرفض المعتمد:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10, color: AppColors.error)),
                  SizedBox(height: 4),
                  Text(
                    quotation.rejectionReason!,
                    style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}



