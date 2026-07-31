import 'package:flutter/material.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/extensions/context_extensions.dart';
import '../../../../../core/widgets/reusable_widgets.dart';

import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';
import '../common/primary_button_widget.dart';
import '../common/secondary_button_widget.dart';

class SupplierCardWidget extends StatelessWidget {
  final FavoriteSupplier supplier;
  final VoidCallback onViewProfileTap;
  final VoidCallback onSendRfqTap;

  const SupplierCardWidget({
    super.key,
    required this.supplier,
    required this.onViewProfileTap,
    required this.onSendRfqTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return CardContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              SupplierAvatar(
                name: supplier.supplierName,
                logoUrl: supplier.logo,
                size: 48,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            supplier.supplierName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: context.textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Icon(Icons.star_rounded, color: Colors.amber, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              supplier.rating.toString(),
                              style: context.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'آخر تعامل: ${supplier.lastDeal}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: SecondaryButtonWidget(
                  label: 'الملف الشخصي',
                  icon: Icons.person_outline_rounded,
                  onPressed: onViewProfileTap,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: PrimaryButtonWidget(
                  label: 'إرسال طلب سعر',
                  icon: Icons.send_rounded,
                  onPressed: onSendRfqTap,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}



