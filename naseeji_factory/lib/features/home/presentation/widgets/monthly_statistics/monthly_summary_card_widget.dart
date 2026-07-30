import 'package:flutter/material.dart';
import '../../../../../../../core/constants/app_colors.dart';
import '../../../../../../../core/extensions/context_extensions.dart';
import '../../../domain/entities/home_entities.dart';
import '../common/card_container_widget.dart';
import 'mini_chart_widget.dart';

class MonthlySummaryCardWidget extends StatelessWidget {
  final MonthlyStatistics monthlyStats;

  const MonthlySummaryCardWidget({
    super.key,
    required this.monthlyStats,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.theme.brightness == Brightness.dark;
    final isPositive = monthlyStats.growthPercentage >= 0;

    return CardContainerWidget(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'إجمالي المشتريات الشهرية',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${monthlyStats.purchaseSummary.toInt()} ج.م',
                    style: context.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up_rounded : Icons.trending_down_rounded,
                    color: isPositive ? AppColors.success : AppColors.error,
                    size: 20,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${isPositive ? '+' : ''}${monthlyStats.growthPercentage}%',
                    style: context.textTheme.titleMedium?.copyWith(
                      color: isPositive ? AppColors.success : AppColors.error,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          MiniChartWidget(dataPoints: monthlyStats.chartData),
        ],
      ),
    );
  }
}
