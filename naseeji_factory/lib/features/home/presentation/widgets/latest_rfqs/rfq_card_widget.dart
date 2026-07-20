import 'package:flutter/material.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';
import '../common/primary_button_widget.dart';
import '../common/secondary_button_widget.dart';
import '../common/status_chip_widget.dart';

class RFQCardWidget extends StatelessWidget {
  final LatestRFQ rfq;
  final VoidCallback onViewTap;
  final VoidCallback onContinueTap;

  const RFQCardWidget({
    super.key,
    required this.rfq,
    required this.onViewTap,
    required this.onContinueTap,
  });

  @override
  Widget build(BuildContext context) {
    Color statusColor = AppColors.warning;
    if (rfq.status == 'مقبول') statusColor = AppColors.success;
    if (rfq.status == 'مرفوض') statusColor = AppColors.error;
    if (rfq.status == 'تحت التفاوض') statusColor = AppColors.info;

    return CardContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  rfq.product,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              StatusChipWidget(label: rfq.status, color: statusColor),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildDetail(context, 'الكمية المطلوبة', '${rfq.quantity} وحدة'),
              _buildDetail(context, 'الميزانية المتوقعة', '${rfq.budget.toInt()} ج.م'),
              _buildDetail(context, 'الموردين المدعوين', '${rfq.supplierCount} موردين'),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryButtonWidget(
                  label: 'عرض التفاصيل',
                  icon: Icons.visibility_outlined,
                  onPressed: onViewTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButtonWidget(
                  label: 'متابعة الطلب',
                  icon: Icons.arrow_forward_rounded,
                  onPressed: onContinueTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(BuildContext context, String label, String value) {
    final isDark = context.theme.brightness == Brightness.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: context.textTheme.bodySmall?.copyWith(
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
            fontSize: 10,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: context.textTheme.labelMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
