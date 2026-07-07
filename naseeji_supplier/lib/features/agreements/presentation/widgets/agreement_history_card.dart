import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.surfaceContainerLow),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.history, color: AppColors.primary, size: 16),
              const SizedBox(width: 8),
              Text(
                record.action,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.onSurface),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(color: const Color(0xFFF0F5FF), borderRadius: BorderRadius.circular(4)),
                child: Text('نسخة v${record.versionNumber}', style: const TextStyle(fontSize: 8, color: Color(0xFF0040E0), fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Text('المستخدم: ${record.user}', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
              const Spacer(),
              Text(record.timestamp, style: const TextStyle(fontSize: 9, color: AppColors.outline)),
            ],
          ),
          const SizedBox(height: 6),
          const Divider(height: 1, color: AppColors.surfaceContainerLow),
          const SizedBox(height: 6),
          Text(
            'السبب/التفاصيل: ${record.reason}',
            style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant, height: 1.4),
          ),
        ],
      ),
    );
  }
}
