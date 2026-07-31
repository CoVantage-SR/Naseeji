import 'package:flutter/material.dart';
import 'package:naseeji_supplier/core/theme/app_colors.dart';

class PerformanceMetricsGrid extends StatelessWidget {
  final double totalSales;
  final String salesTrend;
  final bool isSalesPositive;
  
  final double netProfits;
  final String profitsTrend;
  final bool isProfitsPositive;
  
  final int totalCustomers;
  final String customersTrend;
  final bool isCustomersPositive;
  
  final int completedOrders;
  final String ordersTrend;
  final bool isOrdersPositive;

  const PerformanceMetricsGrid({
    super.key,
    required this.totalSales,
    required this.salesTrend,
    required this.isSalesPositive,
    required this.netProfits,
    required this.profitsTrend,
    required this.isProfitsPositive,
    required this.totalCustomers,
    required this.customersTrend,
    required this.isCustomersPositive,
    required this.completedOrders,
    required this.ordersTrend,
    required this.isOrdersPositive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMetricCard(
          title: 'إجمالي المبيعات',
          value: '${totalSales.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} جنيه',
          trend: salesTrend,
          isPositive: isSalesPositive,
          icon: Icons.show_chart,
          iconColor: const Color(0xFF0040E0),
          iconBgColor: const Color(0xFFE8EFFF),
          borderColor: const Color(0xFF0040E0),
        ),
        _buildMetricCard(
          title: 'صافي الأرباح',
          value: '${netProfits.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')} جنيه',
          trend: profitsTrend,
          isPositive: isProfitsPositive,
          icon: Icons.account_balance_wallet_outlined,
          iconColor: const Color(0xFF009688),
          iconBgColor: const Color(0xFFE0F2F1),
          borderColor: const Color(0xFF009688),
        ),
        _buildMetricCard(
          title: 'إجمالي العملاء',
          value: totalCustomers.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
          trend: customersTrend,
          isPositive: isCustomersPositive,
          icon: Icons.people_outline,
          iconColor: const Color(0xFFFF5722),
          iconBgColor: const Color(0xFFFFECE0),
          borderColor: const Color(0xFFFF5722),
        ),
        _buildMetricCard(
          title: 'الطلبات المكتملة',
          value: completedOrders.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},'),
          trend: ordersTrend,
          isPositive: isOrdersPositive,
          icon: Icons.inventory_2_outlined,
          iconColor: const Color(0xFF673AB7),
          iconBgColor: const Color(0xFFEDE7F6),
          borderColor: const Color(0xFF673AB7),
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required String title,
    required String value,
    required String trend,
    required bool isPositive,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required Color borderColor,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor.withValues(alpha: 0.6), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    isPositive ? Icons.trending_up : Icons.trending_down,
                    color: isPositive ? Colors.green : Colors.red,
                    size: 16,
                  ),
                  SizedBox(width: 4),
                  Text(
                    trend,
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: iconColor, size: 24),
              ),
            ],
          ),
          SizedBox(height: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: AppColors.outline,
            ),
          ),
          SizedBox(height: 4),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}