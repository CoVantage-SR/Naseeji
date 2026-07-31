import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_radius.dart';
import '../../../products/presentation/providers/suppliers_provider.dart';

/// 5 Compact Clickable Statistics Cards Bar
class SupplierStatsCards extends StatelessWidget {
  final Supplier supplier;
  final Function(int tabIndex)? onStatTap;

  const SupplierStatsCards({
    super.key,
    required this.supplier,
    this.onStatTap,
  });

  @override
  Widget build(BuildContext context) {
    final stats = [
      {
        'val': supplier.avgDeliveryDays,
        'label': 'مدة التسليم',
        'icon': Icons.access_time_rounded,
        'color': Colors.blue,
        'tab': 4, // Commercial Info tab
      },
      {
        'val': supplier.certificatesCount.toString(),
        'label': 'شهادات',
        'icon': Icons.workspace_premium_outlined,
        'color': Colors.amber.shade800,
        'tab': 2, // Certificates tab
      },
      {
        'val': supplier.clientsCount.toString(),
        'label': 'عملاء',
        'icon': Icons.people_outline_rounded,
        'color': Colors.purple,
        'tab': 5, // Company Info tab
      },
      {
        'val': supplier.completedOrders.toString(),
        'label': 'صفقة مكتملة',
        'icon': Icons.handshake_outlined,
        'color': AppColors.success,
        'tab': 6, // Completed Deals tab
      },
      {
        'val': supplier.productsCount.toString(),
        'label': 'منتج',
        'icon': Icons.inventory_2_outlined,
        'color': AppColors.primary,
        'tab': 1, // Products tab
      },
    ];

    return Row(
      children: stats.map((item) {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3.0),
            child: _buildStatCard(
              context,
              val: item['val'] as String,
              label: item['label'] as String,
              icon: item['icon'] as IconData,
              color: item['color'] as Color,
              onTap: () {
                if (onStatTap != null) {
                  onStatTap!(item['tab'] as int);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('عرض قسم ${item['label']}')),
                  );
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required String val,
    required String label,
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: isDark ? AppColors.surfaceDark : Colors.white,
      borderRadius: AppRadius.rSM,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadius.rSM,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: AppRadius.rSM,
            border: Border.all(
              color: isDark ? AppColors.borderDark : Colors.grey.shade200,
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: color, size: 18),
              ),
              const SizedBox(height: 6),
              Text(
                val,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 2),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}



