import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'statistic_grid_widget.dart';

class StatisticsSectionWidget extends StatelessWidget {
  final HomeStatistics statistics;
  final VoidCallback? onHeaderActionTap;
  final VoidCallback? onCompletedOrdersTap;
  final VoidCallback? onPendingOrdersTap;
  final VoidCallback? onNewQuotesTap;
  final VoidCallback? onShipmentsTap;
  final VoidCallback? onPurchasesTap;
  final VoidCallback? onFavoritesTap;

  const StatisticsSectionWidget({
    super.key,
    required this.statistics,
    this.onHeaderActionTap,
    this.onCompletedOrdersTap,
    this.onPendingOrdersTap,
    this.onNewQuotesTap,
    this.onShipmentsTap,
    this.onPurchasesTap,
    this.onFavoritesTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'ملخص إحصاءات المصنع',
          actionLabel: 'التفاصيل',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        StatisticGridWidget(
          statistics: statistics,
          onCompletedOrdersTap: onCompletedOrdersTap,
          onPendingOrdersTap: onPendingOrdersTap,
          onNewQuotesTap: onNewQuotesTap,
          onShipmentsTap: onShipmentsTap,
          onPurchasesTap: onPurchasesTap,
          onFavoritesTap: onFavoritesTap,
        ),
      ],
    );
  }
}



