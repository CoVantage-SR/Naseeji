// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementStatusCard extends StatelessWidget {
  final B2BAgreement agreement;

  const AgreementStatusCard({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    Color statusColor = Colors.grey;
    String statusText = '';
    double progress = 0.0;
    String stageText = '';

    switch (agreement.status) {
      case AgreementStatus.pendingApproval:
        statusColor = Colors.orange;
        statusText = 'انتظار الموافقة';
        progress = 0.25;
        stageText = 'توقيع الطرفين';
        break;
      case AgreementStatus.active:
        statusColor = Colors.green;
        statusText = 'سارية ونشطة';
        progress = 0.65;
        stageText = 'مرحلة التوريد والإنتاج';
        break;
      case AgreementStatus.completed:
        statusColor = Colors.blue.shade800;
        statusText = 'مكتملة ومغلقة';
        progress = 1.0;
        stageText = 'تم التسليم والفسح المالي';
        break;
      case AgreementStatus.cancelled:
        statusColor = Colors.red;
        statusText = 'ملغاة';
        progress = 1.0;
        stageText = 'عقد ملغي ومجمد';
        break;
      case AgreementStatus.expired:
        statusColor = Colors.grey.shade700;
        statusText = 'منتهية الصلاحية';
        progress = 1.0;
        stageText = 'انقضاء فترة الصلاحية';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.all(Radius.circular(16)),
        boxShadow: [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
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
                'نسبة الإنجاز: ${(progress * 100).toInt()}%',
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
          SizedBox(height: 8),
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
          if (agreement.cancellationReason != null) ...[
            SizedBox(height: 8),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: Colors.red.shade50, borderRadius: BorderRadius.circular(6)),
              child: Text(
                'سبب الإلغاء: ${agreement.cancellationReason}',
                style: TextStyle(fontSize: 9, color: Colors.red.shade900, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
