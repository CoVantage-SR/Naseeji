import 'package:flutter/material.dart';
import 'package:naseeji_factory/factory/core/constants/app_colors.dart';
import 'package:naseeji_factory/factory/core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import 'statistic_card_widget.dart';

class StatisticGridWidget extends StatelessWidget {
  final HomeStatistics statistics;
  final VoidCallback? onCompletedOrdersTap;
  final VoidCallback? onPendingOrdersTap;
  final VoidCallback? onNewQuotesTap;
  final VoidCallback? onShipmentsTap;
  final VoidCallback? onPurchasesTap;
  final VoidCallback? onFavoritesTap;

  const StatisticGridWidget({
    super.key,
    required this.statistics,
    this.onCompletedOrdersTap,
    this.onPendingOrdersTap,
    this.onNewQuotesTap,
    this.onShipmentsTap,
    this.onPurchasesTap,
    this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    final columnsCount = context.responsiveValue(mobile: 2, tablet: 3).toInt();

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: columnsCount,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
      childAspectRatio: context.responsiveValue(mobile: 1.35, tablet: 1.4),
      children: [
        StatisticCardWidget(
          label: 'طلبات مكتملة',
          value: statistics.completedOrders.toString(),
          icon: Icons.check_circle_outline_rounded,
          color: AppColors.success,
          onTap: onCompletedOrdersTap,
        ),
        StatisticCardWidget(
          label: 'طلبات قيد التنفيذ',
          value: statistics.pendingOrders.toString(),
          icon: Icons.pending_actions_rounded,
          color: AppColors.primary,
          onTap: onPendingOrdersTap,
        ),
        StatisticCardWidget(
          label: 'عروض أسعار جديدة',
          value: statistics.newQuotations.toString(),
          icon: Icons.request_quote_outlined,
          color: AppColors.secondary,
          onTap: onNewQuotesTap,
        ),
        StatisticCardWidget(
          label: 'شحنات جارية',
          value: statistics.shipments.toString(),
          icon: Icons.local_shipping_outlined,
          color: AppColors.info,
          onTap: onShipmentsTap,
        ),
        StatisticCardWidget(
          label: 'مشتريات الشهر',
          value: '${statistics.monthlyPurchases.toInt()} ج.م',
          icon: Icons.payment_rounded,
          color: Colors.deepPurple,
          onTap: onPurchasesTap,
        ),
        StatisticCardWidget(
          label: 'الموردين المفضلين',
          value: statistics.favoriteSuppliers.toString(),
          icon: Icons.favorite_rounded,
          color: Colors.pink,
          onTap: onFavoritesTap,
        ),
      ],
    );
  }
}
