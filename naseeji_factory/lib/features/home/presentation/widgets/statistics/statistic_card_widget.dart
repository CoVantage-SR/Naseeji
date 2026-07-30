import 'package:flutter/material.dart';
import '../../../../../../../core/widgets/reusable_widgets.dart';

class StatisticCardWidget extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final String? trendText;
  final bool trendPositive;
  final VoidCallback? onTap;

  const StatisticCardWidget({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    this.trendText,
    this.trendPositive = true,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return StatisticsCard(
      label: label,
      value: value,
      icon: icon,
      color: color,
      trendText: trendText,
      trendPositive: trendPositive,
      onTap: onTap,
    );
  }
}
