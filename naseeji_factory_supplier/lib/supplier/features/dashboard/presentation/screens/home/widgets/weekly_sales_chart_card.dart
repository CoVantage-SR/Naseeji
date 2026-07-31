// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import 'line_chart_painter.dart';

class WeeklySalesChartCard extends StatelessWidget {
  final List<double> weeklySales;

  const WeeklySalesChartCard({super.key, required this.weeklySales});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.outlineVariant.withValues(
            alpha: 0.3,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'تحليل المبيعات الأسبوعي',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Text(
                      'آخر 7 أيام',
                      style: TextStyle(
                        fontSize: 11,
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(
                      Icons.expand_more,
                      size: 14,
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          SizedBox(
            height: 120,
            width: double.infinity,
            child: CustomPaint(
              painter: LineChartPainter(weeklySales),
            ),
          ),
          SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'السبت',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الأحد',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الاثنين',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الثلاثاء',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الأربعاء',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الخميس',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
              Text(
                'الجمعة',
                style: TextStyle(
                  fontSize: 9,
                  color: AppColors.outline,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
