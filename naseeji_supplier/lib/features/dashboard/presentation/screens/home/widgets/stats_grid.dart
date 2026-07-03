import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';
import '../../../domain/entities/sales_stats.dart';
import 'stat_card.dart';

class StatsGrid extends StatelessWidget {
  final SalesStats stats;

  const StatsGrid({super.key, required this.stats});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.4,
      children: [
        StatCard(
          title: 'مبيعات اليوم',
          value: '\$${stats.todaySales.toStringAsFixed(0)}k',
          trend: '+12%',
          color: AppColors.primary,
          icon: Icons.trending_up,
        ),
        StatCard(
          title: 'الإيرادات الشهرية',
          value: '\$${(stats.monthlyEarnings / 1000).toStringAsFixed(0)}k',
          trend: '+8%',
          color: AppColors.secondary,
          icon: Icons.trending_up,
        ),
        StatCard(
          title: 'طلبات معلقة',
          value: stats.pendingOrders.toString(),
          trend: 'تحتاج انتباه !',
          color: AppColors.tertiary,
          icon: Icons.priority_high,
          isWarning: true,
        ),
        StatCard(
          title: 'منتجات نشطة',
          value: stats.activeProducts.toString(),
          trend: 'مخزون جيد',
          color: AppColors.outline,
          icon: Icons.check_circle,
        ),
      ],
    );
  }
}
