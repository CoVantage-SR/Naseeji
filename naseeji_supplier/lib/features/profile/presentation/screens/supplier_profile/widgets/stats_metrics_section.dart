import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class StatsMetricsSection extends StatelessWidget {
  const StatsMetricsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Response rate
        _buildMetricCard(
          title: 'معدل الاستجابة',
          percentageValue: 0.98,
          percentageString: '98%',
          accentColor: Colors.blue,
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.arrow_upward, size: 12, color: Colors.green),
              SizedBox(width: 2),
              Text(
                '2% +',
                style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),

        // On-time delivery
        _buildMetricCard(
          title: 'التوصيل في الموعد',
          percentageValue: 0.95,
          percentageString: '95%',
          accentColor: Colors.green,
          trailingWidget: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check, size: 12, color: Colors.green),
              SizedBox(width: 2),
              Text(
                'ممتاز',
                style: TextStyle(fontSize: 11, color: Colors.green, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),

        // Customer Satisfaction rating
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'رضا العملاء',
                style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                          Icon(Icons.star, color: Colors.amber, size: 16),
                        ],
                      ),
                      SizedBox(height: 4),
                      Text(
                        'بناء على 1.2 ألف تقييم',
                        style: TextStyle(fontSize: 10, color: AppColors.outline),
                      ),
                    ],
                  ),
                  Text(
                    '4.8',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required double percentageValue,
    required String percentageString,
    required Color accentColor,
    required Widget trailingWidget,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              trailingWidget,
              Text(
                title,
                style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
            ],
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                percentageString,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              SizedBox(width: 16),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: percentageValue,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: AlwaysStoppedAnimation<Color>(accentColor),
                    minHeight: 6,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}