import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementStatusCard extends StatelessWidget {
  final B2BAgreement agreement;

  const AgreementStatusCard({super.key, required this.agreement});

  @override
  Widget build(BuildContext context) {
    final statusColor = agreement.status.color;
    final statusText = agreement.status.titleAr;
    double progress = 0.0;
    String stageText = agreement.status.descriptionEg;

    switch (agreement.status) {
      case AgreementStatus.draft:
        progress = 0.1;
        break;
      case AgreementStatus.awaitingSupplierSignature:
        progress = 0.3;
        break;
      case AgreementStatus.awaitingFactorySignature:
        progress = 0.5;
        break;
      case AgreementStatus.active:
        progress = 0.7;
        break;
      case AgreementStatus.inProduction:
        progress = 0.85;
        break;
      case AgreementStatus.completed:
        progress = 1.0;
        break;
      case AgreementStatus.cancelled:
      case AgreementStatus.expired:
        progress = 1.0;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        boxShadow: const [BoxShadow(color: Color(0x05000000), blurRadius: 10)],
        border: Border.all(color: statusColor.withValues(alpha: 0.2)),
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
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              color: statusColor,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerLow,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('المرحلة الحالية:', style: TextStyle(fontSize: 10, color: AppColors.outline)),
              Expanded(
                child: Text(
                  stageText,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
              ),
            ],
          ),
          if (agreement.cancellationReason != null) ...[
            const SizedBox(height: 8),
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

