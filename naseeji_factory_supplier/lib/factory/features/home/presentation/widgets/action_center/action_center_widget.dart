import 'package:flutter/material.dart';
import 'package:naseeji_factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/core/constants/app_radius.dart';
import 'package:naseeji_factory/core/extensions/context_extensions.dart';

import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';

class ActionCenterWidget extends StatelessWidget {
  final List<ActionCenterAlert> alerts;
  final ValueChanged<ActionCenterAlert> onAlertTap;

  const ActionCenterWidget({
    super.key,
    required this.alerts,
    required this.onAlertTap,
  });

  @override
  Widget build(BuildContext context) {
    if (alerts.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.campaign_outlined, color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'مركز الإجراءات العاجلة',
                style: context.textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: const BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  alerts.length.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 100,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: alerts.length,
            itemBuilder: (context, index) {
              final alert = alerts[index];
              return _buildAlertCard(context, alert);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildAlertCard(BuildContext context, ActionCenterAlert alert) {
    final theme = context.theme;
    final isDark = theme.brightness == Brightness.dark;

    IconData icon = Icons.info_outline_rounded;
    Color color = AppColors.primary;

    switch (alert.type) {
      case 'pending_rfq':
        icon = Icons.request_quote_outlined;
        color = AppColors.warning;
        break;
      case 'shipment_today':
        icon = Icons.local_shipping_outlined;
        color = AppColors.info;
        break;
      case 'supplier_replied':
        icon = Icons.chat_bubble_outline_rounded;
        color = AppColors.success;
        break;
      case 'invoice_pending':
        icon = Icons.receipt_long_outlined;
        color = Colors.purple;
        break;
      case 'delayed_shipment':
        icon = Icons.warning_amber_rounded;
        color = AppColors.error;
        break;
    }

    return Container(
      width: 280,
      margin: const EdgeInsets.only(left: 12, bottom: 8, top: 4),
      child: CardContainerWidget(
        onTap: alert.isClickable ? () => onAlertTap(alert) : null,
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: isDark ? 0.2 : 0.1),
                borderRadius: AppRadius.rMD,
              ),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    alert.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    alert.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}



