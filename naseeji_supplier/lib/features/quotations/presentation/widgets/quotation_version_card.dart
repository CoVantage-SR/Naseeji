import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../domain/entities/quotation_model.dart';

class QuotationVersionCard extends StatelessWidget {
  final QuotationRevisionModel revision;
  final bool isSelectedForComparison;
  final ValueChanged<bool?>? onSelectForCompare;
  final VoidCallback? onView;
  final VoidCallback? onDuplicate;
  final VoidCallback? onRestoreDraft;

  const QuotationVersionCard({
    super.key,
    required this.revision,
    this.isSelectedForComparison = false,
    this.onSelectForCompare,
    this.onView,
    this.onDuplicate,
    this.onRestoreDraft,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.primary;
    if (revision.status.contains('مقبول') || revision.status.contains('معتمد')) {
      statusColor = Colors.green;
    } else if (revision.status.contains('مرفوض')) {
      statusColor = Colors.red;
    } else if (revision.status.contains('تفاوض')) {
      statusColor = Colors.orange;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Color(0x03000000), blurRadius: 8, offset: Offset(0, 2))],
        border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header: Version & Select Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Row(
              children: [
                if (onSelectForCompare != null) ...[
                  Checkbox(
                    value: isSelectedForComparison,
                    onChanged: onSelectForCompare,
                    activeColor: AppColors.primary,
                  ),
                ],
                Text(
                  'نسخة العرض: ${revision.version}',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.primary),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    revision.status,
                    style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: statusColor),
                  ),
                ),
              ],
            ),
          ),
          Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Details grid
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildInfoColumn('سعر الوحدة المقترح', '${revision.supplierPrice.toStringAsFixed(2)} جنيه'),
                    _buildInfoColumn('العرض المقابل للمصنع', '${revision.factoryCounterOffer.toStringAsFixed(2)} جنيه'),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoColumn('فرق السعر التفاوضي', '${revision.priceDifference.toStringAsFixed(2)} جنيه'),
                    _buildInfoColumn('تاريخ الإنشاء والتعديل', revision.createdDate),
                  ],
                ),
                SizedBox(height: 8),
                Row(
                  children: [
                    _buildInfoColumn('بواسطة', revision.negotiatedBy),
                  ],
                ),
                if (revision.reason.isNotEmpty) ...[
                  SizedBox(height: 8),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.background,
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFFE2E1EF), width: 0.5),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ملاحظات المراجعة التفاوضية:', style: TextStyle(fontSize: 8, fontWeight: FontWeight.bold, color: AppColors.outline)),
                        SizedBox(height: 2),
                        Text(
                          revision.reason,
                          style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.onSurfaceVariant, height: 1.3),
                        ),
                      ],
                    ),
                  ),
                ]
              ],
            ),
          ),

          Divider(height: 1, color: AppColors.surfaceContainerLow),

          // Actions
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (onRestoreDraft != null)
                  TextButton.icon(
                    onPressed: onRestoreDraft,
                    icon: const Icon(Icons.restore_outlined, size: 12),
                    label: Text('استعادة كمسودة', style: TextStyle(fontSize: 9)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.outline),
                  ),
                if (onDuplicate != null)
                  TextButton.icon(
                    onPressed: onDuplicate,
                    icon: const Icon(Icons.copy_outlined, size: 12),
                    label: Text('تكرار النسخة', style: TextStyle(fontSize: 9)),
                    style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                  ),
                TextButton.icon(
                  onPressed: onView,
                  icon: const Icon(Icons.visibility_outlined, size: 12),
                  label: Text('عرض التفاصيل', style: TextStyle(fontSize: 9)),
                  style: TextButton.styleFrom(foregroundColor: AppColors.primary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(String label, String value) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 8, color: AppColors.outline)),
          SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.onSurface),
          ),
        ],
      ),
    );
  }
}