import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/constants/app_radius.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';
import '../common/secondary_button_widget.dart';

class ShipmentCardWidget extends StatelessWidget {
  final Shipment shipment;
  final VoidCallback onTrackTap;

  const ShipmentCardWidget({
    super.key,
    required this.shipment,
    required this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;

    return CardContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.info.withValues(alpha: isDark ? 0.2 : 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.local_shipping_outlined, color: AppColors.info, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        shipment.shippingCompany,
                        style: context.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'رقم التتبع: ${shipment.trackingNumber}',
                        style: context.textTheme.bodySmall?.copyWith(
                          color: Colors.grey,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '${(shipment.progress * 100).toInt()}%',
                style: const TextStyle(
                  color: AppColors.info,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: AppRadius.rRound,
            child: LinearProgressIndicator(
              value: shipment.progress,
              color: AppColors.info,
              backgroundColor: isDark ? AppColors.borderDark : AppColors.borderLight,
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الموقع الحالي',
                      style: context.textTheme.bodySmall?.copyWith(
                        color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      shipment.currentLocation,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: context.textTheme.labelMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'الوصول المتوقع',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 10,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    shipment.eta,
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.info,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          SecondaryButtonWidget(
            label: 'تتبع الشحنة بالتفصيل',
            icon: Icons.map_outlined,
            fullWidth: true,
            onPressed: onTrackTap,
          ),
        ],
      ),
    );
  }
}
