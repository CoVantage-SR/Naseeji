import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/widgets/reusable_widgets.dart';

import '../../../domain/entities/home_entities.dart';

class OrderCardWidget extends StatelessWidget {
  final CurrentOrder order;
  final VoidCallback onTrackTap;

  const OrderCardWidget({
    super.key,
    required this.order,
    required this.onTrackTap,
  });

  @override
  Widget build(BuildContext context) {
    Color progressColor = AppColors.primary;
    if (order.status == 'قيد الشحن') progressColor = AppColors.info;
    if (order.status == 'مكتمل' || order.status == 'تم التسليم') progressColor = AppColors.success;
    if (order.status == 'ملغي') progressColor = AppColors.error;

    return ProgressCard(
      title: order.orderNumber,
      subtitle: order.supplier,
      progress: order.progress,
      progressColor: progressColor,
      footerLeft: 'الحالة: ${order.status}',
      footerRight: 'التسليم المتوقع: ${order.estimatedDelivery}',
      onTap: onTrackTap,
    );
  }
}
