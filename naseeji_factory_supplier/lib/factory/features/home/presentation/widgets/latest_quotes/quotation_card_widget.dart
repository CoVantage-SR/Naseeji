import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';
import 'package:naseeji_factory/core/widgets/reusable_widgets.dart';

import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';
import '../common/primary_button_widget.dart';
import '../common/secondary_button_widget.dart';

class QuotationCardWidget extends StatelessWidget {
  final LatestQuotation quotation;
  final VoidCallback onCompareTap;
  final VoidCallback onApproveTap;
  final VoidCallback onRejectTap;

  const QuotationCardWidget({
    super.key,
    required this.quotation,
    required this.onCompareTap,
    required this.onApproveTap,
    required this.onRejectTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SupplierAvatar(name: quotation.supplier, size: 40),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      quotation.supplier,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          quotation.rating.toString(),
                          style: context.textTheme.bodySmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildInfoColumn(context, 'السعر المقدم', '${quotation.price.toInt()} ج.م'),
              _buildInfoColumn(context, 'مدة التوصيل المقترحة', quotation.deliveryTime),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: TextButton(
                  onPressed: onRejectTap,
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.error,
                  ),
                  child: const Text('رفض العرض'),
                ),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: SecondaryButtonWidget(
                  label: 'مقارنة',
                  icon: Icons.compare_arrows_rounded,
                  onPressed: onCompareTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButtonWidget(
                  label: 'قبول',
                  icon: Icons.check_rounded,
                  onPressed: onApproveTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoColumn(BuildContext context, String label, String value) {
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



