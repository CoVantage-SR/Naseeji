// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:naseeji_factory/supplier/core/theme/app_colors.dart';

class FinancialChartWidget extends StatelessWidget {
  final String title;
  final List<Map<String, dynamic>> data;
  final String type; // 'bar', 'donut', 'double_bar'

  const FinancialChartWidget({
    super.key,
    required this.title,
    required this.data,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            textAlign: TextAlign.right,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 20),
          if (type == 'bar') _buildBarChart() else if (type == 'donut') _buildDonutChart() else _buildDoubleBarChart(),
        ],
      ),
    );
  }

  Widget _buildBarChart() {
    // Find max value for normalization
    double maxValue = 1.0;
    for (final item in data) {
      final val = (item['value'] as num).toDouble();
      if (val > maxValue) maxValue = val;
    }

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final label = item['month'] ?? item['day'] ?? '';
          final val = (item['value'] as num).toDouble();
          final normalizedHeight = maxValue > 0 ? (val / maxValue) : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Container(
                  width: 32,
                  alignment: Alignment.bottomCenter,
                  child: Tooltip(
                    message: '${val.toStringAsFixed(0)} جنيه',
                    child: Container(
                      height: 130 * normalizedHeight,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFF002080), Color(0xFF0040E0)],
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                        ),
                        borderRadius: BorderRadius.vertical(top: Radius.circular(6)),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: AppColors.outline),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDonutChart() {
    // We can draw a simple layout showing segments and color codes
    double total = 0.0;
    for (final item in data) {
      total += (item['value'] as num).toDouble();
    }

    return Column(
      children: [
        Center(
          child: SizedBox(
            width: 120,
            height: 120,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 110,
                  height: 110,
                  child: CircularProgressIndicator(
                    value: 0.75, // Simulated percentage representing the first/top categories
                    strokeWidth: 10,
                    backgroundColor: Colors.grey.shade100,
                    valueColor: const AlwaysStoppedAnimation<Color>(AppColors.primary),
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '١٠٠٪',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      'توزيع المبيعات',
                      style: TextStyle(fontSize: 9, color: AppColors.outline),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: 16),
        ...data.map((item) {
          final label = item['product'] ?? item['category'] ?? item['label'] ?? '';
          final val = (item['value'] as num).toDouble();
          final percent = total > 0 ? (val / total * 100) : 0.0;
          final colorVal = item['color'] as int? ?? 0xFF0040E0;

          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${percent.toStringAsFixed(1)}%',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                Row(
                  children: [
                    Text(
                      label,
                      style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                    ),
                    SizedBox(width: 8),
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Color(colorVal),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDoubleBarChart() {
    double maxValue = 1.0;
    for (final item in data) {
      final inflow = (item['inflow'] ?? item['revenue'] ?? 0.0) as num;
      final outflow = (item['outflow'] ?? item['expenses'] ?? 0.0) as num;
      if (inflow > maxValue) maxValue = inflow.toDouble();
      if (outflow > maxValue) maxValue = outflow.toDouble();
    }

    return SizedBox(
      height: 180,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: data.map((item) {
          final label = item['day'] ?? item['label'] ?? '';
          final inflow = ((item['inflow'] ?? item['revenue'] ?? 0.0) as num).toDouble();
          final outflow = ((item['outflow'] ?? item['expenses'] ?? 0.0) as num).toDouble();

          final hInflow = maxValue > 0 ? (inflow / maxValue) : 0.0;
          final hOutflow = maxValue > 0 ? (outflow / maxValue) : 0.0;

          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Tooltip(
                      message: 'صادر: ${outflow.toStringAsFixed(0)} جنيه',
                      child: Container(
                        width: 12,
                        height: 130 * hOutflow,
                        decoration: BoxDecoration(
                          color: Color(0xFFBA1A1A),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Tooltip(
                      message: 'وارد: ${inflow.toStringAsFixed(0)} جنيه',
                      child: Container(
                        width: 12,
                        height: 130 * hInflow,
                        decoration: BoxDecoration(
                          color: Color(0xFF00875A),
                          borderRadius: BorderRadius.vertical(top: Radius.circular(3)),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Text(
                label,
                style: TextStyle(fontSize: 10, color: AppColors.outline),
              ),
            ],
          );
        }).toList(),
      ),
    );
  }
}