import 'package:flutter/material.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/section_header_widget.dart';
import 'monthly_summary_card_widget.dart';

class MonthlyStatisticsWidget extends StatelessWidget {
  final MonthlyStatistics monthlyStats;
  final VoidCallback? onHeaderActionTap;

  const MonthlyStatisticsWidget({
    super.key,
    required this.monthlyStats,
    this.onHeaderActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeaderWidget(
          title: 'تحليل المشتريات الشهري',
          onActionTap: onHeaderActionTap,
        ),
        const SizedBox(height: 12),
        MonthlySummaryCardWidget(monthlyStats: monthlyStats),
      ],
    );
  }
}



