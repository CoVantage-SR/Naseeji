import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../../core/constants/app_spacing.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/widgets/reusable_widgets.dart';
import '../providers/quotations_provider.dart';

/// 1. QuotationCardWidget
class QuotationCardWidget extends StatelessWidget {
  final Quotation quotation;
  final bool isSelectedForComparison;
  final VoidCallback onCompareToggle;
  final VoidCallback onViewDetails;

  const QuotationCardWidget({
    super.key,
    required this.quotation,
    required this.isSelectedForComparison,
    required this.onCompareToggle,
    required this.onViewDetails,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor;
    String statusText;
    switch (quotation.status) {
      case 'accepted':
        statusColor = AppColors.success;
        statusText = 'مقبول';
        break;
      case 'rejected':
        statusColor = AppColors.error;
        statusText = 'مرفوض';
        break;
      case 'negotiating':
        statusColor = AppColors.secondary;
        statusText = 'تفاوض';
        break;
      case 'received':
      default:
        statusColor = AppColors.info;
        statusText = 'مستلم';
        break;
    }

    return PrimaryCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SupplierAvatar(name: quotation.supplierName, size: 44),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quotation.supplierName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 12),
                        const SizedBox(width: 2),
                        Text(
                          quotation.supplierRating.toString(),
                          style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              StatusChip(label: statusText, color: statusColor),
            ],
          ),
          AppSpacing.hMD,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildMetric('السعر المعروض', '${quotation.quotedPricePerUnit.toInt()} ج.م'),
              _buildMetric('الحد الأدنى (MOQ)', '${quotation.moq} وحدة'),
              _buildMetric('زمن التجهيز', '${quotation.prepTimeDays} أيام'),
              _buildMetric('زمن الشحن', '${quotation.shippingTimeDays} أيام'),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: onViewDetails,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                  ),
                  child: const Text('عرض تفاصيل العرض'),
                ),
              ),
              const SizedBox(width: 8),
              OutlinedButton.icon(
                onPressed: onCompareToggle,
                icon: Icon(
                  isSelectedForComparison ? Icons.check_circle_rounded : Icons.compare_arrows_rounded,
                  size: 16,
                ),
                label: Text(isSelectedForComparison ? 'محدد للمقارنة' : 'قارن'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: isSelectedForComparison ? AppColors.success : AppColors.primary,
                  side: BorderSide(
                    color: isSelectedForComparison ? AppColors.success : AppColors.primary,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppRadius.rMD),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetric(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 9, color: Colors.grey, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}

/// 2. SortWidget
class SortWidget extends StatelessWidget {
  final String activeSort;
  final ValueChanged<String> onSortChanged;

  const SortWidget({
    super.key,
    required this.activeSort,
    required this.onSortChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        children: [
          const Text(
            'ترتيب حسب: ',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey, fontSize: 11),
          ),
          const SizedBox(width: 8),
          _buildChip('السعر (الأقل أولاً)', 'price'),
          const SizedBox(width: 8),
          _buildChip('زمن التوصيل (الأسرع)', 'delivery'),
          const SizedBox(width: 8),
          _buildChip('التقييم', 'rating'),
        ],
      ),
    );
  }

  Widget _buildChip(String label, String key) {
    final isSelected = activeSort == key;
    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 10)),
      selected: isSelected,
      onSelected: (_) => onSortChanged(key),
      selectedColor: AppColors.primary.withValues(alpha: 0.1),
      labelStyle: TextStyle(
        color: isSelected ? AppColors.primary : Colors.grey,
        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.rRound,
        side: BorderSide(color: isSelected ? AppColors.primary : Colors.grey.shade300),
      ),
      showCheckmark: false,
    );
  }
}
