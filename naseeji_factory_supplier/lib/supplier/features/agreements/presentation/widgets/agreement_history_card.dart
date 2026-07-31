import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';
import '../../domain/entities/agreement_model.dart';

class AgreementHistoryCard extends StatelessWidget {
  final AgreementHistoryRecord record;

  const AgreementHistoryCard({super.key, required this.record});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).colorScheme.surfaceContainerLow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.primary, size: 16),
              SizedBox(width: 8),
              Text(
                record.action,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Theme.of(context).colorScheme.onSurface),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(4)),
                child: Text('نسخة v${record.versionNumber}', style: TextStyle(fontSize: 8, color: Color(0xFF0040E0), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          SizedBox(height: 6),
          Row(
            children: [
              Text('المستخدم: ${record.user}', style: TextStyle(fontSize: 10, color: AppColors.outline)),
              const Spacer(),
              Text(record.timestamp, style: TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
          SizedBox(height: 6),
          Divider(height: 1, color: AppColors.surfaceContainerLow),
          SizedBox(height: 6),
          Text(
            'السبب/التفاصيل: ${record.reason}',
            style: TextStyle(fontSize: 10, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}
