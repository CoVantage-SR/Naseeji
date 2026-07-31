import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';

/// 1. RevisionCardWidget
class RevisionCardWidget extends StatelessWidget {
  final QuotationRevision revision;

  const RevisionCardWidget({super.key, required this.revision});

  @override
  Widget build(BuildContext context) {
    final isFactory = revision.user == 'المصنع';

    return PrimaryCard(
      color: isFactory ? AppColors.primary.withValues(alpha: 0.03) : AppColors.secondary.withValues(alpha: 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'مراجعة رقم #${revision.revisionNumber}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
              ),
              StatusChip(
                label: 'بواسطة: ${revision.user}',
                color: isFactory ? AppColors.primary : AppColors.secondary,
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'تاريخ التعديل: ${revision.date}',
            style: const TextStyle(color: Colors.grey, fontSize: 10),
          ),
          const SizedBox(height: 10),
          const Divider(),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildColumn('السعر المقترح', '${revision.price.toInt()} ج.م'),
              _buildColumn('الكمية', '${revision.quantity} وحدة'),
              _buildColumn('تاريخ التسليم', revision.deliveryDate),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'التغييرات المطبقة:',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Text(
            revision.changes,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
          ),
          if (revision.notes.isNotEmpty) ...[
            const SizedBox(height: 10),
            const Text(
              'ملاحظات إضافية:',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
            ),
            const SizedBox(height: 4),
            Text(
              revision.notes,
              style: const TextStyle(fontSize: 11, fontStyle: FontStyle.italic),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildColumn(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        const SizedBox(height: 2),
        Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }
}


